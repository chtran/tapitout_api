class SessionsController < Devise::SessionsController
  def create
    respond_to do |format|
      format.html do 
        super
      end
      format.json do
        warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        render :status => 200, :json => { :session => { :error => "Success", :auth_token => current_user.authentication_token, :email => current_user.email, :name => current_user.name, :balance => current_user.balance}}
      end
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        current_user.authentication_token = nil
        render :json => {}.to_json, :status => :ok
      end
    end
  end

end
