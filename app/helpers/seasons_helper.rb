module SeasonsHelper

  def current_season
    current_year = Time.now.strftime("%Y")
    @current_year ||= Season.find_by(year: current_year)
  end

end
