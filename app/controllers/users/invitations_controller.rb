class Users::InvitationsController < Devise::InvitationsController

  def update
    self.resource = resource_class.accept_invitation!(resource_params)
    self.resource.confirmed = true
    if resource.errors.empty? && resource.save!
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message :notice, flash_message
      sign_in(resource_name, resource)
      respond_with resource, :location => after_accept_path_for(resource)
    else
      respond_with_navigational(resource){ render :edit }
    end
  end

end
