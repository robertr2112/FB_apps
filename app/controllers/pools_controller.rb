class PoolsController < ApplicationController
  before_action :signed_in_user
  before_action :confirmed_user

  def new
    @pool = current_user.pools.new
    @pool_edit_flag = false
  end

  def create
    @pool = current_user.pools.create(pool_params)
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
    @pool = Pool.find_by_id(params[:id])
    if @pool.nil?
      flash[:notice] = 'The pool you tried to access does not exist'
      redirect_to pools_path
    else
      @pools = @pool.users.paginate(:page => params[:page])
      @current_week = @pool.getCurrentWeek
    end
  end

  def edit
    @pool = Pool.find(params[:id])
    if !@pool.isOwner?(current_user)
      flash[:error] = "Only the owner can edit the pool!"
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
      @pool.destroy
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
