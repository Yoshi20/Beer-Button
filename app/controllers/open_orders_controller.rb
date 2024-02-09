class OpenOrdersController < ApplicationController
  before_action :set_order, only: [:update, :destroy]
  before_action { @section = 'open_orders' }

  # GET /open_orders
  # GET /open_orders.json
  def index
    @orders = Order.open_as_hash_with_counter_from_user(current_user.id)
  end

  # PATCH/PUT /open_orders/1
  # PATCH/PUT /open_orders/1.json
  def update
    respond_to do |format|
      @order.acknowledge(current_user) if order_params[:acknowledged] == "1"
      if @order.save
        if order_params[:acknowledged] == "1"
          # Also ack orders with the same title
          Order.from_user(current_user.id).open.where(title: @order.title).each do |o|
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

  # DELETE /open_orders/1
  # DELETE /open_orders/1.json
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
      @order = Order.from_user(current_user.id).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:acknowledged)
    end

end
