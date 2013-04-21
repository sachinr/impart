class Admin::UsersController < ApplicationController
  inherit_resources
  before_filter :authenticate_user!
  before_filter :require_admin
end
