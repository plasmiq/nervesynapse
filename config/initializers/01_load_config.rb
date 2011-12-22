def load_config(file)
  data = YAML.load(File.read(File.join(Rails.root, "config", file+".yml")))
  data[Rails.env]
end

APP_CONFIG = load_config("application")
