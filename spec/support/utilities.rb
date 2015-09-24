module AuthenticationHelper

 def signin_login(user)
    visit signin_path
    find('#signin_email').set(user.email)
    find('#signin_password').set(user.password)
    find('#signin_button').click
  end

end

module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last
  end
	
  def extract_token_from_email(token_name)
    mail_body = last_email.body.to_s
    mail_body[/#{token_name.to_s}_token=([^"]+)/, 1]
  end
end


