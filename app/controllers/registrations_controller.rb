class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def new
    super
  end

  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with do |format|
          format.json { render }
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with do |format|
          format.json { render }
        end
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def update
    super
  end

end
