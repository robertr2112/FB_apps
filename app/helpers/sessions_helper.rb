module SessionsHelper
  # Handle all of the Sign in functions
  def sign_in(user)
    remember_token = User.new_remember_token
    #  Use of cookies to save a session for longer than browser duration
    cookies.permanent[:remember_token] = remember_token
    #  Use session to have a session end when browser closes
#   session[:user_id] = user.id
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    #  Use of cookies to save a session for longer than browser duration
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
    #  Use session to have a session end when browser closes
#   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    #  Use of cookies to save a session for longer than browser duration
    cookies.delete(:remember_token)
    #  Use session to have a session end when browser closes
#   session[:user_id] = nil
  end

  def current_user?(user)
    user == current_user
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  private

    #
    # These functions are used only when using cookies for session mgmt
    #
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
