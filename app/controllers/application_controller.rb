require_relative "../../config/environment"
require_relative "../models/tweet.rb"
require_relative "../models/user.rb"

class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    set :public, "public"
    enable :sessions
    set :session_secret, "fweet_fweet"
  end
  
  get "/" do
    erb :landing
  end
  
  get "/results" do
    erb :results
  end 
  
#   LOGIN
  post '/results' do
    @username =params[:username]
    @pwd1 =params[:pwd1]
      if User.find_by(:username => params[:username])
         #IF USER EXISTS, GET USER WITH @USERNAME
          @user = User.find_by(:username => params[:username])
        if @user.password == @pwd1
          puts "correct password"
          @tweets = Tweet.all
          puts "Logged in"
          session[:user_id] = @user.id
          session[:username] = @user.username
          erb :results
        else 
          redirect "/"
        end 
      else  
        #IF USER DOESN'T EXIST, RELOAD PAGE
        puts User.exists?(username: @username)
        puts "Username does not exist"
        erb :landing
      end
  end
  
#   SIGN UP
  post '/signup' do
    @username = params[:username]
    @pwd1 = params[:pwd1]
    @pwd2 =params[:pwd2]
    
#     CHECK PASS AND CONFIRM PASS
    if @pwd1 == @pwd2
#       CHECK IF USERNAME EXISTS
        if User.find_by(:username => params[:username])
          puts User.exists?(username: @username)
          puts "Username is already taken"
          erb :landing
        else  
            @user = User.new({:username => params[:username], :password => params[:pwd1], :email => params[:email]})
            @user.save
            @tweets = Tweet.all
            puts "You've created an account"
            session[:user_id] = @user.id
            session[:username] = @user.username
            erb :results
        end
    else
      erb :landing
    end
  end
  
#   LOGOUT
    get "/logout" do
       session[:user_id] = nil
       session[:username] = nil
       redirect "/"
  end
  
#  TWEET
  post '/tweet' do 
    @content = params[:content]
    @user = User.find_by(:username => session[:username])
    tweet = Tweet.new({:user_id => params[:user_id], :content => params[:content]})
    tweet.save
    @tweets = Tweet.all
    erb :results
  end
  
end