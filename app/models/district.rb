class District < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :code, presence: true, length: { maximum: 50 }

  belongs_to :prefecture
  belongs_to :city
end
