class Compass
  def self.get_image(params)
    resonance_core = ResonanceCore
    resonance_core.get(
      :bind,
      :click_area => (params[:click_area] || nil),
      :clicked_at => Time.now.to_i
    )
  end
end
