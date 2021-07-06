class FavoritesController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: book.id)
    favorite.save!
    @books = Book.all.sort { |a,b| b.a_week_favorited_count <=> a.a_week_favorited_count }
  end

  def destroy
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: book.id)
    favorite.destroy
    @books = Book.all.sort { |a,b| b.a_week_favorited_count <=> a.a_week_favorited_count }
  end

end
