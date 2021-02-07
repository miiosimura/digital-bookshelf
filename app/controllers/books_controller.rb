class BooksController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create]

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(params.require(:book).permit(:title, :author, :description, :image_url))

    if @book.save
      flash[:notice] = 'Novo livro cadastrado com sucesso!'
      redirect_to @book
    else
      render :new
    end
  end
end