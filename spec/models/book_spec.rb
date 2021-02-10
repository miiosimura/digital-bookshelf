require 'rails_helper'

RSpec.describe Book, type: :model do
  describe '#verify_image_url' do
    context 'when url is valid' do
      it 'returns the url itself' do
        book = create(:book, image_url: 'https://cdn.pixabay.com/photo/2018/01/17/18/43/book-3088775_960_720.jpg')
        expect(book.image_url).to eq('https://cdn.pixabay.com/photo/2018/01/17/18/43/book-3088775_960_720.jpg')
      end
    end

    context 'when url is not valid' do
      it 'returns the image without a photo' do
        book = create(:book, image_url: 'url')
        expect(book.image_url).to eq('no-image.png')
      end
    end
  end
end