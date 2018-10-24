env = ENV['RACK_ENV'] ? ENV['RACK_ENV'] : 'development'
REDIS_URL = YAML.load_file('config/redis.yml')[env]
Ohm.redis = Redic.new(REDIS_URL)
