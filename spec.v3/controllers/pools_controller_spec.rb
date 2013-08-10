require 'spec_helper'

describe PoolsController do
  render_views


  #--------------------------------#
  #  Tests for non-signed-in users #
  #--------------------------------#
  describe "for non-signed-in users" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @pool = @user.pools.create(:name => "Pool 1", :poolType => 0, 
                                  :isPublic => true, :password => "foobar")
      @attr = { :name => "", :poolType => 4, :isPublic => "", 
                :password => "" }
    end

    it "should deny access to 'index'" do
      get :index
      response.should redirect_to(signin_path)
      flash[:notice].should =~ /sign in/i
    end

    it "should deny access to 'show'" do
      get :show, :id => @pool
      response.should redirect_to(signin_path)
      flash[:notice].should =~ /sign in/i
    end

    it "should deny access to 'join'" do
      get :join, :id => @pool
      response.should redirect_to(signin_path)
      flash[:notice].should =~ /sign in/i
    end

    it "should deny access to 'new'" do
      get :new
      response.should redirect_to(signin_path)
      flash[:notice].should =~ /sign in/i
    end
    it "should deny access to 'create'" do
      post :create, :pool => @attr
      response.should redirect_to(signin_path)
      flash[:notice].should =~ /sign in/i
    end

    it "should deny access to 'edit'" do
      get :edit, :id => @pool
      response.should redirect_to(signin_path)
      flash[:notice].should =~ /sign in/i
    end

    it "should deny access to 'update'" do
      put :update, :id => @pool, :pool => @attr
      response.should redirect_to(signin_path)
      flash[:notice].should =~ /sign in/i
    end

    it "should deny access to 'destroy'" do
      get :destroy, :id => @pool
      response.should redirect_to(signin_path)
      flash[:notice].should =~ /sign in/i
    end
  end

  #------------------------#
  #  Tests for GET 'index' #
  #------------------------#
  describe "GET 'index'" do

    before(:each) do
      # Create 2 users and sign-in the 2nd user
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      test_sign_in(@user1)
      # Create 4 new pools owned by @user1
      4.times do
        FactoryGirl.create(:pool_membership, :user => @user1,
                           :owner => true)
      end
      @poolUser2 = @user1.pools.create(:name => "Pool 3", :poolType => 2, 
                                       :isPublic => true, :password => "foobar")
      # Set the first pool to be private
      @pool = Pool.find(1)
      @pool.isPublic = false
      @pool.save
      # set the 2nd pool to PickEmSpread, 3rd to Survivor, and 4th to SUP
      poolType = 1
      idx = 2
      3.times do
        @pool = Pool.find(idx)
        @pool.poolType = poolType
        @pool.save
        poolType = poolType + 1
        idx = idx + 1
      end
      @pools = Pool.all
    end

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "All pools")
    end

    it "should have an element for each pool" do
      get :index
      @pools[0..3].each do |pool|
        response.should have_selector("td", :content => pool.name)
      end
    end

    it "should have the Public status for public pools"  do
      get :index
      response.should have_selector("td", :content => "Public")
    end

    it "should have the Private status for private pools"  do
      get :index
      response.should have_selector("td", :content => "Private")
    end

    it "should show Pickem for poolType 0"  do
      get :index
      response.should have_selector("td", :content => "PickEm")
    end

    it "should show PickemSpread for poolType 1"  do
      get :index
      response.should have_selector("td", :content => "PickEmSpread")
    end

    it "should show Survivor for poolType 2"  do
      get :index
      response.should have_selector("td", :content => "Survivor")
    end

    it "should show SUP for poolType 3"  do
      get :index
      response.should have_selector("td", :content => "SUP")
    end

    it "should not show the pool if owner user is deleted" do
      @user2.destroy
      get :show, :id => @poolUser2
      response.should_not have_selector("a", :content => @poolUser2.name)
    end

    it "should paginate pools"  do
      # Add 30 more pools for pagination testing
      30.times do
        FactoryGirl.create(:pool_membership, :user => @user1,
                           :owner => true)
      end
      get :index
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a", :href => "/pools?page=2",
                                         :content => "2")
      response.should have_selector("a", :href => "/pools?page=2",
                                         :content => "Next")
    end
  end

  #------------------------#
  #  Tests for GET 'show'  #
  #------------------------#
  describe "GET 'show'" do
    before(:each) do
      # Create 2 users and sign-in the 2nd user
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      test_sign_in(@user2)
      # Create a pool for each poolType
      @poolType0 = @user1.pools.create(:name => "Pool 1", :poolType => 0, 
                                      :isPublic => true, :password => "foobar")
      @poolType1 = @user1.pools.create(:name => "Pool 2", :poolType => 1, 
                                      :isPublic => true, :password => "foobar")
      @poolType2 = @user1.pools.create(:name => "Pool 3", :poolType => 2, 
                                      :isPublic => true, :password => "foobar")
      @poolType3 = @user2.pools.create(:name => "Pool 4", :poolType => 3, 
                                      :isPublic => true, :password => "foobar")
      @poolTypePrivate = @user1.pools.create(:name => "Pool 5", :poolType => 3, 
                                      :isPublic => false, :password => "foobar")

      # set owner flag for first pool
      @pool_membership = @user1.pool_memberships.find_by_pool_id(@poolType0.id)
      @pool_membership.owner = true
      @pool_membership.save

      # Add @user2 as a member to the first pool
      @user2.pools << @poolType0
    end

    it "should be successful" do
      get :show, :id => @poolType0
      response.should be_success
    end

    it "should find the right pool" do
      get :show, :id => @poolType0
      assigns(:pool).should == @poolType0
    end

    it "should have the right title" do
      get :show, :id => @poolType0
      response.should have_selector("title", :content => @poolType0.name)
    end

    it "should show PickEm for poolType 0" do
      get :show, :id => @poolType0
      response.should have_selector("td", :content => "PickEm")
    end

    it "should show PickEmSpread for poolType 1" do
      get :show, :id => @poolType1
      response.should have_selector("td", :content => "PickEmSpread")
    end

    it "should show Survivor for poolType 2" do
      get :show, :id => @poolType2
      response.should have_selector("td", :content => "Survivor")
    end

    it "should show SUP for poolType 3" do
      get :show, :id => @poolType3
      response.should have_selector("td", :content => "SUP")
    end

    it "should show Private for Private pool" do
      get :show, :id => @poolTypePrivate
      response.should have_selector("td", :content => "Private")
    end

    it "should show Public for a Public pool" do
      get :show, :id => @poolType0
      response.should have_selector("td", :content => "Public")
    end

    it "should include the pool owners name"  do
      get :show, :id => @poolType0
      response.should have_selector("a", :content => @user1.name)
    end

    it "should show an * next to the User's name for ownership " do
      post :show, :id => @poolType0
      response.should have_selector("a", :content => "*")
    end

    it "should include the joined user's name"  do
      get :show, :id => @poolType0
      response.should have_selector("a", :content => @user2.name)
    end

    it "should show the 'delete pool' message if owner" do
      test_sign_in(@user1)
      get :show, :id => @poolType0
      response.should have_selector("a", :content => "Delete pool")
    end

    it "should show the 'update pool' message if owner" do
      test_sign_in(@user1)
      get :show, :id => @poolType0
      response.should have_selector("a", :content => "Edit pool")
    end

    it "should show the 'join pool' message if not a member" do
      get :show, :id => @poolTypePrivate
      response.should have_selector("a", :content => "Join Pool")
    end

    it "should show the 'leave pool' message if a member/not owner" do
      get :show, :id => @poolType0
      response.should have_selector("a", :content => "Leave Pool")
    end

    it "should not show the 'join pool' message if already a member" do
      get :show, :id => @poolType0
      response.should_not have_selector("a", :content => "Join Pool")
    end

    it "should redirect to pools_path if pool is not found" do
      get :show, :id => 55
      response.should redirect_to(pools_path)
    end

    it "should paginate pools"  do
      # Add 30 more users joined to pool for pagination testing
      30.times do
        @user = FactoryGirl.create(:user)
        @user.pools << @poolType0
      end
      get :show, :id => @poolType0
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a", :href => "/pools/1?page=2",
                                         :content => "2")
      response.should have_selector("a", :href => "/pools/1?page=2",
                                         :content => "Next")
    end
  end

  #------------------------#
  #  Tests for GET 'join'  #
  #------------------------#
  describe "GET 'join'" do
    before(:each) do
      # Create 2 users and sign-in the 2nd user
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      test_sign_in(@user2)
      # Create a pool
      @pool = @user1.pools.create(:name => "Pool 1", :poolType => 0, 
                                  :isPublic => true, :password => "foobar")

      # set owner flag for pool
      @pool_membership = @user1.pool_memberships.find_by_pool_id(@pool.id)
      @pool_membership.owner = true
      @pool_membership.save
    end

    describe "with failure" do

      it "should not allow a current member to join again" do
          get :join, :id => @pool
          lambda do
            get :join, :id => @pool
          end.should_not change(PoolMembership, :count).by(1)
      end

      it "should show an error message if already a member" do
        get :join, :id => @pool
        get :join, :id => @pool
        response.should redirect_to(pool_path(assigns(:pool)))
        flash[:notice].should =~ /Already a member/i
      end
    end

    describe "with success" do

      it "Should add the signed in user to pool" do
          lambda do
            get :join, :id => @pool
          end.should change(PoolMembership, :count).by(1)
      end

      it "should show redirect to the pool show page" do
        get :join, :id => @pool
        response.should redirect_to(pool_path(assigns(:pool)))
      end

      it "should show a succesful message ater joining" do
        get :join, :id => @pool
        flash[:success].should =~ /successfully added to pool/i
      end
    end
  end

  #------------------------#
  #  Tests for GET 'leave'  #
  #------------------------#
  describe "GET 'leave'" do
    before(:each) do
      # Create 2 users and sign-in the 2nd user
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      test_sign_in(@user2)
      # Create a pool
      @pool = @user1.pools.create(:name => "Pool 1", :poolType => 0, 
                                  :isPublic => true, :password => "foobar")
      @pool2 = @user1.pools.create(:name => "Pool 2", :poolType => 0, 
                                   :isPublic => true, :password => "foobar")

      # set owner flag for pool
      @pool_membership = @user1.pool_memberships.find_by_pool_id(@pool.id)
      @pool_membership.owner = true
      @pool_membership.save

      # Add @user2 as a member to the first pool
      @user2.pools << @pool
    end

    it "should not work if owner of pool" do
      test_sign_in(@user1)
      get :leave, :id => @pool
      response.should redirect_to(pool_path(assigns(:pool)))
      flash[:error].should =~ /Owner cannot leave the pool/i
    end

    it "should remove the pool_membership for user/pool" do
      lambda do
        get :leave, :id => @pool
      end.should change(PoolMembership, :count).by(-1)
    end

    it "should redirect to the pools_path upon success" do
      get :leave, :id => @pool
      response.should redirect_to(pools_path)
      flash[:success].should =~ /successfully removed from pool/i
    end

    it "should fail if not a member of the pool" do
      get :leave, :id => @pool2
      response.should redirect_to(pools_path)
      flash[:error].should =~ /Not a member of pool/i
    end
  end

  #------------------------#
  #  Tests for GET 'new'   #
  #------------------------#
  describe "GET 'new'" do
    before(:each) do
      # Create a user and sign-in
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Create pool")
    end

    it "should have a name field" do
      get :new
      response.should have_selector("input[name='pool[name]']")
    end

    it "should have an poolType field" do
      get :new
      response.should have_selector("select[name='pool[poolType]']")
    end

    it "should have an isPublic field" do
      get :new
      response.should have_selector("input[name='pool[isPublic]']")
    end

    it "should have a password field" do
      get :new
      response.should have_selector("input[name='pool[password]']")
    end

