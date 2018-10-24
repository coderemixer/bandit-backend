env = ENV['RACK_ENV'] ? ENV['RACK_ENV'] : 'development'
DB = Sequel.connect(YAML.load_file('config/db.yml')[env])
DB.extension(:connection_validator)
DB.pool.connection_validation_timeout = 60
