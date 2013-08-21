# == Schema Information
#
# Table name: games
#
#  id            :integer          not null, primary key
#  homeTeamIndex :integer
#  awayTeamIndex :integer
#  spread        :integer
#  week_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

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
    @week = @pool.weeks.create(:state => Week::STATES[:Pend])
    @game= @week.games.create(:homeTeamIndex => 0, :awayTeamIndex => 1,
                              :spread => -3.5)
  end

  subject {@game}

  it { should respond_to(:week_id) }
  it { should respond_to(:homeTeamIndex) }
  it { should respond_to(:awayTeamIndex) }
  it { should respond_to(:spread) }
  it { should respond_to(:homeTeamScore) }
  it { should respond_to(:awayTeamScore) }

  it { should be_valid }

  describe "and week associations" do

    it "should have the right associated week id" do
      @week_id = @game.week_id
      expect(@week_id).to eq @week.id
    end
  end

  describe "validations" do
    describe "should reject an invalid homeTeamIndex" do
      before { @game.homeTeamIndex = 101}
      it { should_not be_valid }
    end

    describe "should reject an invalid awayTeamIndex" do
      before { @game.awayTeamIndex = 101}
      it { should_not be_valid }
    end
  end
end
