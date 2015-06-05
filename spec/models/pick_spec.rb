# == Schema Information
#
# Table name: picks
#
#  id          :integer          not null, primary key
#  week_id     :integer
#  entry_id    :integer
#  week_number :integer
#  totalScore  :integer          default(0)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

describe Pick do
  let(:user) { FactoryGirl.create(:user) }
  let(:season) { FactoryGirl.create(:season_with_weeks) }

  before do
    @pool_attr = { :name => "Pool 1", :poolType => 2, 
                   :isPublic => true }
    @pool = user.pools.create(@pool_attr.merge(season_id: season.id,
                                   starting_week: 1)) 
    @week = season.weeks.find(@pool.getCurrentWeek.id)
    entry_name = @pool.getEntryName(user)
    @entry = @pool.entries.create(user_id: user.id, name: entry_name,
                           survivorStatusIn: true, supTotalPoints: 0)
    @pick = @entry.picks.create(week_id: @week.id, week_number: @week.week_number)
    @game_pick = @pick.game_picks.create(chosenTeamIndex: 0)
  end
  
  subject { @pick }
  
  it { should be_valid }
  
  it { should respond_to(:week_id) }
  it { should respond_to(:entry_id) }
  it { should respond_to(:week_number) }
  it { should respond_to(:totalScore) }
  
  # survivor pool test only
  # !!!! Figure out how to test for this nested model
  it "should not allow a duplicate team pick"
# describe "when survivor pool entry pick" do
#   describe "should not allow a duplicate team pick" do
#     before do
#       @pick1 = @entry.picks.build(week_id: @week.id, week_number: @week.week_number)
#       @game_pick1 = @pick1.game_picks.build(chosenTeamIndex: 0)
#       @pick1.save
#       @game_pick1.save
#     end
#     it { should_not be_valid }
#   end
# end
  
end
