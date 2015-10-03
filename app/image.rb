require 'rmagick'

# Image Model
class Image
  def initialize(image_data)
    @image = Magick::Image.from_blob(image_data).first
    @modified = false
  end

  def dimensions(settings)
    settings.store(:width, @image.columns) unless settings.key? :width
    settings.store(:height, @image.rows) unless settings.key? :height

    @image = @image.resize(settings[:width], settings[:height])
    @modified = true
  end

  def modified
    @modified
  end

  def finish
    @image.to_blob
  end
end
