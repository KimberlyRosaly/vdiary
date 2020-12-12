require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    # ▲ STATIC FILES directory
    set :views, 'app/views'
    # ▲ VIEW TEMPLATES directory
    enable :sessions
    # ▲ insert RACK::SESSION::COOKIE component - ENABLE COOKIE BASED SESSION
    set :session_secret, ENV['SECRET']
    # ▲ KEY used for ENCRYPTING COOKIEES to maintain session state- MUST be strong
    register Sinatra::Flash
    # ▲ enable FLASH MESSAGES - flash{hash}
  end

  helpers do
    def current_user
        current_user ||= User.find_by(id: session[:user_id])
        #if CURRENT_USER does not already exist - CURRENT_USER = USER FOUND BY MATCHING ID's
    end

    def logged_in?
        current_user != nil
    end

    def is_authorized?
      #? check the session hash for a current user id - compare it with the entry's assigned id
      @user = current_user
      @entry = Entry.find(params[:id].to_i)
          if @entry.user == @user
            true
          else
            false
          end
    end     
  end # -----HELPERSend

# ==================================================================ROUTES==

  get "/" do
    erb :welcome
  end

# ================================================================ROUTESend==

end
