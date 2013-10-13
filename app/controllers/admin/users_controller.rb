class Admin::UsersController < ApplicationController
  inherit_resources
  before_filter :authenticate_user!
  before_filter :require_admin

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to admin_users_path
    else
      render :edit
    end
  end
end
