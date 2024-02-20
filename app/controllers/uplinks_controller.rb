class UplinksController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  # POST /lora_uplink
  # POST /lora_uplink.json
  def lora_uplink
    dev_eui = params['uplink']['end_device_ids']['dev_eui']
    device = Device.find_by(dev_eui: dev_eui)
    return head :not_found if device.nil?
    payload_raw = params['uplink']['uplink_message']['frm_payload']
    payload = Base64.decode64(payload_raw).bytes.map{|b| sprintf("%02X", b)}.join
    event = nil
    if device.type == 'Dragino-LDS02' || device.type == 'Dragino-LWL02'
      open_status = ((payload[0..1].to_i(16) & 0x80) != 0 ? 1 : 0) unless payload[0..1].nil?
      leak_status = ((payload[0..1].to_i(16) & 0x40) != 0 ? 1 : 0) unless payload[0..1].nil?
      battery = (payload[0..3].to_i(16) & 0x3FFF) unless payload[0..3].nil?
      # battery = (100 * (battery-1600) / (3200-1600)) if battery.present?
      mod = payload[4..5].to_i(16) unless payload[4..5].nil?
      alarm = payload[18..19].to_i(16) unless payload[18..19].nil?
      ActiveRecord::Base.transaction do
        case mod
        when 1  # Dragino door sensor
          open_times = payload[6..11].to_i(16) unless payload[6..11].nil?
          open_duration = payload[12..17].to_i(16) unless payload[12..17].nil?
          device.update(battery: battery, last_time_seen: Time.now)
          event = Order.create!(
            title: device.name,
            text: "{\"openStatus\":#{open_status},\"openCtr\":\"#{open_times}\",\"lastOpenDur\":\"#{open_duration}\",\"alarm\":#{alarm},\"bat\":#{battery}}",
            data: params.to_json.to_s,
            device_id: device.id,
            user_id: device.user_id,
          )
        when 2  # Dragino water leak sensor
          leak_times = payload[6..11].to_i(16) unless payload[6..11].nil?
          leak_duration = payload[12..17].to_i(16) unless payload[12..17].nil?
          device.update(battery: battery, last_time_seen: Time.now)
          event = Order.create!(
            title: device.name,
            text: "{\"leakStatus\":#{leak_status},\"leakCtr\":\"#{leak_times}\",\"leakDur\":\"#{leak_duration}\",\"alarm\":#{alarm},\"bat\":#{battery}}",
            data: params.to_json.to_s,
            device_id: device.id,
            user_id: device.user_id,
          )
        when 3  # both sensors -> heartbeat?
          device.update(battery: battery, last_time_seen: Time.now)
          event = Order.create!(
            title: device.name,
            text: "{\"openStatus\":#{open_status},\"leakStatus\":#{leak_status},\"alarm\":#{alarm},\"bat\":#{battery}}",
            data: params.to_json.to_s,
            device_id: device.id,
            user_id: device.user_id,
          )
        else
          raise "dragino_sensor_mod: \"#{mod}\" is invalid"
        end
        render json: event, status: :created
      # rescue => errors
      #   render json: errors, status: :unprocessable_entity
      end
    elsif device.type == 'LoRa-EPD-2Btns' || device.type == 'Buttonboard'
      lora_message_id = payload[0...2]
      ActiveRecord::Base.transaction do
        case lora_message_id
        # when "00"  # heartbeat
        # when "20"  # any button clicked
        # when "21"  # any button clicked with image ID
        # when "22"  # specific button clicked
        when "30"  # Oxobutton event
          button_number = payload[2..3].to_i(16) unless payload[2..3].nil?
          is_heartbeat = payload[4..5].to_i(16) != 0 unless payload[4..5].nil?
          image_code = payload[8..11]
          battery = payload[12..13].to_i(16) unless payload[12..13].nil?
          temperature = payload[14..15].to_i(16) unless payload[14..15].nil?
          device.update(battery: battery, last_time_seen: Time.now)
          unless is_heartbeat
            event = Order.create!(
              title: device.name,
              text: "{\"btnNr\":#{button_number},\"imgCode\":\"#{image_code}\",\"bat\":#{battery},\"temp\":#{temperature}}",
              data: params.to_json.to_s,
              device_id: device.id,
              user_id: device.user_id,
            )
          end
        when "31"  # Buttonboard event
          button_number = payload[2..3].to_i(16) unless payload[2..3].nil?
          is_heartbeat = payload[4..5].to_i(16) != 0 unless payload[4..5].nil?
          # accel_irq = payload[6..7].to_i(16) unless payload[6..7].nil?
          app_mode = payload[8..9].to_i(16) unless payload[8..9].nil?
          # enabled_buttons = payload[10..11].to_i(16) unless payload[10..11].nil?
          battery = payload[12..13].to_i(16) unless payload[12..13].nil?
          temperature = payload[14..15].to_i(16) unless payload[14..15].nil?
          device.update(battery: battery, last_time_seen: Time.now)
          unless is_heartbeat
            event = Order.create!(
              title: device.name,
              text: "{\"btnNr\":#{button_number},\"appMode\":\"#{app_mode}\",\"bat\":#{battery},\"temp\":#{temperature}}",
              data: params.to_json.to_s,
              device_id: device.id,
              user_id: device.user_id,
            )
          end
        else
          raise "lora_message_id: \"#{lora_message_id}\" is invalid"
        end
        render json: event, status: :created
      rescue => errors
        render json: errors, status: :unprocessable_entity
      end
    end
  end

end
