# == Schema Information
#
# Table name: pool_memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  pool_id    :integer
#  owner      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe PoolMembership do

  before(:each) do
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
  end

  describe "Creating a new pool" do

    before(:each) do
      @pool1 = @user1.pools.create(@pool_attr)
    end

    it "should add an entry in pool_memberships" do
      @pool_membership = @user1.pool_memberships.last
      @pool1.id.should == @pool_membership.pool_id
    end
  end

  describe "joining a pool" do
    before(:each) do
      @pool1 = @user1.pools.create(@pool_attr)
      @pool2 = @user1.pools.create(@pool_attr.merge(:name => "Pool 2",
                                                    :poolType => 0))
    end

    it "should not add a new pool entry" do
      lambda do
        @user2.pools << @pool2
      end.should_not change(Pool, :count)
    end

    it "should add an entry in pool_memberships" do
      @user2.pools << @pool2
      @pool_membership = @user2.pool_memberships.last
      @pool2.id.should == @pool_membership.pool_id
    end
  end

  describe "set_owner method" do
    before(:each) do
      @pool1 = @user1.pools.create(@pool_attr)
    end

    it "should be able to set owner flag to true" do
      @pool_membership = @user1.pool_memberships.last
      @pool_membership.owner = true
      @pool_membership.owner.should == true
    end
  end
end
