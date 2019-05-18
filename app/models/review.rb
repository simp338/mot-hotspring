class Review < ApplicationRecord
  before_validation :set_titleless_title
  
  validates :title, presence: true
  validates :comment, presence: true
  validates :hotspring_id, presence: true
  
  belongs_to :user
  belongs_to :hotspring
  
  private
  
  def set_titleless_title
    self.title = "（無題）" if title.blank?
  end
end
