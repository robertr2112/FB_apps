# == Schema Information
#
# Table name: weeks
#
#  id          :integer          not null, primary key
#  season_id   :integer
#  state       :integer
#  week_number :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

describe Week do
  
  let(:season) { FactoryGirl.create(:season) }
  
  before(:each) do
    @week = season.weeks.build(state: Week::STATES[:Pend], week_number: 1)
  end

  subject {@week}

  it { should respond_to(:state) }
  it { should respond_to(:season_id) }
  it { should respond_to(:week_number) }
  it { should respond_to(:games) }
  it { should respond_to(:setState) }
  it { should respond_to(:checkStateOpen) }
  it { should respond_to(:checkStatePend) }
  it { should respond_to(:checkStateClosed) }
  it { should respond_to(:checkStateFinal) }
  it { should respond_to(:open?) }
  it { should respond_to(:closed?) }
  it { should respond_to(:buildSelectTeams) }
  it { should respond_to(:getWinningTeams) }
  it { should respond_to(:gamesValid?) }
  it { should respond_to(:deleteSafe?) }

  it { should be_valid }

  it "should have the right associated season_id" do
    @season_id = @week.season_id
    expect(@season_id).to eq season.id
  end

  describe "validations" do
    describe "should reject an invalid state" do
      before { @week.state = 4}
      it { should_not be_valid }
    end
    
    describe "should reject an invalid week_number < 1" do
      before { @week.week_number = 0}
      it { should_not be_valid }
    end
    
    describe "should reject an invalid week_number > 17" do
      before { @week.week_number = 18}
      it { should_not be_valid }
    end
    
    describe "should reject an invalid week_number == nil" do
      before { @week.week_number = nil}
      it { should_not be_valid }
    end
  end
  
  it "should test buildSelectTeams"
  it "should test getWinningTeams"
  it "should test gamesValid?"
  it "should test deleteSafe?"
  
end
