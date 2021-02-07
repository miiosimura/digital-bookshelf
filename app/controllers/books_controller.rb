class BooksController < ApplicationController
  before_action :authenticate_admin!, only: %i[new create edit update destroy]

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

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(params.require(:book).permit(:title, :author, :description, :image_url))
      flash[:notice] = 'Livro editado com sucesso!'
      redirect_to @book
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])

    if @book.destroy
      flash[:notice] = 'Livro excluído com sucesso!'
      redirect_to @book
    else
      render :edit
    end
  end
end
