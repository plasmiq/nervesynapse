class Compass
  def self.get_entry_point(session)
    resonance_core = ResonanceCore
    resonance_core.get(
      :get_entry_point,
      :user_session_id => session[:user_session_id]
    )
  end

  def self.get_image(params, session)
    resonance_core = ResonanceCore
    resonance_core.get(
      :bind,
      :click_area => (params[:click_area] || nil),
      :user_session_id => session[:user_session_id],
      :clicked_at => Time.now
    )
  end

  def self.highscore(session)
    resonance_core = ResonanceCore
    resonance_core.get(
      :highscore,
      :user_session_id => session[:user_session_id]
    )
  end
end
