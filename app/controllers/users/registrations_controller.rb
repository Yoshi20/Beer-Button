# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action { @section = 'account' }
  prepend_before_action :check_captcha, only: [:create]
  # before_action :authenticate_admin!, only: [:new, :create]
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @section = 'sign_up'
    super
  end

  # POST /resource
  def create
    super do |user|
      if user.persisted?
        UserMailer.with(email: user.email, phone: user.phone_number).registraion_email.deliver_later
        # UserMailer.with(user: user, locale: I18n.locale).welcome_email.deliver_later
      end
    end
  end

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

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    home_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def authenticate_admin!
    unless current_user.present? && current_user.admin?
      render_forbidden
      return
    end
  end

  def render_forbidden
    respond_to do |format|
      format.html { redirect_to root_path, alert: t('flash.alert.unauthorized') }
      format.json { render json: { status: 'error', message: t('flash.alert.unauthorized') }, status: :forbidden }
    end
  end


  private

  def check_captcha
    return if verify_recaptcha(secret_key: ENV["RECAPTCHA_SECRET_KEY_BB"])

    self.resource = resource_class.new sign_up_params
    resource.validate # Look for any other validation errors besides reCAPTCHA
    set_minimum_password_length

    respond_with_navigational(resource) do
      flash.discard(:recaptcha_error) # We need to discard flash to avoid showing it on the next page reload
      render :new
    end
  end

end
