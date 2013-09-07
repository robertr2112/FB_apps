# == Schema Information
#
# Table name: weeks
#
#  id         :integer          not null, primary key
#  state      :integer
#  pool_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Week < ActiveRecord::Base

  STATES = { Pend: 0, Open: 1, Closed: 2 }

  belongs_to :pool
  has_many   :games, dependent: :destroy
  has_many   :picks, dependent: :destroy

  accepts_nested_attributes_for :games

  def setState(state)
    self.state = state
    self.save
  end

  def checkStatePend
    self.state == Week::STATES[:Pend]
  end

  def checkStateOpen
    self.state == Week::STATES[:Open]
  end

  def checkStateClosed
    self.state == Week::STATES[:Closed]
  end

  def buildSelectTeams
    select_teams = Array.new
    self.games.each do |game|
      team = NflTeam.find(game.homeTeamIndex)
      select_teams << team
      team = NflTeam.find(game.awayTeamIndex)
      select_teams << team
    end
    return select_teams
  end

  def madePicks?(user)
    self.picks.each do |pick|
      if pick.user_id == user.id
        return true
      end
    end
    return false
  end
end
