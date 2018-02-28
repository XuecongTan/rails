class BooksController < ApplicationController
  def new
    if (!logged_in?)
      flash[:danger] = "Please login or signup to access this feature"
      redirect_to root_path
    end
    @book = Book.new
  end
  
  def edit
    @book = Book.find(params[:id])
    if !logged_in? || @book.user != current_user
      flash[:danger] = "Sorry, you are not allowed this opearation"
      redirect_to books_path
    end
  end
  
  def create
    @book = Book.new(book_params());
    @book.user = current_user
    
    if (@book.save)    # If validations are successfull
      flash[:success] = "Book was successfully added"
      redirect_to book_path(@book) ## @book is passed in because book_path (show fn) needs the id (can see in rake routes)
    else
      render 'new'
    end
  end
  
  def update
    @book = Book.find(params[:id])
    if (@book.update(book_params()))
      flash[:notice] = "Book information was successfully updated"
      redirect_to book_path(@book)
    else
      render 'edit'
    end
  end
  
  def index
    @book = Book.all
    
  end
  
  def show
    @book = Book.find(params[:id])
  end
  
  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    flash[:notice] = "Book was successfully removed"
    redirect_to books_path
  end
  
  
  private
    def book_params()
      params.require(:book).permit(:name, :ISBN, :author)
    end
  
end