class PoolsController < ApplicationController
  before_action :signed_in_user
  before_action :confirmed_user

  def new
    year = Time.now.strftime("%Y")
    seasons = Season.where(year: year)
    if !seasons.empty?
      @pool = current_user.pools.new
      @pool_edit_flag = false
    else
      flash[:error] = "Cannot create a pool because the #{year} season is not ready for pools!"
      redirect_to_back_or_default(pools_path)
    end
  end

  def create
    # Get either the NFL or college season
    year = Time.now.strftime("%Y")
    if Pool.typeSUP?(pool_params[:poolType])
      season = Season.where(year: year, nfl_league: false).first
    else
      season = Season.where(year: year, nfl_league: true).first
    end
    
    if season && season.isOpen?
      # If the season is setup then create the pool.
      @pool = current_user.pools.create(pool_params.merge(season_id: season.id))
      if @pool.id
        # create entry for owner of pool
        entry_name = @pool.getEntryName(current_user)
        new_entry_params = { name: entry_name }
        @pool.entries.create(new_entry_params.merge(user_id: current_user.id))
        # Handle a successful save
        flash[:success] = "Pool '#{@pool.name}' was created successfully!"
        # Set the ownership in PoolMembership.owner
        @pool.setOwner(current_user, true)
        redirect_to @pool
      else
        render 'new'
      end
    else
      flash[:error] = "Cannot create a pool because the #{year} season is not ready for pools!"
      redirect_to pools_path
    end
  end

  def join
    # Test to make sure User is not already a member of this pool
    @pool = Pool.find(params[:id])
    if @pool.isMember?(current_user)
      flash[:notice] = "Already a member of Pool '#{@pool.name}'!"
      redirect_to @pool
    else
      @pool.addUser(current_user)
      flash[:success] = "Successfully added to Pool '#{@pool.name}'!"
      redirect_to @pool
    end
  end

  def leave
    @pool = Pool.find(params[:id])
    if @pool.isOwner?(current_user)
      flash[:error] = "Owner cannot leave the pool!"
      redirect_to @pool
    elsif !@pool.isMember?(current_user)
      flash[:error] = "Not a member of Pool '#{@pool.name}'!"
      redirect_to pools_path
    else
      @pool.removeUser(current_user)
      flash[:success] = "Successfully removed from Pool '#{@pool.name}'!"
      redirect_to pools_path
    end
  end

  def my_pools
    @pools = current_user.pools.paginate(page: params[:page])
  end

  def index
    @pools = Pool.paginate(page: params[:page])
  end

  def show
    @pool = Pool.find(params[:id])
    if @pool.nil?
      flash[:notice] = 'The pool you tried to access does not exist'
      redirect_to pools_path
    else
      @pools = @pool.users.paginate(:page => params[:page])
      @season = Season.find(@pool.season_id)
      @current_week = @pool.getCurrentWeek
    end
  end

  def edit
    @pool = Pool.find(params[:id])
    if @pool
      @season = Season.find(@pool.season.id)
      if @season.getCurrentWeek.week_number > 1
        @pool_edit_limited = true
      else
        @pool_edit_limited = false
      end
      @pool_edit_flag = true
    
      if !@pool.isOwner?(current_user)
        flash[:error] = "Only the owner can edit the pool!"
        redirect_to pools_path
      end
    else
        flash[:error] = "Cannot find Pool with id #{params[:id]}!"
        redirect_to pools_path
    end
  end
  
  def update
    @pool = Pool.find(params[:id])
    if @pool.isOwner?(current_user)
      if @pool.update_attributes(pool_params)
        flash[:success] = "Pool updated."
        redirect_to @pool
      else
        render 'edit'
      end
    else
      flash[:error] = "Only the owner can edit the pool!"
      redirect_to pools_path
    end
  end

  def destroy
    @pool = Pool.find(params[:id])
    if @pool.isOwner?(current_user)
      @pool.remove_memberships
      @pool.recurse_delete
      flash[:success] = "Successfully deleted Pool '#{@pool.name}'!"
      redirect_to pools_path
    else
      flash[:error] = "Only the onwer can delete the pool!"
      redirect_to pools_path
    end
  end
  
  private

    def pool_params
      params.require(:pool).permit(:name, :poolType, :allowMulti, 
                                   :isPublic, :password)
    end

    def authenticate
      deny_access unless signed_in?
    end

end
