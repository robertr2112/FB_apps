# == Schema Information
#
# Table name: weeks
#
#  id          :integer          not null, primary key
#  state       :integer
#  pool_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  week_number :integer
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
    @week = @pool.weeks.create!(:state => Week::STATES[:Pend])
  end

  subject {@week}

  it { should respond_to(:state) }
  it { should respond_to(:pool_id) }
  it { should respond_to(:games) }

  it { should be_valid }

  describe "pool associations" do

    it "should have the right associated pool_id" do
      @pool_id = @week.pool_id
      expect(@pool_id).to eq @pool.id
    end
  end

  describe "validations" do
    describe "should reject an invalid state" do
      before { @week.state = 3}
      it { should_not be_valid }
    end
  end
end
