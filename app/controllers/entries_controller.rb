class EntriesController < ApplicationController
  before_action :signed_in_user
  before_action :confirmed_user

  def new
    @week = Week.find(params[:week_id])
    if !@week.nil?
      @pool = Pool.find(@week.pool_id)
      if @week.checkStateOpen
        if @week.madeEntry?(current_user)
          flash[:error] = 
            "You have already made your entry for Week #{@week.weekNumber}!"
          redirect_to @pool
        else
          @entry = @week.entries.new
          @game_pick = @entry.game_picks.new
        end
      else
        flash[:error] = 
          "Cannot do your entry. Week #{@week.weekNumber} is already closed!"
        redirect_to @pool
      end
    else
      flash[:error] = 
        "Cannot do your entry. Week with id:#{params[:week_id]} does not exist!"
      redirect_to pools_path
    end
  end

  def create
    @week = Week.find(params[:week_id])
    @entry = @week.entries.new(entry_params)
    @pool = Pool.find(@week.pool_id)
    if @entry.save
      # Handle a successful save
      flash[:success] = 
          "Your entry for Week '#{@week.weekNumber}' was saved!"
      @entry.setUserId(current_user)
      redirect_to @pool
    else
      render 'new'
    end
  end

  private
    def entry_params
      params.require(:entry).permit(:user_id, :total_score, 
                                   :survivor_status, :sup_points,
                                   game_picks_attributes: [:id, :entry_id,
                                                     :chosenTeamIndex] )
    end
end
