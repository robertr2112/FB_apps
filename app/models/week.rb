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

  STATES = { Pend: 0, Open: 1, Closed: 2, Final: 3 }

  belongs_to :pool
  has_many   :games, dependent: :destroy
  has_many   :entries, dependent: :destroy

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

  def checkStateFinal
    self.state == Week::STATES[:Final]
  end

  def open?
    checkStateOpen
  end

  def closed?
    checkStateClosed
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

  def markUserEntries
    winning_teams = self.getWinningTeams
    entries = self.entries
    entries.each do |entry|
      game_pick = entry.game_picks.first
      found_team = false
      winning_teams.each do |team|
        if game_pick.chosenTeamIndex == team 
          found_team = true
        end
      end
      if !found_team 
        entry.update_attribute(:survivor_status, false)
        entry.save
      end
    end
    return true
  end

  def madeEntry?(user)
    self.entries.each do |entry|
      if entry.user_id == user.id
        return true
      end
    end
    return false
  end

  def entryValid?(user)
    entries = Entry.where(user_id: user.id)
    if entries.empty? 
      return false
    end
    entry = entries.last
    if entry.survivor_status 
      return true
    else
      return false
    end
  end

  def getWinningTeams
    winning_teams = Array.new
    games = self.games
    games.each do |game|
      if ((game.awayTeamScore-game.homeTeamScore) > 0)
        puts "game.awayTeamIndex: #{game.awayTeamIndex}"
        winning_teams << game.awayTeamIndex
      else
        puts "game.homeTeamIndex: #{game.homeTeamIndex}"
        winning_teams << game.homeTeamIndex
      end
    end
    return winning_teams
  end

  private
end
