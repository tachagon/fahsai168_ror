class Relation < ActiveRecord::Base

  belongs_to :sponser, class_name: "User"
  belongs_to :sponsered, class_name: "User"

  validates :sponser_id, presence: true
  validates :sponsered_id, presence: true, uniqueness: true

end
