class City < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :code, presence: true, length: { maximum: 50 }
  
  belongs_to :prefecture
  has_many :districts
end
