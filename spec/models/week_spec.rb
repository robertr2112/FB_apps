# == Schema Information
#
# Table name: weeks
#
#  id         :integer          not null, primary key
#  state      :integer
#  pool_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Week do
  before(:each) do
    @user_attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
    @pool_attr = { :name => "Pool 1", :poolType => 2, :isPublic => true }
    @user = User.create(@user_attr)
    @pool = @user.pools.create(@pool_attr)
  end

  it "should create a new instance given valid attributes" do
    @pool.weeks.create!(:state => Week::STATES[:Pend])
  end

  describe "pool associations" do

    before(:each) do
      @week = @pool.weeks.create!(:state => Week::STATES[:Pend])
    end

    it "should have a pools attribute" do
      @week.should respond_to(:pool)
    end

    it "should have the right associated user" do
      @pool_id = @week.pool_id
      @pool_id.should == @pool.id
    end
  end

  describe "validations" do
    it "should reject an invalid state" do
      @week = @pool.weeks.build(:state => 3).should_not be_valid
    end
  end
end
