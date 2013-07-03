module SessionsHelper
  # Handle all of the Sign in functions
  def sign_in(user)
    ### Eventually need to add a "keep me logged in flag" which will decide whether
    ### to use cookies or session to manage the session duration, for now just
    ### comment out the cookies references
    #  Use of cookies to save a session for longer than browser duration
#   cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    #  Use session to have a session end when browser closes
    session[:user_id] = user.id
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    ### Eventually need to add a "keep me logged in flag" which will decide whether
    ### to use cookies or session to manage the session duration, for now just
    ### comment out the cookies references
    #  Use of cookies to save a session for longer than browser duration
#   @current_user ||= user_from_remember_token
    #  Use session to have a session end when browser closes
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    ### Eventually need to add a "keep me logged in flag" which will decide whether
    ### to use cookies or session to manage the session duration, for now just
    ### comment out the cookies references
    #  Use of cookies to save a session for longer than browser duration
#   cookies.delete(:remember_token)
    #  Use session to have a session end when browser closes
    session[:user_id] = nil
    self.current_user = nil
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
    clear_return_to
  end

  private

    #
    # These functions are used only when using cookies for session mgmt
    #
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

    def store_location
      session[:return_to] = request.fullpath
    end
    def clear_return_to
      session[:return_to] = nil
    end
end
