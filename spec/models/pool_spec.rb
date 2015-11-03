# == Schema Information
#
# Table name: pools
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  season_id       :integer
#  poolType        :integer
#  starting_week   :integer          default(1)
#  allowMulti      :boolean          default(FALSE)
#  isPublic        :boolean          default(TRUE)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

describe Pool do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:season) { FactoryGirl.create(:season) }
  let(:season_with_weeks) { FactoryGirl.create(:season_with_weeks) }

  before do
    @pool_attr = { :name => "Pool 1", :poolType => 2, 
                   :isPublic => true }
    @pool = user.pools.build(@pool_attr.merge(season_id: season.id,
                                   starting_week: 1)) 
  end
  
  subject { @pool }
  
  it { should be_valid }
  
  it { should respond_to(:name) }
  it { should respond_to(:season_id) }
  it { should respond_to(:poolType) }
  it { should respond_to(:starting_week) }
  it { should respond_to(:allowMulti) }
  it { should respond_to(:isPublic) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:users) }
  it { should respond_to(:pool_memberships) }
  it { should respond_to(:isMember?) }
  it { should respond_to(:isOwner?) }
  it { should respond_to(:setOwner) }
  it { should respond_to(:getOwner) }
  it { should respond_to(:isOpen?) }
  it { should respond_to(:addUser) }
  it { should respond_to(:removeUser) }
  it { should respond_to(:remove_memberships) }
  it { should respond_to(:typeSUP?) }
  it { should respond_to(:typePickEm?) }
  it { should respond_to(:typePickEmSpread?) }
  it { should respond_to(:typeSurvivor?) }
  it { should respond_to(:getEntryName) }
  it { should respond_to(:updateEntries) }
  it { should respond_to(:removeEntries) }
  it { should respond_to(:haveSurvivorWinner?) }
  it { should respond_to(:getSurvivorWinner) }
  it { should respond_to(:getCurrentWeek) }

 
  it "should have the right associated user" do
    user.save
    @user_id = @pool.users.last.id
    expect(@user_id).to eq user.id
  end

  it "should be associated with the correct season" do
    expect(@pool.season_id).to eq season.id
  end
  
  it "should show user as a member of the pool" do
    user.save
    @pool_membership = @pool.isMember?(user)
    expect(@pool_membership.user_id).to eq user.id
  end
  
  it "should allow a user to update the pool" do
    @pool.update_attributes(name: "new name")
    @pool.save
  end
   
  it "when pool name is already taken" do
    @pool.save
    pool_with_duplicate_name = user.pools.build(@pool_attr)
    expect(pool_with_duplicate_name).to_not be_valid
  end

  describe "when name is not present" do
    before { @pool.name =  " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @pool.name =  "a" * 31 }
    it { should_not be_valid }
  end

  describe "when poolType is invalid" do
    before { @pool.poolType = 4 }
    it { should_not be_valid }
  end

  describe "when isPublic is invalid" do
    before { @pool.isPublic = nil }
    it { should_not be_valid }
  end
   
  describe "ownership" do
    before do
      user.save
      @pool.setOwner(user,true)
    end
  
    it "should allow to set user as owner" do
      expect(@pool.isOwner?(user)).to eq true
    end
     
    it "should allow to set unset user as owner" do
      @pool.setOwner(user,false)
      expect(@pool.isOwner?(user)).to eq false
    end
     
    it "should show user as owner" do
      @pool_membership = @pool.isMember?(user)
      expect(@pool_membership.owner).to eq true
    end
     
    it "should get owner" do
      @user_id = @pool.getOwner
      expect(@user_id).to eq user
    end
  end
   
  describe "membership" do
    let(:user1) { FactoryGirl.create(:user) }
    before {
			user.save
      @pool.addUser(user1)
    }
     
    it "should allow adding another user" do
      @pool_membership = @pool.isMember?(user1)
      expect(@pool_membership.user_id).to eq user1.id
    end
		
		it "should have a users count of 2 after adding a 2nd user" do
			expect(@pool.users.count).to eq 2
		end
     
    it "should allow removing a user" do
      @pool.removeUser(user1)
      @pool_membership = @pool.isMember?(user1)
      expect(@pool_membership).to eq nil
    end
    
    it "should test remove_memberships" do
			expect do
				@pool.remove_memberships
			end.to change(@pool.users, :count).by(-2)
		end
  end
  
  describe "entries" do
    let(:user1) { FactoryGirl.create(:user) }
    before {
      @pool.addUser(user1)
    }
     
    it "should verify getEntryName == user.<user_name> for first entry" do
		  entry = Entry.where(user_id: user1.id, pool_id: @pool.id).first	
			expect(entry.name).to eq user1.user_name
		end
		
    it "should allow a new entry" do
		  expect do
        @pool.entries.create(name: @pool.getEntryName(user1), user_id: user1.id,
                             survivorStatusIn: true, supTotalPoints: 0)
      end.to change(@pool.entries, :count).by(1)
		end

    it "should verify getEntryName == user.<user_name>_1 for second entry" do
 	    entry_name = @pool.getEntryName(user1)
 	    expect(entry_name).to eq "#{user1.user_name}_1"
  	end
		
		it "should allow user to change entry name" do
		  entry = Entry.where(user_id: user1.id, pool_id: @pool.id).first	
			new_name = "test name 1"
      entry.update_attributes(name: new_name)
 	    expect(entry.name).to eq new_name
		end
		
    it "should allow removal of an entry" do
      new_entry = @pool.entries.create(name: @pool.getEntryName(user1), user_id: user1.id,
                           survivorStatusIn: true, supTotalPoints: 0)
		  expect do
				new_entry.destroy
      end.to change(@pool.entries, :count).by(-1)
		end
  end
	
	describe "with type survivor" do
    
    describe "updateEntries" do
      it "should update all entries survivor status"
    end
    
    describe "haveSurvivorWinner" do
      it "should determine if there is a survivor winner"
    end
    
    describe "getSurvivorWinner" do
      it "should show the survivor winner(s)"
    end
  end
  
end
