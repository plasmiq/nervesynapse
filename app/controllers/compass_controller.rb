class CompassController < ApplicationController
  def index
  end

  def get_image
    new_image = Compass.get_image params
    render :text => {
      :src => new_image
    }.to_json
  end
end
