class PicksController < ApplicationController
  before_action :signed_in_user
  before_action :confirmed_user

  def new
    @entry = Entry.find(params[:entry_id])
    if !@entry.nil?
      @pool = Pool.find(@entry.pool_id)
      @week = @pool.getCurrentWeek
      if message = pickErrorCheck(@week, @entry)
        flash[:error] = message
        redirect_to @pool
      else
        @pick = @entry.picks.new
        @game_pick = @pick.game_picks.new
      end
    else
      flash[:error] = 
        "Cannot do your pick(s). Week with id:#{params[:week_id]} does not exist!"
      redirect_to pools_path
    end
  end

  def create
    @entry = Entry.find(params[:entry_id])
    @pool = Pool.find(@entry.pool_id)
    @week = @pool.getCurrentWeek
    @pick = @entry.picks.new(pick_params.merge(week_id: @week.id,
                                               weekNumber: @week.weekNumber))
    if @pick.save
      # Handle a successful save
      flash[:success] = 
          "Your pick(s) for Week '#{@week.weekNumber}' was saved!"
      redirect_to @pool
    else
      render 'new'
    end
  end

  private
    def pick_params
      params.require(:pick).permit(:week_id, :total_score, 
                                   :weekNumber, :sup_points,
                                   game_picks_attributes: [:id, :pick_id,
                                                     :chosenTeamIndex] )
    end

    def pickErrorCheck(week, entry)
      if week.open?
        if week.madePicks?(entry)
          message = 
             "You have already made your pick(s) for entry: #{entry.name}!"
        elsif !entry.entryStatusGood?
          message =
            "You have been knocked out of the pool!"
        end
      elsif week.closed?
        message = 
             "You're too late! Week #{week.weekNumber} is already closed!"
      else
        message = "Week #{week.weekNumber} is not open for picks yet!"
      end
    end

end
