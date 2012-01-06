class Compass
  def self.get_image(params, session)
    resonance_core = ResonanceCore
    resonance_core.get(
      :bind,
      :click_area => (params[:click_area] || nil),
      :clicked_at => Time.now.to_i,
      :user_session_id => session[:user_session_id]
    )
  end

  def self.highscore
    resonance_core = ResonanceCore
    resonance_core.get :highscore
  end
end
