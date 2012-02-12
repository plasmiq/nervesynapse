class Compass
  def self.get_entry_point(session, options = {})
    resonance_core = ResonanceCore
    substrate_id = options[:substrate_id] || nil
    weave_id = options[:weave_id] || nil
    resonance_core.get(
      :get_entry_point,
      :substrate_id => substrate_id,
      :weave_id => weave_id,
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
