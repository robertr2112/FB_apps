class WeeksController < ApplicationController
  before_action :signed_in_user
  before_action :confirmed_user

  def new
    @pool = Pool.find(params[:pool_id])
    if !@pool.nil?
      @week = @pool.weeks.new
      @week_number = @pool.weeks.count + 1
    else
      flash[:error] = "Cannot create week. Pool with id:#{params[:id]} does not exist!"
      redirect_to pools_path
    end
  end

  def create
    @pool = Pool.find(params[:pool_id])
    @week = @pool.weeks.new(week_params)
    if @week.save
      # Handle a successful save
      flash[:success] = "Week '#{@week_number}' for '#{@pool.name}' was created successfully!"
      # Set the state to Pend
      @week.setState(Week::STATES[:Pend])
      redirect_to @pool
    else
      render 'new'
    end
  end

  def edit
  end

  def show
    @week = Week.find(params[:id])
    @games = @week.games
    @NflTeams = NflTeam.all
  end

  private
    def week_params
      params.require(:week).permit(:state, :pool_id,
                                   games_attributes: [:id, :week_id,
                                                     :homeTeamIndex, 
                                                     :awayTeamIndex, 
                                                     :spread, 
                                                     :homeTeamScore,
                                                     :awayTeamScore] )
    end
end
