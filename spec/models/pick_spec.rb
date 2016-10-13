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
  let(:season) { FactoryGirl.create(:season_with_weeks_and_games, num_weeks: 4, num_games: 5) }

  before do
    @pool_attr = { :name => "Pool 1", :poolType => 2, 
                   :isPublic => true }
    @pool = user.pools.create(@pool_attr.merge(season_id: season.id,
                                   starting_week: 1)) 
    @week = season.weeks[0]
    @games = @week.games
    @teams = @week.buildSelectTeams
    @first_team_picked = @teams[0].id
    @second_team_picked = @teams[1].id
    entry_name = @pool.getEntryName(user)
    @entry = @pool.entries.create(user_id: user.id, name: entry_name,
                           survivorStatusIn: true, supTotalPoints: 0)
    @pick = @entry.picks.create(week_id: @week.id, week_number: @week.week_number)
    @game_pick = @pick.game_picks.create(chosenTeamIndex: @first_team_picked)
  end
  
  subject { @pick }
  
  it { should be_valid }
  
  it { should respond_to(:week_id) }
  it { should respond_to(:entry_id) }
  it { should respond_to(:week_number) }
  it { should respond_to(:totalScore) }
  it { should respond_to(:pickValid?) }
  it { should respond_to(:buildSelectTeams) }
  
  # survivor pool test only
  describe "when in survivor pool" do
    describe "pickValid?" do
      it "should be false when duplicate team picked" do
        week = season.weeks[1]
        new_pick = @entry.picks.build(week_id: week.id, week_number: week.week_number)
        new_game_pick = new_pick.game_picks.build(chosenTeamIndex: @first_team_picked)
        new_game_pick.save
        expect(new_pick.save).to eq false
      end
      it "should be true when unique team picked" do
        week = season.weeks[1]
        new_pick = @entry.picks.build(week_id: week.id, week_number: week.week_number)
        new_game_pick = new_pick.game_picks.build(chosenTeamIndex: @second_team_picked)
        new_game_pick.save
        expect(new_pick.save).to eq true
      end
    end
    
    describe "buildSelectTeams" do
    
      it "should not include teams already picked" do
        teams = @pick.buildSelectTeams(@week)
        expect(teams.include?(@first_team_picked)).to eq false
      end
    end
    
    describe "when the current dateTime is after game start dateTime" do
      it "should not allow the pick" do
        week = season.weeks[1]
        games = week.games
        games[0].game_date = @games[0].game_date - 5.minutes
        new_pick = @entry.picks.build(week_id: week.id, week_number: week.week_number)
        new_game_pick = new_pick.game_picks.build(chosenTeamIndex: games[0].homeTeamIndex)
        new_game_pick.save
        expect do
          new_pick.save
        end.not_to change(Pick, :count)
      end
    end
  end
  
end
