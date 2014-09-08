class PoolMailer < ActionMailer::Base
  default from: "fbpoolmania@gmail.com"
  
  def send_pool_message(pool, subject, msg, allMembers)
    @pool = pool
    @msg = msg
    email_list = Array.new
    @pool.users.each do |user|
      if allMembers
        entries = Entry.where(pool_id: @pool.id, user_id: user.id)
      else
        entries = Entry.where(pool_id: @pool.id, user_id: user.id, survivorStatusIn:true)
      end
      if entries.any?
        email_list << "#{user.name} <#{user.email}>"
      end
    end
    subject_text = pool.name + "- " + subject
    attachments.inline['fbpm_logo.png'] = File.read(Rails.root + "app/assets/images/fbpm_logo.png")
    user = pool.getOwner
    if mail to: email_list, from: user.email, subject: subject_text
      puts "Successfully sent email"
      return false
    else
      puts "Couldn't send email"
      return true
    end
  end
end
