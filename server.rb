require 'bundler'
Bundler.require
require 'logger'

Dir[File.dirname(__FILE__) + '/routes/*.rb'].each { |file| require file }
require './handlers/runtime_error'
Dir[File.dirname(__FILE__) + '/handlers/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/initializers/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/services/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |file| require file }
