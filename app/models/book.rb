class Book < ApplicationRecord
	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :favorited_users, through: :favorites, source: :user
	has_many :book_comments, dependent: :destroy

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	#追加メソッド

	#いいねしているかどうかを調べる
	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	#1週間以内にいいねされた数を返す
	def a_week_favorited_count
		self.favorites.where(:updated_at => 1.week.ago..Time.now).length
	end

	#titleで検索したレコードを返す
	def self.search(search_method,word)
    if search_method == '完全一致'
      @contents = Book.where("title=?","#{word}")
    elsif search_method == '前方一致'
      @contents = Book.where("title LIKE?","#{word}%")
    elsif search_method == '後方一致'
      @contents = Book.where("title LIKE?","%#{word}")
    else
      @contents = Book.where("title LIKE?","%#{word}%")
    end
  end

  #閲覧数を一つ増やす
  def pvcount_up
  	pvcount = self.pvcount
  	pvcount += 1
  	self.update_attribute(:pvcount, pvcount)
  end

end
