require 'rho/rhocontroller'
require 'helpers/browser_helper'

class UserController < Rho::RhoController
  include BrowserHelper
  RedirectServiceURL = "http://redirectme.to"
  
  def login
      puts "======login page============="
      if Rho::RhoConfig.username==""
      puts "USER NOT LOGGED IN"
        
              puts Rho::RhoConfig.username,"--------username ---------------"
                            
      else
        puts "user already logged in"
        redirect "listing"
     
      end
    end
   
 def self.getRedirectURL(local_call_back_url)
      callback_url = RedirectServiceURL + "/" + '127.0.0.1:' + System.get_property('rhodes_port').to_s + local_call_back_url
      puts callback_url,"----call-------------"
      return callback_url
 end
    
 def self.getGHAuthURL(local_call_back_url)
      
      call_back_url = getRedirectURL(local_call_back_url)
      url ="https://github.com/login/oauth/authorize?client_id=xxxxxxx&redirect_uri=#{call_back_url}&scope=user,public_repo,repo,gist"
                
      puts url ,"-----////////////////////url/////////////"
      return url
 end

 def github_login
    
     local_callback_url =url_for( :action => :github_callback )
     url = UserController.getGHAuthURL(local_callback_url)
     puts url,"------url--......----------------" 
     WebView.navigate(url)
 end
 
  def github_callback
    code=@params["code"]
   
    puts "--------------------------------------lll===================="
    
    @@token=Rho::AsyncHttp.post(
                    :url => "https://github.com/login/oauth/access_token?client_id=xxxx&client_secret=xxxxx&code=" + code
                      
                             )
    puts @@token["body"],"=============token==============="
    user_info = "https://github.com/api/v2/json/user/show?" + @@token["body"]
    puts user_info,"============="
    user=Rho::AsyncHttp.get(
             :url => user_info,
              )              
    puts user,"=======================user response=============="
    user_initial=user["body"]["user"]
    Rho::RhoConfig.username=user_initial["login"] 
    puts  Rho::RhoConfig.username,"----username--------------"
    Rho::RhoConfig.token=@@token["body"] 
    puts Rho::RhoConfig.token,"=========rho token========="
    WebView.navigate( url_for :action => :listing )
  end
   def listing
       puts  Rho::RhoConfig.username,"= ======listing username========"
       puts "-------listing-----------"
   end
   def coderwall
     @username =Rho::RhoConfig.username
    
    
         auth_url =  "http://coderwall.com/#{@username}.json"  
         result = Rho::AsyncHttp.get(:url => auth_url)  
      puts result,"=========result========="
      @response = result["body"]
      puts @response,"=======response======="
       if @response == " "
      Alert.show_popup("you have no account in coderwall....")
      
       else
         @badges = @response["badges"]  
         render :action => :coderwall
       end
     
     
   end
  
       
    def logout
      Rho::RhoConfig.username=""
      #Rho::RhoConfig.token=""
      redirect "login"
    end
end 
