env = ENV['RACK_ENV'] ? ENV['RACK_ENV'] : 'development'
DB = Sequel.connect(YAML.load_file('config/db.yml')[env])
DB.extension(:connection_validator)
DB.pool.connection_validation_timeout = 60
DB.extension(:pagination)
DB.loggers << Logger.new($stdout)

if YAML.load_file('config/db.yml')[env]['adapter'] == 'sqlite'
  DB.instance_variable_get('@pool').instance_variable_get('@available_connections').each{ |conn| conn.enable_load_extension(1)}
  DB.run 'SELECT load_extension("db/libsqlitefunctions.so")'
  DB.instance_variable_get('@pool').instance_variable_get('@available_connections').each{ |conn| conn.enable_load_extension(0)}
end
