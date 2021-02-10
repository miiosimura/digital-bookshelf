class Book < ApplicationRecord
  validates :title, :description, :image_url, :author, presence: true

  after_save :verify_image_url

  def verify_image_url
    return if (File.extname(image_url) =~ /^(.png|.gif|.jpg)$/) || (image_url =~ /^#{URI::DEFAULT_PARSER.make_regexp}$/)

    update(image_url: 'no-image.png')
  end
end
