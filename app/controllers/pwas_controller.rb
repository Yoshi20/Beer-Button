class PwasController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  before_action { @section = 'pwas' }

  def index
    @devices = current_user.devices.includes(:device_type).order(:name)
    # @devices = filter_devices(@devices) if params[:filter].present?
    respond_to do |format|
      format.html { @devices_total_count = @devices.count }
      format.json { @devices.to_json }
    end
  end

  def show

  end

  def new
    @device = Device.new
    @device_types = DeviceType.all
  end

  def edit

  end

  def create
    @device = Device.new(device_params)
    @device.user = current_user
    respond_to do |format|
      if @device.save
        format.html { redirect_to devices_url, notice: t('flash.notice.creating_device') }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new, alert: t('flash.alert.creating_device') }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to devices_url, notice: t('flash.notice.updating_device') }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit, alert: t('flash.alert.updating_device') }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @device.destroy
        format.html { redirect_to devices_url, notice: t('flash.notice.deleting_device') }
        format.json { head :no_content }
      else
        format.html { render :show, alert: t('flash.alert.deleting_device') }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_device
    begin
      @device = Device.find_by(id: Integer(params[:id]))
      if @device.blank? && params[:id].size == 6
        @device = Device.where('dev_eui LIKE ?', "%#{params[:id]}").first
      end
    rescue ArgumentError
      case params[:id].size
      when 16
        @device = Device.find_by(dev_eui: params[:id])
      when 6
        @device = Device.where('dev_eui LIKE ?', "%#{params[:id]}").first
      else
        raise ActiveRecord::RecordNotFound
      end
    end
    if @device.blank?
      raise ActiveRecord::RecordNotFound
    else
      @device
    end
  end

  def device_params
    params.require(:device).permit(
      :name, :dev_eui, :app_eui, :app_key, :hw_version, :fw_version,
      :device_type_id
    )
  end

end
