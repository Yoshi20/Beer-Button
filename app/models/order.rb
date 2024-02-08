class Order < ApplicationRecord
  belongs_to :device

  scope :open, -> { where(acknowledged: false) }
  scope :closed, -> { where(acknowledged: true).order(acknowledged_at: :desc) }

  after_create_commit :broadcast_new_order

  MAX_ORDERS_PER_PAGE = 100

  def new?
    self.acknowledged_at > 5.minute.ago
  end

  def acknowledge(user)
    self.acknowledged = true
    self.acknowledged_at = Time.now
    self.acknowledged_by = user.email
  end

  def self.open_as_hash_with_counter
    order_titles = []
    orders = []
    Order.open.each do |o|
      if order_titles.include?(o.title)
        orders.each do |o2|
          if o2[:title] == o.title
            o2[:count] = o2[:count] + 1
            break
          end
        end
      else
        orders << o.as_hash_with_counter
        order_titles << o.title
      end
    end
    orders
  end

  def as_hash_with_counter
    {
      id: self.id,
      title: self.title,
      created_at: self.created_at,
      count: 1,
    }
  end

  def open_as_hash_with_counter
    open_order_with_counter = {}
    Order.open_as_hash_with_counter.each do |o|
      if o[:title] == self.title
        open_order_with_counter = o
        break
      end
    end
    open_order_with_counter
  end

private

  def broadcast_new_order
    order = self.open_as_hash_with_counter
    if order[:count] > 1
      broadcast_replace_to 'open_orders', target: "order-#{order[:id]}", partial: 'open_orders/single_order', locals: { order: order }
    else
      broadcast_append_to 'open_orders', partial: 'open_orders/single_order', locals: { order: order }
      broadcast_update_to 'open_orders', target: "open-orders-count", html: "#{Order.open_as_hash_with_counter.count}"
    end
  end

end
