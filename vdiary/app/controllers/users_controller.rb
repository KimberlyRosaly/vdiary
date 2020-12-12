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
    if logged_in?
      @user = current_user
      if @user.id == params[:id].to_i
        @user.update(params[:user])
        redirect to "/users/#{@user.id}"
      else
        flash[:error] = "users don't match"
      end
    else
      flash[:error] = "not logged in"
    end
  end

  # DESTROY ACCOUNT
  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    if logged_in?
      @user = current_user  
      if @user.id == params[:id].to_i
        @user.destroy
      else
            "user data does not match"
          end
          redirect to "/"
    else
      "you're not logged in"
    end
  end

  #? ++++++++++++++++++++++++ CHANGE PASSWORD +++++++++++++++++++++++++++++
  get "/users/:id/change-password" do
    @user = User.find(params[:id])
    if logged_in? && current_user.id == @user.id
      erb :"/users/change_password.html"
    else
      flash[:error] = "Not logged in / user mismatch"
      redirect to "/"
    end
  end

  patch "/users/:id/password" do
    @user = User.find(params[:id])
    if logged_in? && current_user.id == @user.id
      # if all 3 password fields are not blank
      if !params[:current_password].blank? && !params[:new_password].blank? && !params[:new_password_confirmation].blank? && @user.authenticate(params[:current_password]) && params[:new_password] == params[:new_password_confirmation]
        #check to see if CP is correct          
        #check to see if NP & NPC are identical
        #patch through the new password
        @user.update(:password => params[:new_password])
        #save the user
        @user.save
        #USER FEEDBACK - for success
        flash[:error] = "USER PASSWORD CHANGED SUCCESSFULLY"
        redirect to "/users/#{@user.id}"

      #if any inputs are blank
      elsif params[:current_password].blank? || params[:new_password].blank? || params[:new_password_confirmation].blank?
        #error CANNOT BE BLANK
        flash[:error] = "PASSWORD FIELDS CANNOT BE BLANK"
        redirect to "/users/#{@user.id}/change-password"

      #if CP is incorrect
      elsif !@user.authenticate(params[:current_password])
        #error WRONG CP
        flash[:error] = "CURRENT PASSWORD INVALID"
        redirect to "/users/#{@user.id}/change-password"

      #if NP & NPC aren't identical
      elsif params[:new_password] != params[:new_password_confirmation]
        #error NEW PASSWORD MISMATCH
        flash[:error] = "NEW PASSWORD MISMATCH"
        redirect to "/users/#{@user.id}/change-password"
      end
    else
      flash[:error] = "Error patching account password - not logged in / user mismatch"
      redirect to "/"
    end
  end
#? ++++++++++++++++++++++++ CHANGE PASSWORD +++++++++++++++++++++++++++++

  # REPLACED WITH SIGN UP
  #  # GET: /users/new
  # get "/users/new" do
  #   erb :"/users/new.html"
  # end

  # # POST: /users
  # post "/users" do
  #   redirect "/users"
  # end
  
end # CONTROLLERend
