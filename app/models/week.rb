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
require 'open-uri'
require 'nokogiri'

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

    # Generate NFL schedule for a specified week
  def create_nfl_week
    nfl_games = get_nfl_sched(self.week_number)
    nfl_games.each do |nfl_game|
      away_team = Team.find_by_name(nfl_game[:away_team])
      home_team = Team.find_by_name(nfl_game[:home_team])
      # Create the time string
      game_date_time = DateTime.parse(nfl_game[:date] + " ,2016 " + nfl_game[:time] + " EDT")
      game = Game.create(week_id: self.id, awayTeamIndex: away_team.id,
                         homeTeamIndex: home_team.id, 
                         game_date: game_date_time)
      self.games << game
    end
    self.save
    
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
    ret_code = true
    games_to_check.each do |current_game|
      # Check to make sure the current_game team isn't the same for both teams
      if current_game.homeTeamIndex == current_game.awayTeamIndex
        errors[:base] << "Week #{self.week_number} has errors:"
        current_game.errors[:homeTeamIndex] << "Home and Away Team can't be the same!"
        ret_code = false
      end
      games = games_to_check = self.games
      games.each do |game|
        # check that the current_game teams are not repeated in the other games
        if current_game != game
          if current_game.homeTeamIndex == game.homeTeamIndex || current_game.homeTeamIndex == game.awayTeamIndex
            errors[:base] << "Week #{self.week_number} has errors:"
            current_game.errors[:homeTeamIndex] << "Team names can't be repeated!"
            ret_code = false
          end
          if current_game.awayTeamIndex == game.awayTeamIndex || current_game.awayTeamIndex == game.homeTeamIndex
            errors[:base] << "Week #{self.week_number} has errors:"
            current_game.errors[:awayTeamIndex] << "Team names can't be repeated!"
            ret_code = false
          end
        end
      end
    end
    return ret_code
  end

  # !!!! Should this be moved to season model ??
  def deleteSafe?(season)
    if  self.checkStatePend  && (season.weeks.order(:week_number).last == self) 
      return true
    else
      return false
    end
  end
  
  private
  
  # Parse the schedule for specified week from nfl.com. Returns
  # an array of game information(:date, :time, :away_team, :home_team)
  def get_nfl_sched(weekNum)
  
    # Open the schedule home page
    url_path = "http://www.nfl.com/schedules/2016/REG" + weekNum.to_s
    doc = Nokogiri::HTML(open(url_path))
                       
    # Get games information
    games = Array.new
                       
    # Find all start dates
    start_dates_list = doc.search("//comment()[contains(.,'formattedDate')]")
    start_dates = Array.new
    start_dates_list.each do |strt_date|
      start_dates << strt_date.text.sub( /^( formattedDate:)\s+/, '').strip
    end
   
    # Find all start times
    start_times_list = doc.search("//comment()[contains(.,'formattedTime')]")
    start_times = Array.new
    start_times_list.each do |strt_time|
      start_times << strt_time.text.sub( /^( formattedTime:)\s+/, '').strip
    end

    # Get home teams (gets duplicates and the first game is repeated twice)
    away_team_names = doc.search("//comment()[contains(.,'awayName')]")
    away_team_names.shift
    away_team_cities = doc.search("//comment()[contains(.,'awayCityName')]")
    away_team_cities.shift
    home_team_names = doc.search("//comment()[contains(.,'homeName')]")
    home_team_names.shift
    home_team_cities = doc.search("//comment()[contains(.,'homeCityName')]")
    home_team_cities.shift
  
    # Remove duplicate teams from list (this is due to the way we parse the data from the NFL site)
    # and strip off the everything but the team ID
    away_teams = Array.new
    away_team_names.count.times do |n|
      away_teams << away_team_cities[n].text.sub( /^( awayCityName:)\s+/, '').strip + " " +
                    away_team_names[n].text.sub( /^( awayName:)\s+/, '').strip
      
    end
  
    home_teams = Array.new
    home_team_names.count.times do |n|
      home_teams << home_team_cities[n].text.sub( /^( homeCityName:)\s+/, '').strip + " " +
                    home_team_names[n].text.sub( /^( homeName:)\s+/, '').strip
    end
    
    away_teams.count.times do |gameNum|
      # Add the information to the games array (add 1 to index for date and time because the 
      # first game is added twice on the NFL site.
      games[gameNum] = {:date => start_dates[gameNum+1], :time => start_times[gameNum+1], 
                   :away_team => away_teams[gameNum], :home_team => home_teams[gameNum]}
    end
    
    return games
    
  end
  
  def update_nfl_team_names
    
    record = Team.find_by_name("Cinncinatti Bengals")
    record.name = "Cincinnati Bengals"
    record.save!
    record = Team.find_by_name("St Louis Rams")
    record.name = "Los Angeles Rams"
    record.save!
    
  end
 
  
end
