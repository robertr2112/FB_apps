class PoolMessagesController < ApplicationController
  def new
    @pool = Pool.find(params[:pool_id])
  end
  def create
    @pool = Pool.find(params[:pool_id])
    if @pool
      PoolMailer.send_pool_message(@pool, params[:subject], params[:msg], params{:allMembers})
      redirect_to @pool, notice: "Email sent."
    else
      redirect_to @pool, notice: "Email not sent. Could not find pool!"
    end
  end
end
