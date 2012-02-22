require 'rho/rhocontroller'
require 'helpers/browser_helper'

class UserFollowsController < Rho::RhoController
  include BrowserHelper
  
  
    
def following
  puts Rho::RhoConfig.username,"====== user following========"
  @user = User.find(:all).first
  my_following_url = "https://github.com/api/v2/json/user/show/" + Rho::RhoConfig.username + "/following"
  Rho::AsyncHttp.get(
       :url => my_following_url,
       :callback => (url_for :action => :my_following_callback),
       :callback_param => "" )
  render :action => :wait
end

def my_followers
  puts Rho::RhoConfig.username,"---------------------------"
  my_followers_url = "https://github.com/api/v2/json/user/show/" + Rho::RhoConfig.username + "/followers" 
  Rho::AsyncHttp.get(
       :url => my_followers_url,
       :callback => (url_for :action => :my_followers_callback),
       :callback_param => "" )
  render :action => :wait
end

def my_followers_callback
  if @params['status'] != 'ok'
           @@error_params = @params
            WebView.navigate ( url_for :action => :show_error )        
      else
            @@get_result = @params['body']['users']
            puts @@get_result.class,"----------class-----"
            WebView.navigate ( url_for :action => :show_followers_result )
   end
     
end
def my_following_callback
    
    if @params['status'] != 'ok'
          @@error_params = @params
          WebView.navigate ( url_for :action => :show_error )        
    else
          @@get_result = @params['body']['users']
          WebView.navigate ( url_for :action => :show_following_result )
    end
    
  end
def show_error
end
   
def show_followers_result
     
     render :action => :my_followers, :back => '/app/UserFollows'
end
   
   
def get_res
   @@get_result
end
 
 
def show_following_result
   render :action => :following , :back => '/app/UserFollows'
end
 
 
end
