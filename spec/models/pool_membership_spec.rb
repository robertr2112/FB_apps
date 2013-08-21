# == Schema Information
#
# Table name: pool_memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  pool_id    :integer
#  owner      :boolean          default(FALSE), not null
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe PoolMembership do

  before do
    @user_attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
    @pool_attr = { :name => "Pool 1", :poolType => 2, :isPublic => true }
    @user1 = User.create(@user_attr)
    @user2 = User.create(@user_attr.merge(:name => "Example User2",
                                          :email => "user2@example.com"))
    @pool1 = @user1.pools.create(@pool_attr)
    @pool_membership = @user1.pool_memberships.last
  end

  subject {@pool_membership}

  it { should respond_to(:pool_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:owner) }

  describe "when creating a new pool" do

    describe "should add an entry in pool_memberships" do
      it { should be_valid }
    end

    it "should have the correct pool_id" do
      expect(@pool_membership.pool_id).to eq @pool1.id
    end
  end

  describe "joining a pool" do
    before do
      @pool2 = @user1.pools.create(@pool_attr.merge(:name => "Pool 2",
                                                    :poolType => 0))
      @user2.pools << @pool2
    end

    it "should not add a new pool entry" do
      expect do
        @user2.pools << @pool2
      end.not_to change(Pool, :count)
    end

    it "should add an entry in pool_memberships" do
      @pool_membership = @user2.pool_memberships.last
      expect(@pool_membership.pool_id).to eq @pool2.id
    end

    it "should have the correct pool Id" do
      @pool_membership = @user2.pool_memberships.last
      expect(@pool_membership.pool_id).to eq @pool2.id
    end
  end

  describe "set_owner method" do

    it "should be able to set owner flag to true" do
      @pool_membership = @user1.pool_memberships.last
      @pool_membership.owner = true

      expect(@pool_membership.owner).to eq true
    end
  end

  describe "when deleting a pool" do
    it "should remove an entry from pool_memberships" do
      @pool1.destroy
      @pool_membership = PoolMembership.last

      expect(@pool_membership).to eq nil
    end
  end
end
