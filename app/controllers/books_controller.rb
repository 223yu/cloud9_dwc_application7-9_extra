class BooksController < ApplicationController

  def show
    @newbook = Book.new
    @book = Book.find(params[:id])
    @book.pvcount_up
    @comment = BookComment.new
  end

  def index
    @books = Book.all #.sort { |a,b| b.a_week_favorited_count <=> a.a_week_favorited_count } 課題8dのためにいいね順をストップ
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @book.pvcount = 0
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    redirect_to books_path unless @book.user == current_user
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def post_count
    user = User.find(params[:user_id])
    date = params[:date].to_date
    @post_count = user.post_count_date(date)
  end

  def sort_new_arrival
    if category = params[:category]
      @books = Book.where(category: category).sort { |a,b| a.id <=> b.id }
    else
      @books = Book.all.sort { |a,b| a.id <=> b.id }
    end
  end

  def sort_evaluation
    if category = params[:category]
      @books = Book.where(category: category).sort { |a,b| b.rate.to_i <=> a.rate.to_i }
    else
      @books = Book.all.sort { |a,b| b.rate.to_i <=> a.rate.to_i }
    end
  end

  def category_search
    @category = params[:category]
    @books = Book.where(category: @category)
    @book = Book.new
  end

  private

    def book_params
      params.require(:book).permit(:title, :body, :rate, :category)
    end

end
