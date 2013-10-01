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
      redirect_to @week
    else
      render 'new'
    end
  end

  def edit
    @week = Week.find(params[:id])
    @games = @week.games
    if @week.checkStateOpen || @week.checkStateFinal
      if @week.checkStateOpen 
        flash[:notice] = "Can't Edit the scores for the week until it is in the Closed state!"
      else
        flash[:notice] = "Can't Edit the week once it is in the Final state!"
      end
      redirect_to Pool.find(@week.pool_id)
    end
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
    if @week.games.empty?
      flash[:error] = "Week #{@week.weekNumber} is not ready to be Open! You need to enter games for this week!"
      redirect_to @pool
    end
    @week.setState(Week::STATES[:Open])
    redirect_to @pool
  end

  def closed
    @week = Week.find(params[:id])
    @pool = Pool.find(@week.pool_id)
    @week.setState(Week::STATES[:Closed])
    redirect_to @pool
  end

  def final
    @week = Week.find(params[:id])
    @pool = Pool.find(@week.pool_id)
    if weekFinalReady(@week)
      @week.setState(Week::STATES[:Final])
      # Update the entries status/totals based on this weeks results
      @week.updateEntries
      flash[:notice] = "Week #{@week.weekNumber} is final!"
      redirect_to @pool
    else
      flash[:error] = "Week #{@week.weekNumber} is not ready to be Final.  Please ensure all scores have been entered."
      redirect_to @pool
    end
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

    def weekFinalReady(week)
      games = week.games
      games.each do |game|
        if game.homeTeamScore == 0 && game.awayTeamScore == 0
          return false
        end
      end
    end
end
