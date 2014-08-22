module SeasonsHelper

  def current_season(nfl_league)
    current_year = Time.now.strftime("%Y")
    if nfl_league
      Season.where(year: current_year, nfl_league: true).first
    else
      Season.where(year: current_year, nfl_league: false).first
    end
  end

end