#   it "should have a password confirmation field" do
#     get :new
#     response.should have_selector("input[name='pool[password_confirmation]']")
#   end
  end

  #--------------------------#
  #  Tests for POST 'create' #
  #--------------------------#
  describe "POST 'create'" do
    before(:each) do
      # Create a user and sign-in
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :poolType => 4, :isPublic => "", 
                  :password => "" }
      end

      it "should not create the pool" do
        lambda do
          post :create, :pool => @attr
        end.should_not change(Pool, :count)
      end

      it "should have the right title" do
        post :create, :pool => @attr
        response.should have_selector("title", :content => "Create pool")
      end

      it "should render the 'new' page" do
        post :create, :pool => @attr
        response.should render_template('new')
      end
    end
    describe "success" do
      before(:each) do
        @attr = { :name => "Pool Test 1", :poolType => 1, :isPublic => true,
                  :password => "foobar" }
      end

      it "should create a pool" do
        lambda do
          post :create, :pool => @attr
        end.should change(Pool, :count).by(1)
      end

      it "should redirect to the pool show page" do
        post :create, :pool => @attr
        response.should redirect_to(pool_path(assigns(:pool)))
      end

      it "should have a created success message" do
        post :create, :pool => @attr
        flash[:success].should =~ /was created successfully/i
      end
    end
  end

  #-----------------------#
  #  Tests for GET 'edit' #
  #-----------------------#
  describe "GET 'edit'" do

    before(:each) do
      # Create 2 users and sign-in the 2nd user
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      # Create a pool
      @pool = @user1.pools.create(:name => "Pool 1", :poolType => 0, 
                                  :isPublic => true, :password => "foobar")
    end

    describe "as non-owner" do
      before(:each) do
        test_sign_in(@user2)
      end
      it "should redirect to the pools page and show error" do
        get :edit, :id => @pool
        response.should redirect_to(pools_path)
        flash[:error].should =~ /Only the owner can edit the pool!/i
      end
    end

    describe "as owner" do
      before(:each) do
        test_sign_in(@user1)
        @pool_membership = @user1.pool_memberships.find_by_pool_id(@pool.id)
        @pool_membership.owner = true
        @pool_membership.save
      end

      it "should be successful" do
        get :edit, :id => @pool
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @pool
        response.should have_selector("title", :content => "Edit pool")
      end
    end
  end

  #-------------------------#
  #  Tests for PUT 'update' #
  #-------------------------#
  describe "PUT 'update'" do
    before(:each) do
      # Create 2 users and sign-in the 2nd user
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      # Create a pool
      @pool = @user1.pools.create(:name => "Pool 1", :poolType => 0, 
                                  :isPublic => true, :password => "foobar")
      @pool_membership = @user1.pool_memberships.find_by_pool_id(@pool.id)
      @pool_membership.owner = true
      @pool_membership.save
    end
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :isPublic => false, 
                  :password => "" }
      end
      it "should render the 'edit' page" do
        test_sign_in(@user1)
        put :update, :id => @pool, :pool => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        test_sign_in(@user1)
        put :update, :id => @pool, :pool => @attr
        response.should have_selector("title", :content => "Edit pool")
      end

      it "should not update if user not owner" do
        test_sign_in(@user2)
        put :update, :id => @pool, :pool => @attr
        response.should redirect_to(pools_path)
        flash[:error].should =~ /Only the owner can edit the pool!/i
      end
    end
    describe "success" do

      before(:each) do
        test_sign_in(@user1)
        @attr = { :name => "Test pool 2", :isPublic => false, 
                  :password => "" }
      end
      it "should change the pool's attributes" do
        put :update, :id => @pool, :pool => @attr
        @pool.reload
        @pool.name.should  == @attr[:name]
        @pool.isPublic.should == @attr[:isPublic]
      end

      it "should redirect to the pool show page" do
        put :update, :id => @pool, :pool => @attr
        response.should redirect_to(pool_path(@pool))
      end

      it "should have flash message" do
        put :update, :id => @pool, :pool => @attr
        flash[:success].should =~ /updated/
      end
    end
  end

  #-----------------------------#
  #  Tests for DELETE 'destroy' #
  #-----------------------------#
  describe "DELETE 'destroy'" do

    before(:each) do
      # Create 2 users and sign-in the 2nd user
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      # Create a pool
      @pool = @user1.pools.create(:name => "Pool 1", :poolType => 0, 
                                  :isPublic => true, :password => "foobar")
      @pool2 = @user1.pools.create(:name => "Pool 2", :poolType => 0, 
                                   :isPublic => true, :password => "foobar")

      # Add user2 to the 2nd pool
      @user2.pools << @pool2
    end

    describe "as non-owner" do
      before(:each) do
        test_sign_in(@user2)
      end
      it "should not delete the pool" do
        lambda do
          delete :destroy, :id => @pool2
        end.should_not change(Pool, :count).by(-1)
      end

      it "should redirect to the pools page and show error" do
        delete :destroy, :id => @pool2
        response.should redirect_to(pools_path)
        flash[:error].should =~ /Only the onwer can delete the pool!/i
      end
    end

    describe "as owner" do
      before(:each) do
        test_sign_in(@user1)
        # set owner flag for pool
        @pool_membership = @user1.pool_memberships.find_by_pool_id(@pool.id)
        @pool_membership.owner = true
        @pool_membership.save
        @pool_membership = @user1.pool_memberships.find_by_pool_id(@pool2.id)
        @pool_membership.owner = true
        @pool_membership.save
      end

      it "should delete the pool" do
        lambda do
          delete :destroy, :id => @pool
        end.should change(Pool, :count).by(-1)
      end

      it "should delete the pool_memberships for creator of pool" do
        lambda do
          delete :destroy, :id => @pool
        end.should change(PoolMembership, :count).by(-1)
      end

      it "should delete the pool_memberships for creator and joiner of pool" do
        lambda do
          delete :destroy, :id => @pool2
        end.should change(PoolMembership, :count).by(-2)
      end

      it "should redirect to the pools page" do
        delete :destroy, :id => @pool
        response.should redirect_to(pools_path)
        flash[:success].should =~ /Successfully deleted pool/i
      end
    end
  end
end
