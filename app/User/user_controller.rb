require 'rho/rhocontroller'
require 'helpers/browser_helper'

class UserController < Rho::RhoController
  include BrowserHelper

  
  def login
    if Rho::RhoConfig.username==""
    puts "USER NOT LOGGED IN"
      
            puts Rho::RhoConfig.username,"--------username ---------------"
                           if @params["msg"]
                             @msg = @params["msg"]
                           end   
    
    else
      puts "user already logged in"
      redirect "listing"
    end
   
           
     
  end
def create
  User.delete_all
  username =   @params['user']['username']
  user_search_url = "https://github.com/api/v2/json/user/show/" + username
  puts user_search_url,"++++++++________++++++++++"
  Rho::AsyncHttp.get(
       :url => user_search_url,
       :callback => (url_for :action => :get_user_info),
       :callback_param => "username=#{username}" )
  
  #user_details = Rho::AsyncHttp.get(:url => user_search_url, :callback => (url_for :get_user_info), :callback_param => "username=#{username}")
   render :action => :wait
  end

  def delete
    @user = User.find(@params['id'])
    @user.destroy if @user
    redirect :action => :index 
  end
  
 def listing
    @user = User.find(:all).first
 end
  
  def get_error
    @@error_params
    end
  
  def get_user_info
    if @params['status'] != 'ok'
       a=@params['body']
       puts a,"------------error--------------"
       @@error_params = @params['body']
      WebView.navigate (url_for :action => :login ,:query => { :msg => "User Not Found"}) 
     #WebView.navigate ( "/app/User/login?msg=usernotfound" ) 
  else
       Rho::RhoConfig.username=@params['username']
       puts Rho::RhoConfig.username,"-------super-----"
       @user =Rho::RhoConfig.username 
       puts @user,"_____user++++++++++///"
       #@@get_result = @params['body']
       
       #@@get=@@get_result["user"]
       #puts @@get.class,"====,,,,===="
       #@@set=@@get["public_repo_count"] 
       #puts @@set.class,"---...---set--..----" 
       WebView.navigate ( url_for :action => :show_listing  )
  end
  end
  
  def show_listing
   render :action => :listing
   end
  
  def logout
    Rho::RhoConfig.username=""
    redirect "login"
  end
end	
