class FavoritesController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: book.id)
    favorite.save!
    @books_all = Book.all.sort { |a,b| b.a_week_favorited_count <=> a.a_week_favorited_count }
    # ユーザ詳細画面用
    user = Book.find(params[:book_id]).user
    @books_user = user.books.sort { |a,b| b.a_week_favorited_count <=> a.a_week_favorited_count }
    # 課題8dのためにいいね順で並び替えをストップ
    redirect_to request.referrer || root_url
  end

  def destroy
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: book.id)
    favorite.destroy
    @books_all = Book.all.sort { |a,b| b.a_week_favorited_count <=> a.a_week_favorited_count }
    # ユーザ詳細画面用
    user = Book.find(params[:book_id]).user
    @books_user = user.books.sort { |a,b| b.a_week_favorited_count <=> a.a_week_favorited_count }
    # 課題8dのためにいいね順で並び替えをストップ
    redirect_to request.referrer || root_url
  end

end
