require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let!(:book) { create(:book) }
  let!(:other_book) { create(:book, title: 'Livro B') }
  let(:admin) { create(:admin) }

  describe '#index' do
    context 'when doesnt have search or order params' do
      before { get :index }
      subject { response }

      it { is_expected.to have_http_status(:success) }
      it 'shows all the books' do
        expect(response.body).to have_content(book.title)
        expect(response.body).to have_content(other_book.title)
      end
    end

    context 'when have search params' do
      before { get :index, params: { search: book.title } }
      subject { response }

      it { is_expected.to have_http_status(:success) }
      it 'shows a specific book' do
        expect(response.body).to have_content(book.title)
        expect(response.body).to_not have_content(other_book.title)
      end
    end

    context 'when have order params' do
      context 'and the value is asc' do
        before { get :index, params: { order: 'asc' } }
        subject { response }

        it { is_expected.to have_http_status(:success) }
        it 'shows the books in ascending order' do
          expect(assigns(:books).to_a).to eq([book, other_book])
        end
      end

      context 'and the value is desc' do
        before { get :index, params: { order: 'desc' } }
        subject { response }

        it { is_expected.to have_http_status(:success) }
        it 'shows the books in descending order' do
          expect(assigns(:books).to_a).to eq([other_book, book])
        end
      end
    end
  end

  describe '#show' do
    context 'when a book is found' do
      before { get :show, params: { id: book.id } }
      subject { response }

      it { is_expected.to have_http_status(:success) }
      it 'shows the book details' do
        expect(response.body).to have_content(book.title)
        expect(response.body).to have_content(book.description)
        expect(response.body).to have_content(book.author)
      end
    end

    context 'when a book is not found' do
      before { get :show, params: { id: 123 } }
      subject { response }

      it { is_expected.to have_http_status(:found) }
      it 'shows a alert message' do
        is_expected.to redirect_to(root_path)
        expect(flash[:notice]).to match('Livro não encontrado')
      end
    end
  end

  describe '#new' do
    context 'when an admin is logged in' do
      setup { sign_in admin }
      before { get :new }
      subject { response }

      it { is_expected.to have_http_status(:ok) }
      it 'renders the new book form' do
        expect(response.body).to have_content('Cadastrar livro')
      end
    end

    context 'when the user is not an admin' do
      before { get :new }
      subject { response }

      it { is_expected.to have_http_status(:found) }
      it 'redirects to sign in page' do
        is_expected.to redirect_to(new_admin_session_path)
      end
    end
  end

  describe '#create' do
    context 'when a book is successfully created' do
      setup { sign_in admin }
      before do
        post :create,
             params: {
               book: {
                 title: 'Livro X',
                 author: 'Mary Anne',
                 description: 'Livro X',
                 image_url: 'https://cdn.pixabay.com/photo/2018/01/17/18/43/book-3088775_960_720.jpg'
               }
             }
      end
      subject { response }

      it { is_expected.to have_http_status(:found) }
      it 'redirects to book details page' do
        is_expected.to redirect_to(book_path(id: Book.last.id))
      end
    end

    context 'when a user is not an admin' do
      before do
        post :create,
             params: {
               book: {
                 title: 'Livro X',
                 author: 'Mary Anne',
                 description: 'Livro X',
                 image_url: 'https://cdn.pixabay.com/photo/2018/01/17/18/43/book-3088775_960_720.jpg'
               }
             }
      end
      subject { response }

      it { is_expected.to have_http_status(:found) }
      it 'redirects to sign in page' do
        is_expected.to redirect_to(new_admin_session_path)
      end
    end
  end

  describe '#edit' do
    context 'when an admin is logged in' do
      setup { sign_in admin }
      before { get :edit, params: { id: book.id } }
      subject { response }

      it { is_expected.to have_http_status(:ok) }
      it 'renders the edit book form' do
        expect(response.body).to have_content('Editar livro')
      end
    end

    context 'when the user is not an admin' do
      before { get :edit, params: { id: book.id } }
      subject { response }

      it { is_expected.to have_http_status(:found) }
      it 'redirects to sign in page' do
        is_expected.to redirect_to(new_admin_session_path)
      end
    end
  end

  describe '#update' do
    context 'when a book is successfully updated' do
      setup { sign_in admin }
      before do
        put :update,
            params: {
              id: book.id,
              book: {
                author: 'Eren Jaeger',
              }
            }
      end
      subject { response }

      it { is_expected.to have_http_status(:found) }
      it 'redirects to book details page' do
        is_expected.to redirect_to(book_path(id: book.id))
      end
      it 'updates the book`s author' do
        expect(book.reload.author).to eq('Eren Jaeger')
      end
    end

    context 'when a user is not an admin' do
      before do
        put :update,
            params: {
              id: book.id,
              book: {
                author: 'Eren Jaeger',
              }
            }
      end
      subject { response }

      it { is_expected.to have_http_status(:found) }
      it 'redirects to sign in page' do
        is_expected.to redirect_to(new_admin_session_path)
      end
    end
  end

  describe '#destroy' do
    context 'when a book is successfully deleted' do
      setup { sign_in admin }
      before { delete :destroy, params: { id: book.id } }
      subject { response }

      it { is_expected.to have_http_status(:found) }
      it 'redirects to book details page' do
        is_expected.to redirect_to(books_path)
      end
      it 'deletes the book from the db' do
        expect(Book.find_by(id: book.id)).to be_nil
      end
    end
  end
end