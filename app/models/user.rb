class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships,  source: :follower
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :active_user_chats, class_name: 'UserChat', foreign_key: 'send_user_id', dependent: :destroy
  has_many :send_users, through: :active_user_chats, source: :send_user
  has_many :passive_user_chats, class_name: 'UserChat', foreign_key: 'receive_user_id', dependent: :destroy
  has_many :receive_users, through: :passive_user_chats, source: :receive_user

  attachment :profile_image, destroy: false

  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50 }

  # 追加メソッド

  #ユーザをフォローする
  def follow(other_user)
    following << other_user
  end

  #ユーザをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  #現在のユーザがフォローしていたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  #relationShipIdを返す
  def follow_id(other_user)
    active_relationships.find_by(folowed_id: other_user.id).id
  end

  #nameで検索したレコードを返す
  def self.search(search_method,word)
    if search_method == '完全一致'
      @contents = User.where("name=?","#{word}")
    elsif search_method == '前方一致'
      @contents = User.where("name LIKE?","#{word}%")
    elsif search_method == '後方一致'
      @contents = User.where("name LIKE?","%#{word}")
    else
      @contents = User.where("name LIKE?","%#{word}%")
    end
  end

  #グループのオーナーであればtrueを返す
  def owned?(group)
    self.id == group.owner_id
  end

  #グループに所属する
  def join(group)
    groups << group
  end

  #グループから抜ける
  def leave_group(group)
    group_users.find_by(group_id: group.id).destroy
  end

  #ユーザがグループに所属していたらtrueを返す
  def joined?(group)
    groups.include?(group)
  end

  #ユーザと他のユーザとのチャット履歴を返す
  def chat_index(other_user)
    chat_index = UserChat.where(send_user_id: self.id, receive_user_id: other_user.id).or(UserChat.where(send_user_id: other_user.id, receive_user_id: self.id))
    chat_index.sort { |a,b| a.id <=> b.id}
  end

end
