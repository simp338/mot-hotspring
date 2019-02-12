class Prefecture < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :code, presence: true, length: { maximum: 50 }
  
  has_many :cities
  has_many :districts
end
