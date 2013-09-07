class PicksController < ApplicationController
  before_action :signed_in_user
  before_action :confirmed_user

  def new
    @week = Week.find(params[:week_id])
    if !@week.nil?
      @pool = Pool.find(@week.pool_id)
      if @week.checkStateOpen
        if @week.madePicks?(current_user)
          flash[:error] = 
            "You have already made your picks for Week #{@week.weekNumber}!"
          redirect_to @pool
        else
          @pick = @week.picks.new
          @game_pick = @pick.game_picks.new
        end
      else
        flash[:error] = 
          "Cannot do your picks. Week #{@week.weekNumber} is already closed!"
        redirect_to @pool
      end
    else
      flash[:error] = 
        "Cannot do your picks. Week with id:#{params[:week_id]} does not exist!"
      redirect_to pools_path
    end
  end

  def create
    @week = Week.find(params[:week_id])
    @pick = @week.picks.new(pick_params)
    @pool = Pool.find(@week.pool_id)
    if @pick.save
      # Handle a successful save
      flash[:success] = 
          "Your picks for Week '#{@week.weekNumber}' were saved!"
      @pick.setUserId(current_user)
      redirect_to @pool
    else
      render 'new'
    end
  end

  private
    def pick_params
      params.require(:pick).permit(:user_id, :total_score, 
                                   :survivor_status, :sup_points,
                                   game_picks_attributes: [:id, :pick_id,
                                                     :chosenTeamIndex] )
    end
end
