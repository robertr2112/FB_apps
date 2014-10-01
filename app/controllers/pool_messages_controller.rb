class PoolMessagesController < ApplicationController
  def new
    @pool = Pool.find(params[:pool_id])
  end
  def create
    @pool = Pool.find(params[:pool_id])
    if @pool.nil?
      redirect_to @pool, notice: "Email not sent. Could not find pool!"
    end
    
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
  end

  # Build an invite message
  def invite
    @pool = Pool.find(params[:id])
    if @pool.nil?
      redirect_to @pool, notice: "Email not sent. Could not find pool!"
    end
    @email_addr_errors = Array.new
    @pool_list = Array.new
    current_user.pools.each do |pool|
      if pool.isOwner?(current_user)
        @pool_list << pool
      end
    end
  end

  # Send invite message after form
  def send_invite
    pool = Pool.find(params[:id])
    if pool.nil?
      redirect_to pool, notice: "Email not sent. Could not find pool!"
    end
    @email_addr_errors = Array.new
    email_addrs = Array.new
    emailPool = Pool.find(params[:emailPoolList])
    if emailPool
      emailPool.users.each do |user|
        email_addrs << user.email
      end
    end
    emailList = params[:emailListAddrs].split(",")
    emailList.each do |emailAddr|
      emailAddr = emailAddr.strip
      if !validate_email(emailAddr)
        @email_addr_errors << "There is an error with address: #{emailAddr}"
      else
        email_addrs << emailAddr
      end
    end
    if @email_addr_errors.empty?
      if PoolMailer.send_pool_invite(pool, params[:subject], params[:msg], email_addrs).deliver
        redirect_to pool, notice: "Email sent!"
      else
        redirect_to pool, notice: "Email not sent. There was a problem with the mailer!"
      end
    else
      flash[:error] = "There were errors with the form!"
      render 'invite'
      return
    end
  end
  
  private
  
    def validate_email(value)
      m = Mail::Address.new(value)
      # We must check that value contains a domain and that value is an email address
      r = m.domain && m.address == value
      t = m.__send__(:tree)
      # We need to dig into treetop
      # A valid domain must have dot_atom_text elements size > 1
      # user@localhost is excluded
      # treetop must respond to domain
      # We exclude valid email values like <user@localhost.com>
      # Hence we use m.__send__(tree).domain
      r &&= (t.domain.dot_atom_text.elements.size > 1)
      rescue Exception => e
        r = false
    end
end
