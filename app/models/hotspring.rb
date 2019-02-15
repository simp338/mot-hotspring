class Hotspring < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :url, presence: true, length: { maximum: 255 }
  validates :code, presence: true, length: { maximum: 255 }
  validates :image_url, presence: false, length: { maximum: 255 }

  has_many :relationships
  has_many :user, through: :relationships
  has_many :wannagoes
  has_many :wannago_hotsprings, through: :wannagoes, source: :user
end
