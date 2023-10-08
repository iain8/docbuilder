require 'pathname'
require 'sinatra/base'
require_relative '../validate'

# Start dev server command
module Commands
  def serve(options)
    server = Sinatra.new do
      set :public_folder, Pathname.new("#{Dir.pwd}/public")

      get('/') do
        json = load_and_validate_history(options.data)

        json[:server] = true

        erb :index, locals: json
      end
    end

    server.run!
  end
end
