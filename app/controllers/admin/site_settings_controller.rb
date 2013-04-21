class Admin::SiteSettingsController < ApplicationController
  inherit_resources
  actions :all, except: [:show, :create, :new]
  before_filter :authenticate_user!
  before_filter :require_admin
end
