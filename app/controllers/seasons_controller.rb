class SeasonsController < ApplicationController
  before_action :signed_in_user
  before_action :confirmed_user
  before_action :admin_user

  def new
    @season = Season.new
    @season.year = Time.now.strftime("%Y")
    @season.current_week = 1
  end

  def create
    @season = Season.create(season_params)
    if @season.id
      # Handle a successful save
      flash[:success] = "Season for year '#{@season.year}' was created successfully!"
      redirect_to @season
    else
      render 'new'
    end
  end

  def edit
    @Season = Season.find(params[:id])
    if @season.week_number > 1
      flash[:error] = "Cannot edit the Season after it has started!"
      redirect_to @season
    end
  end
  
  def update
    @season = Season.find(params[:id])
    if @season.week_number == 1
      if @season.update_attributes(season_params)
        flash[:success] = "Season updated."
        redirect_to @season
      else
        render 'edit'
      end
    else
      flash[:error] = "Cannot edit the Season after it has started!"
      redirect_to @season
    end
  end
  
  def show
    @season = Season.find_by_id(params[:id])
    if @season.nil?
      flash[:notice] = 'The season you tried to access does not exist'
      redirect_to seasons_path
    end
  end
  
  def index
    @seasons = Season.paginate(page: params[:page])
  end

  private

    def season_params
      params.require(:season).permit(:year, :nfl_league, :number_of_weeks, :current_week)
    end
    
end