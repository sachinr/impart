class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_admin
    unless current_user && current_user.admin?
      flash[:error] = 'Sorry! This page is for adults only.  Go play outside'
      redirect_to root_url
    end
  end
end
