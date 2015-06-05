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

class Week < ActiveRecord::Base

  STATES = { Pend: 0, Open: 1, Closed: 2, Final: 3 }

  belongs_to :season
  has_many   :games, dependent: :delete_all

  accepts_nested_attributes_for :games
  
  #validates_associated :games
  validates :state, inclusion:   { in: 0..3 }
  validates :week_number, numericality: { only_integer: true, greater_than: 0, 
                                          less_than_or_equal_to: 17} 
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

  def getWinningTeams
    winning_teams = Array.new
    games = self.games
    games.each do |game|
      spread = game.awayTeamScore-game.homeTeamScore
      if spread != 0
        if (spread > 0)
          winning_teams << game.awayTeamIndex
        else
          winning_teams << game.homeTeamIndex
        end
      else
        # in case of a tie add both teams to winning teams
          winning_teams << game.awayTeamIndex
          winning_teams << game.homeTeamIndex
      end
    end
    return winning_teams
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

  def deleteSafe?(season)
    if (season.weeks.order(:week_number).last == self)
      return true
    else
      return false
    end
  end
  
end
