module AuthenticationHelper

 def sign_in(user, options={})
   if options[:no_capybara]
     # Sign in when not using Capybara.
     remember_token = User.new_remember_token
     cookies[:remember_token] = remember_token
     user.update_attribute(:remember_token, User.encrypt(remember_token))
   else
     visit signin_path
     find('#signin_email').set(user.email)
     find('#signin_password').set(user.password)
     find('#signin_button').click
   end
 end

#end

#module MailerMacros
#  def last_email
#    ActionMailer::Base.deliveries.last
#  end
#	
#  def extract_token_from_email(token_name)
#    mail_body = last_email.body.to_s
#    mail_body[/#{token_name.to_s}_token=([^"]+)/, 1]
#  end

 #
 # Debug code
 #
 #save_and_open_page
 #puts current_url
 #pry
 
end


