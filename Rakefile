require 'yaml'

namespace :run do
  task :dev do
    sh 'rackup'
  end

  task :daemon do
  end

  task :stop do
  end

  task :restart do
  end
end

namespace :db do
  require 'bundler'
  Bundler.require
  Sequel.extension :migration
  require './initializers/sequel'

  task :version do
    version = if DB.tables.include?(:schema_info)
      DB[:schema_info].first[:version]
    end || 0

    puts "Schema Version: #{version}"
  end

  task :migrate do
    Sequel::Migrator.run(DB, 'migrations')
    Rake::Task['db:version'].execute
  end

  task :rollback do
    args.with_defaults(:target => 0)

    Sequel::Migrator.run(DB, 'migrations', :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  task :reset do
    Sequel::Migrator.run(DB, 'migrations', :target => 0)
    Sequel::Migrator.run(DB, 'migrations')
    Rake::Task['db:version'].execute
  end

  task :seed do
    require './server'
    require './db/seed'
  end
end
