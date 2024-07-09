class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  #has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  #has_many :followers, through: :passive_relationships, source: :follower
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  #has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  #has_many :followings, through: :active_relationships, source: :followed

  
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

  def follow(user) #get_profile_imageの下にかく
    #active_relationships.create(followed_id: user.id)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    #active_relationships.find_by(followed_id: user.id).destroy
    relationships.find_by(followed_id: user.id).destroy
  end
  
  def following?(user) #ユーザーがフォローしているか判定
    followings.include?(user)
  end
end
