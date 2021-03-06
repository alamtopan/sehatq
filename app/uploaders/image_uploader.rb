class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path("default.jpg")
  end

  version :normal do
    process :resize_to_fit => [500, 500]
  end

  version :small do
    process :resize_to_fit => [300, 300]
  end

  version :thumb do
    process :resize_to_fit => [170, 170]
  end

  def extension_white_list
    %w(jpg jpeg png gif)
  end
end
