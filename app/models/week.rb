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
  has_many   :picks, dependent: :destroy

  accepts_nested_attributes_for :games
  #validates_associated :games
  validate :gamesValid?

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
      team = Team.find(game.awayTeamIndex)
      select_teams << team
      team = Team.find(game.homeTeamIndex)
      select_teams << team
    end
    return select_teams
  end

  def madePicks?(entry)
    picks = self.picks.where(entry_id: entry.id)
    picks.each do |pick|
      if (pick.entry_id == entry.id && pick.weekNumber == self.week_number)
        return true
      end
    end
    return false
  end

  def getWinningTeams
    winning_teams = Array.new
    games = self.games
    games.each do |game|
      if ((game.awayTeamScore-game.homeTeamScore) > 0)
        winning_teams << game.awayTeamIndex
      else
        winning_teams << game.homeTeamIndex
      end
    end
    return winning_teams
  end

  def updateEntries
    winning_teams = self.getWinningTeams
    picks = self.picks
    picks.each do |pick|
      pick.game_picks.each do |game_pick|
        found_team = false
        winning_teams.each do |team|
          if game_pick.chosenTeamIndex == team 
            found_team = true
          end
        end
        if !found_team 
          entry = Entry.find(pick.entry_id)
          entry.update_attribute(:survivorStatusIn, false)
          entry.save
        end
      end
    end
    return true
  end
  
  def gamesValid?
    games_to_check = self.games
    games_to_check.each do |current_game|
      if current_game.homeTeamIndex == current_game.awayTeamIndex
        errors[:base] << "Week #{self.week_number} has errors:"
        current_game.errors[:homeTeamIndex] << "Home and Away Team can't be the same!"
      end
      games = games_to_check = self.games
      games.each do |game|
        if current_game != game
          if current_game.homeTeamIndex == game.homeTeamIndex ||
             current_game.homeTeamIndex == game.awayTeamIndex
            errors[:base] << "Week #{self.week_number} has errors:"
            current_game.errors[:homeTeamIndex] << "Team names can't be repeated!"
          end
          if current_game.awayTeamIndex == game.awayTeamIndex ||
             current_game.awayTeamIndex == game.homeTeamIndex
            errors[:base] << "Week #{self.week_number} has errors:"
            current_game.errors[:awayTeamIndex] << "Team names can't be repeated!"
          end
        end
      end
    end
  end

  def deleteSafe?(pool)
    if (pool.weeks.order(:week_number).last == self)
      return true
    else
      return false
    end
  end
  
end
