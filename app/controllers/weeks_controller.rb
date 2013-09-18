class WeeksController < ApplicationController
  before_action :signed_in_user
  before_action :confirmed_user

  def new
    @pool = Pool.find(params[:pool_id])
    if !@pool.nil?
      @week = @pool.weeks.new
      @game = @week.games.build
      @week.weekNumber = @pool.weeks.count + 1
    else
      flash[:error] = "Cannot create week. Pool with id:#{params[:pool_id]} does not exist!"
      redirect_to pools_path
    end
  end

  def create
    @pool = Pool.find(params[:pool_id])
    @week = @pool.weeks.new(week_params)
    @week.weekNumber = @pool.weeks.count + 1
    if @week.save
      # Handle a successful save
      flash[:success] = 
          "Week #{@week.weekNumber} for '#{@pool.name}' was created successfully!"
      # Set the state to Pend
      @week.setState(Week::STATES[:Pend])
      redirect_to @pool
    else
      render 'new'
    end
  end

  def edit
    @week = Week.find(params[:id])
    @games = @week.games
  end

  def update
    @week = Week.find(params[:id])
    if @week.update_attributes(week_params)
      redirect_to @week, notice: "Successfully updated week #{@week.weekNumber}."
    else
      render :edit
    end
  end

  def show
    @week = Week.find(params[:id])
    @pool = Pool.find(@week.pool_id)
    @games = @week.games
  end

  def destroy
    @week = Week.find(params[:id])
    @pool = Pool.find(@week.pool_id)
    if @pool.isOwner?(current_user)
      @week.destroy
      flash[:success] = "Successfully deleted Week '#{@week.weekNumber}'!"
      redirect_to pool_path(@pool)
    else
      flash[:error] = "Only the onwer of the pool can delete weeks!"
      redirect_to pools_path
    end
  end

  def open
    @week = Week.find(params[:id])
    @pool = Pool.find(@week.pool_id)
    @week.setState(Week::STATES[:Open]) unless @week.nil?
    redirect_to @pool
  end

  def closed
    @week = Week.find(params[:id])
    @pool = Pool.find(@week.pool_id)
    @week.setState(Week::STATES[:Closed]) unless @week.nil?
    redirect_to @pool
  end

  def final
    @week = Week.find(params[:id])
    @pool = Pool.find(@week.pool_id)
    @week.setState(Week::STATES[:Final]) unless @week.nil?
    # Update the entries status/totals based on this weeks results
    @week.updateEntries
    flash[:notice] = "Week #{@week.weekNumber} is final!"
    redirect_to @pool
  end

  private
    def week_params
      params.require(:week).permit(:state, :pool_id, :weekNumber,
                                   games_attributes: [:id, :week_id,
                                                     :homeTeamIndex, 
                                                     :awayTeamIndex, 
                                                     :spread, 
                                                     :homeTeamScore,
                                                     :awayTeamScore,
                                                     :_destroy] )
    end
end
