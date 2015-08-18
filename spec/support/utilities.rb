module AuthenticationHelper

  def signin_login(user)
    visit signin_path
    find('#signin_email').set(user.email)
    find('#signin_password').set(user.password)
    find('#signin_button').click
  end

end

