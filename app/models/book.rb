class Book < ApplicationRecord
  validates :title, :description, :image_url, :author, presence: true
end
