class AddUserIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :user_id, :bigint
    add_foreign_key :orders, :users
    add_index :orders, :user_id

    # also add some missing index
    add_index :orders, :device_id
    add_index :devices, :device_type_id
    add_index :devices, :user_id

    # update all orders if necessary
    if column_exists?(:orders, :user_id)
      Order.all.each do |order|
        order.update(user_id: order.device.user_id) if order.user_id.nil?
      end
    end

  end
end
