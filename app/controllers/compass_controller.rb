class CompassController < ApplicationController
  def index
    session[:user_session_id] = Digest::MD5::hexdigest "#{Time.now.to_s}#{rand}"
  end

  def ran_out_of_time
  end

  def get_image
    new_image = Compass.get_image params, session
    render :text => {
      :src => new_image
    }.to_json
  end
end
