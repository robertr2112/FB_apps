class PoolMailer < ActionMailer::Base
  default from: "info@footballpoolmania.com"
  
  def send_pool_message(pool,subject,msg, allMembers)
    @pool = pool
    @msg = msg
    email_list = Array.new
    @pool.users.each do |user|
      if allMembers
        entries = Entry.where(user_id: user.id)
      else
        entries = Entry.where(user_id: user.id, survivorStatusIn:true)
      end
      if entries.any?
        email_list << "#{user.name} <#{user.email}>"
      end
    end
    mail to: email_list, subject: subject
  end
end
