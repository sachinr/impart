class Admin::UserConfirmationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin

  def update
    @user = User.find(params[:id])
    @user.confirmed = params[:confirmed]
    if @user.save
      respond_to do |format|
        format.json { render nothing: true }
      end
    end
  end
end
