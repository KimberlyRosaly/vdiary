require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    # ▲ STATIC FILES directory
    set :views, 'app/views'
    # ▲ VIEW TEMPLATES directory
    enable :sessions
    # ▲ insert RACK::SESSION::COOKIE component - ENABLE COOKIE BASED SESSION
    set :session_secret, "secret"
    # ▲ KEY used for ENCRYPTING COOKIEES to maintain session state- MUST be strong
    register Sinatra::Flash
    # ▲ enable FLASH MESSAGES - flash{hash}
  end

  get "/" do
    erb :welcome
  end

end
