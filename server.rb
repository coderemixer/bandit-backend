require 'bundler'
Bundler.require

Dir[File.dirname(__FILE__) + '/routes/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/handlers/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/initializers/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/services/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |file| require file }
