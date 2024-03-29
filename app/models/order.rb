class Order < ApplicationRecord
  belongs_to :device
  belongs_to :user

  scope :open, -> { where(acknowledged: false) }
  scope :closed, -> { where(acknowledged: true).order(acknowledged_at: :desc) }
  scope :from_user, -> (user_id) { where(user_id: user_id) }

  after_create_commit :broadcast_new_order
  after_update_commit :broadcast_updated_order

  MAX_ORDERS_PER_PAGE = 100

  def new?
    self.acknowledged_at > 5.minute.ago
  end

  def acknowledge(user)
    self.acknowledged = true
    self.acknowledged_at = Time.now
    self.acknowledged_by = user.email
  end

  def unacknowledge
    self.acknowledged = false
    self.acknowledged_at = nil
    self.acknowledged_by = nil
  end

  def self.open_as_hash_with_counter_from_user(user_id)
    order_titles = []
    orders = []
    Order.from_user(user_id).open.each do |o|
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
    Order.open_as_hash_with_counter_from_user(self.user_id).each do |o|
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
    total_orders_count = Order.open_as_hash_with_counter_from_user(self.user_id).count
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        if order[:count] > 1
          broadcast_replace_to ['open_orders', self.user_id, locale], target: "order-#{order[:id]}", partial: 'open_orders/single_order', locals: { order: order, target_name: 'replacedOrder' }
        else
          broadcast_append_to ['open_orders', self.user_id, locale], partial: 'open_orders/single_order', locals: { order: order, target_name: 'newOrder' }
          broadcast_update_to ['open_orders', self.user_id, locale], target: "open-orders-count", html: "#{total_orders_count}"
        end
      end
    end
  end

  def broadcast_updated_order
    if self.acknowledged
      total_orders_count = Order.open_as_hash_with_counter_from_user(self.user_id).count
      I18n.available_locales.each do |locale|
        I18n.with_locale(locale) do
          broadcast_update_to ['open_orders', self.user_id, I18n.locale], target: "open-orders-count", html: "#{total_orders_count}"
          broadcast_remove_to ['open_orders', self.user_id, I18n.locale], target: "order-#{self.id}"
        end
      end
    else
      self.broadcast_new_order
    end
  end

end
