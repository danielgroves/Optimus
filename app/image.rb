require 'rmagick'

# Image Model
class Image
  attr_reader :modified

  def initialize(image_data)
    @image = Magick::Image.from_blob(image_data).first
  end

  def dimensions(settings)
    if (settings.key? :maintain_aspect) && (settings[:maintain_aspect] == true)
      settings.store(:height, calculate_aspect(@image.rows, @image.columns, settings[:width])) if settings.key? :width

      settings.store(:width, calculate_aspect(@image.columns, @image.rows, settings[:height])) if settings.key? :height
    end

    settings.store(:width, @image.columns) unless settings.key? :width
    settings.store(:height, @image.rows) unless settings.key? :height

    @image = @image.resize(settings[:width], settings[:height])
  end

  def finish
    @image.to_blob
  end

  def width
    @image.columns
  end

  def height
    @image.rows
  end

  private

  def calculate_aspect(original_primary, original_secondary, new_primary)
    new_primary * (original_primary.to_f / original_secondary.to_f)
  end
end
