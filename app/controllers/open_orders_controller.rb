class OpenOrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]
  before_action { @section = 'open_orders' }

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.open_as_hash_with_counter
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    order = @order.open_as_hash_with_counter
    respond_to do |format|
      format.js {render partial: 'single_order', locals: {order: order, target_name: ''}, layout: false}
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      @order.acknowledge(current_user) if order_params[:acknowledged]
      if @order.save
        if order_params[:acknowledged]
          # Also ack orders with the same title
          Order.open.where(title: @order.title).each do |o| # blup: und same customer?
            o.acknowledge(current_user)
            o.save
          end
          format.turbo_stream {} # nothing to do, broadcasts are handled with -> after_update_commit :broadcast_updated_order
        end
        format.html { redirect_to open_orders_path, notice: t('flash.notice.updating_order') }
        format.json { render json: {order: @order}, status: :ok }
      else
        format.html { redirect_to open_orders_path, notice: t('flash.alert.updating_order') }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    respond_to do |format|
      if @order.destroy
        format.html { redirect_to open_orders_path, notice: t('flash.notice.deleting_order') }
        format.json { head :no_content }
      else
        format.html { redirect_to open_orders_path, notice: t('flash.alert.deleting_order') }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:acknowledged)
    end

end
