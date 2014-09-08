class PoolMessagesController < ApplicationController
  def new
    @pool = Pool.find(params[:pool_id])
  end
  def create
    @pool = Pool.find(params[:pool_id])
    if @pool
      if params[:allMembers] == "true"
        mail_group = true
      else
        mail_group = false
      end
        
      if PoolMailer.send_pool_message(@pool, params[:subject], params[:msg], mail_group).deliver
        redirect_to @pool, notice: "Email sent!"
      else
        redirect_to @pool, notice: "Email not sent. There was a problem with the mailer!"
      end
    else
      redirect_to @pool, notice: "Email not sent. Could not find pool!"
    end
  end
end
