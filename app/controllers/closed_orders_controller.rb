class ClosedOrdersController < ApplicationController
  before_action :set_order, only: [:update, :destroy]
  before_action { @section = 'closed_orders' }

  # GET /closed_orders
  # GET /closed_orders.json
  def index
    @orders = Order.from_user(current_user.id).closed.paginate(page: params[:page], per_page: Order::MAX_ORDERS_PER_PAGE)
  end

  # PATCH/PUT /closed_orders/1
  # PATCH/PUT /closed_orders/1.json
  def update
    respond_to do |format|
      @order.unacknowledge if order_params[:acknowledged] == "0"
      if @order.save
        format.html { redirect_to open_orders_path, notice: t('flash.notice.updating_order') }
        format.json { render json: {order: @order}, status: :ok }
      else
        format.html { redirect_to closed_orders_path, notice: t('flash.alert.updating_order') }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /closed_orders/1
  # DELETE /closed_orders/1.json
  def destroy
    respond_to do |format|
      if @order.destroy
        format.html { redirect_to closed_orders_path, notice: t('flash.notice.deleting_order') }
        format.json { head :no_content }
      else
        format.html { redirect_to closed_orders_path, notice: t('flash.alert.deleting_order') }
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
