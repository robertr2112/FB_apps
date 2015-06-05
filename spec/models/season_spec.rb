# == Schema Information
#
# Table name: seasons
#
#  id              :integer          not null, primary key
#  year            :string(255)
#  state           :integer
#  nfl_league      :boolean
#  number_of_weeks :integer
#  current_week    :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

describe Season do
 
  before do 
    @season = Season.new(year: Season.getSeasonYear, state: 0, nfl_league: 1,
                     number_of_weeks: 17, current_week: 1)
  end

  subject { @season }

  it { should respond_to(:year) }
  it { should respond_to(:state) }
  it { should respond_to(:nfl_league) }
  it { should respond_to(:number_of_weeks) }
  it { should respond_to(:current_week) }
  it { should respond_to(:weeks) }
  it { should respond_to(:setState) }
  it { should respond_to(:isPending?) }
  it { should respond_to(:isOpen?) }
  it { should respond_to(:isClosed?) }
  it { should respond_to(:canBeClosed?) }
  
  it "can't be closed until all weeks are done" do
    value = @season.canBeClosed?
    expect(value).to eq false
  end
  
  it "should test setState"
  it "should test isPending?"
  it "should test isOpen?"
  it "should test isClosed?"
  it "should test canBeClosed?"
  
end
