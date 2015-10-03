require 'rmagick'

# Image Model
class Image
  def initialize(image_data)
    @image = Magick::Image.from_blob image_data
  end

  def finish
    @image[0].to_blob
  end
end
