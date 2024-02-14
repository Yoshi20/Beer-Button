class ContactController < ApplicationController
  skip_before_action :authenticate_user!
  before_action { @section = 'contact' }

  # GET /contact
  # GET /contact.json
  def index
  end

  # POST /contact
  def create
    respond_to do |format|
      if verify_recaptcha(secret_key: ENV["RECAPTCHA_SECRET_KEY_BB"])
        if params[:email].present? && params[:text].present? && !params[:url].present? # the :url is used to trick spam bots
          ContactMailer.with(name: params[:name], email: params[:email], text: params[:text]).contact_email.deliver_later
          format.html { redirect_to root_path, notice: t('flash.notice.contact') }
        else
          format.html { redirect_to contact_path(name: params[:name], email: params[:email], text: params[:text], url: params[:url]), alert: t('flash.alert.contact') }
        end
      else
        format.html { redirect_to contact_path(name: params[:name], email: params[:email], text: params[:text], url: params[:url]), alert: t('recaptcha.errors.verification_failed') }
      end
    end
  end

end
