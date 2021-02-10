class BooksController < ApplicationController
  before_action :authenticate_admin!, only: %i[new create edit update destroy]

  def index
    @books = searcher(params[:search]) || Book.all
    @books = @books.order(title: params[:order].to_sym) if params[:order]
    @books = @books.page params[:page]
  end

  def show
    @book = Book.find_by(id: params[:id])

    return @book if @book.present?

    flash[:notice] = 'Livro não encontrado'
    redirect_to root_path
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
      flash[:alert] = 'Atenção: Todos os campos precisam ser preenchidos'
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
      flash[:alert] = 'Atenção: Todos os campos precisam ser preenchidos'
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])

    if @book.destroy
      flash[:notice] = 'Livro excluído com sucesso!'
      redirect_to books_path
    end
  end

  private
  def searcher(search)
    return unless search

    Book.where('LOWER(title) LIKE :search_term '\
               'OR LOWER(description) LIKE :search_term '\
               'OR LOWER(author) LIKE :search_term',
               search_term: "%#{search.downcase}%")
  end
end
