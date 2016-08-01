class Position < ActiveRecord::Base

  has_many :users

  before_save{name.downcase!}

  validates :name, presence: true, length: {maximum: 50}
  validates :layer, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :min_pv, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}

end
