class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :relationships, dependent: :destroy
  has_many :hotsprings, through: :relationships
  has_many :wannagoes
  has_many :wannago_hotsprings, through: :wannagoes, source: :hotspring
  has_many :wents
  has_many :went_hotsprings, through: :wents, source: :hotspring
  
  def wannago(hotspring)
    self.wannagoes.find_or_create_by(hotspring_id: hotspring.id)
  end
  
  def unwannago(hotspring)
    wannago = self.wannagoes.find_by(hotspring_id: hotspring.id)
    wannago.destroy if wannago
  end

  def wannago?(hotspring)
    self.wannago_hotsprings.include?(hotspring)
  end
  
  def went(hotspring)
    self.wents.find_or_create_by(hotspring_id: hotspring.id)
  end
  
  def unwent(hotspring)
    went = self.wents.find_by(hotspring_id: hotspring.id)
    went.destroy if went
  end
  
  def went?(hotspring)
    self.went_hotsprings.include?(hotspring)
  end
    
end
