class UsersController < ApplicationController

#* ++++++++++++++++++++++++ LOG IN +++++++++++++++++++++++++++++
get "/login" do
  erb :"/users/login.html"
end

post "/login" do
  # IF PARAMETERS ARE NOT BLANK & USER.NAME EXISTS IN DATABASE & PASSWORD MATCHES THROUGH AUTHENTICATION - "LOG IN" USER'S ID VIA SESSION
  if !params[:user][:name].blank? && !params[:user][:password].blank?
    user = User.find_by(:name => params[:user][:name])
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
            @user = user
      redirect to "/portal"
    else
      flash[:error] = "INVALID CREDENTIALS"
      redirect to "/login"
    end
  else
    flash[:error] = "BLANK FIELDS ARE INVALID"
    redirect to "/login"
  end
end
#* ++++++++++++++++++++++++ LOG IN +++++++++++++++++++++++++++++

#! ++++++++++++++++++++++++ LOG OUT +++++++++++++++++++++++++++++
get "/logout" do
  session.clear
  redirect to "/"
end
#! ++++++++++++++++++++++++ LOG OUT +++++++++++++++++++++++++++++

#* ++++++++++++++++++++++++ SIGN UP +++++++++++++++++++++++++++++
get "/signup" do
  erb :"/users/signup.html"
end

post "/signup" do
  # IF PARAMETERS ARE NOT BLANK & USER.NAME DOES NOT ALREADY EXIST - CREATE NEW USER
  if !params[:user][:name].blank? && !params[:user][:password].blank?
      user = User.find_by(:name => params[:user][:name])
      if !user
        new_user = User.create(params[:user])            
        session[:user_id] = new_user.id          
          @user = new_user
        redirect to "/portal"
      else
        flash[:error] = "SIGN-UP ERROR : INVALID USERNAME"
        redirect to "/signup"
      end
  else
      flash[:error] = "BLANK FIELDS ARE INVALID"
      redirect to "/signup"
  end    
end
#* ++++++++++++++++++++++++ SIGN UP +++++++++++++++++++++++++++++

#* ++++++++++++++++ USER WELCOME DIRECTORY +++++++++++++++++++++
get "/portal" do  
  if @user = current_user
    erb :"/portal"
  else
    redirect to "/"
  end
end
#* ++++++++++++++++ USER WELCOME DIRECTORY +++++++++++++++++++++

  #  # GET: /users/new
  # get "/users/new" do
  #   erb :"/users/new.html"
  # end

  # # POST: /users
  # post "/users" do
  #   redirect "/users"
  # end

  # # GET: /users/5
  # get "/users/:id" do
  #   erb :"/users/show.html"
  # end

  # USER SHOW PAGE
  # GET: /users/5
  get "/users/:id" do
    if logged_in?
      @user = current_user
      if @user.id == params[:id].to_i
            erb :"/users/show.html"
      else
            "user data mismatch"
            # redirect to "/portal"
      end
    else
          "not logged in"
          # redirect to "/"
    end
  end

  # USER EDIT PAGE
  # GET: /users/5/edit
  get "/users/:id/edit" do
      if logged_in?
        @user = current_user
        erb :"/users/edit.html"
      else
        "cannot edit user - not logged in"
        redirect to "/"
      end    
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
