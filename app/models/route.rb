class Route < ActiveRecord::Base
  has_many :schedules, dependent: :destroy
  has_many :cart_items, class_name: 'UserCartItem', dependent: :destroy

  has_many :subroutes, class_name: 'Route', foreign_key: :parent_id
  belongs_to :parent, class_name: 'Route', foreign_key: :parent_id

  has_many :route_requests

  scope :root, -> { where(parent: nil) }
  scope :not_root, -> { where.not(parent: nil) }
  scope :not_hidden, -> { where(hidden: false) }

  accepts_nested_attributes_for :schedules, :subroutes, allow_destroy: true

  validates_inclusion_of :direction, in: %w(North South)

  def display_name
    "#{origin} 到 #{destination}"
  end

  def short_name
    "#{origin} - #{destination}"
  end

  def is_available?
    self.is_available
  end

  def is_full?
    self.fake_full
  end
end
