class Compass
  def self.get_image
    #file_list = Dir.glob('app/assets/images/test_images/*.{png,jpg}')
    #file_list[rand(file_list.size)].gsub('app/assets/images', 'assets')
    #"http://beta.metabrane.co#{Net::HTTP.get 'beta.metabrane.co', '/resonance_core/bind'}"
    ResonanceCore.new.get(:bind)
  end
end
