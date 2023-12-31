# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    # before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    # def create
    #   super
    # end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # Method is responsible for updating_user_fields without password,
    # Only applicable for user that uses 'google_oauth2' for authentication.
    def update_resource(resource, params)
      if resource.provider == 'google_oauth2'
        params.delete(:current_password)
        params.delete(:password)
        params.delete(:password_confirmation)
        # resource.password = params['password']

        resource.update_without_password(params)
      else
        resource.update_with_password(params)
      end
    end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_up_params
    #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
    # end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[name title role])
    end

    # The path used after sign up.
    def after_sign_up_path_for(_resource)
      stored_location_for(resource_or_scope) || root_path(subdomain: 'internal')
    end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
