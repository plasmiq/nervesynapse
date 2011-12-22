class ResonanceCore < ActiveResource::Base
  self.site = APP_CONFIG['metabrane_url']
  self.collection_name = 'resonance_core'
  self.user = 'metabrane'
  self.password = 'gen001'
end
