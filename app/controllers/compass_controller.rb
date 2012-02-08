class CompassController < ApplicationController
  def index
    session[:user_session_id] = Digest::MD5::hexdigest "#{Time.now.to_s}#{rand}"
  end

  def ran_out_of_time
  end

  def finish
    @compass = Compass.highscore(session)
  end

  def get_entry_point
    response = Compass.get_entry_point session
    render :text => {
      :src => response['url']
    }.to_json
  end

  def get_image
    response = Compass.get_image params, session
    render :text => {
      :src => response['url']
    }.to_json
  end
end
