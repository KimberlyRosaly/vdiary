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

  # GET: /users
  get "/users" do
    erb :"/users/index.html"
  end

  # GET: /users/new
  get "/users/new" do
    erb :"/users/new.html"
  end

  # POST: /users
  post "/users" do
    redirect "/users"
  end

  # GET: /users/5
  get "/users/:id" do
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit.html"
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
