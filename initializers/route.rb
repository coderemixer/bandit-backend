class Route < Sinatra::Base
  set :show_exceptions, :after_handler
  register Sinatra::Namespace
  use Rack::Cors do
    allow do
      origins '*'
      resource '/*',
               :methods => [:get, :post, :delete, :put, :patch, :options, :head],
               :headers => :any,
               :expose  => ['Token'],
               :max_age => 600
    end
  end

  namespace '/', &ROOT_ROUTE

  # [
  #   401,
  #   {
  #     exception: error.class,
  #     message: error.message,
  #     backtrace: error.backtrace,
  #   }.to_json
  # ]

  error 500, proc do |error|
    [
      500,
      {
        exception: error.class,
        message: error.message,
        backtrace: error.backtrace,
      }.to_json
    ]
  end

  error BaseError, proc do |error|
    error.rack
  end
end
