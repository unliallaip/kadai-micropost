class Micropost < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  validates :content, presence: true, length: { maximum: 255 }
  
  #　7/4　追加
  has_many :favorites
  has_many :favoriting_users, through: :favorites, source: :user
  
  # ここからFavforite
  #def favorite(other_user)
  #  unless self == other_user
  #    self.micropost.find_or_create_by(favorite_id: other_user.id)
  #  end
  #end
  
  #def unfavorite(other_user)
  #  micropost = self.favorites.find_by(favorite_id: other_user.id)
  #  micropost.destroy.if favorite
  #end  
  
  #def favorite?(other_user)
  #  self.favorites.include?(other_user)
  #end
end
