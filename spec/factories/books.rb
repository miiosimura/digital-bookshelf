FactoryBot.define do
  factory :book do
    sequence(:title) { |x| "Livro #{x}" }
    description { 'Livro A' }
    image_url { 'https://cdn.pixabay.com/photo/2018/01/17/18/43/book-3088775_960_720.jpg' }
    author { 'John Doe' }
  end
end
