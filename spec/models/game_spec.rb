require 'spec_helper'

describe Game do
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

  it "should create a new instance given valid attributes" do
    @game= @week.games.create!(:homeTeamIndex => 0, :awayTeamIndex => 1,
                               :spread => -3.5)
  end

  describe "pool associations" do

    before(:each) do
      @game= @week.games.create!(:homeTeamIndex => 0, :awayTeamIndex => 1,
                                 :spread => -3.5)
    end

    it "should have a pools attribute" do
      @game.should respond_to(:week)
    end

    it "should have the right associated week_id" do
      @week_id = @game.week_id
      @week_id.should == @week.id
    end
  end

  describe "validations" do
    it "should reject an invalid homeTeamIndex" do
      @game = @week.games.build(:homeTeamIndex => 101).should_not be_valid
    end

    it "should reject an invalid awayTeamIndex" do
      @game = @week.games.build(:awayTeamIndex => 101).should_not be_valid
    end
  end
end
