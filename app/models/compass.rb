class Compass
  def self.get_image
    file_list = Dir.glob('app/assets/images/test_images/*.{png,jpg}')
    file_list[rand(file_list.size)].gsub('app/assets/images', 'assets')
  end
end
