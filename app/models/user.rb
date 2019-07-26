class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  # ここからFavorite
  has_many :favorites
  has_many :fav_microposts, through: :favorites, source: :micropost
  # has_many :reverses_of_favorite, class_name: 'Favorite', foreign_key: 'favorite_id'
  # has_many :favoriters, through: :reverses_of_favorite, source: :user
  # ここまで
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  # ここからFavforite
  #def favorite(other_user)
  #  unless self == other_user
  #    self.micropost.find_or_create_by(micropost_id: other_user.id)
  #  end
  #end
  
  #def unfavorite(other_user)
  #  micropost = self.favorites.find_by(favorite_id: other_user.id)
  #  micropost.destroy.if favorite
  #end  
  
  #def favorite?(other_user)
  #  self.favorites.include?(other_user)
  #end
  
  def favorite(micropost)
    favorites.find_or_create_by(micropost_id: micropost.id)
  end
  
  def unfavorite(micropost)
    favorite = favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  # ここまで
end