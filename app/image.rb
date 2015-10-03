require 'rmagick'

# Image Model
class Image
  def initialize(image_data)
    @image = Magick::Image.from_blob(image_data).first
    @modified = false
  end

  def dimensions(settings)
    if (settings.key? :maintain_aspect) && (settings[:maintain_aspect] == true)
      if settings.key? :width
        multiplier = @image.rows.to_f / @image.columns.to_f
        settings.store(:height, settings[:width] * multiplier)
      elsif settings.key? :height
        multiplier = @image.columns.to_f / @image.rows.to_f
        settings.store(:width, settings[:height] * multiplier)
      end
    end

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
