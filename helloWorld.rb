require 'sinatra'
require 'haml' # template engine
require 'json'

# control part of MVC
# an HTTP method paired with a URL-matching pattern
get '/' do
  # page variable
  @version = RUBY_VERSION
  @os = RUBY_PLATFORM
  @env = {}
  ENV.each do |key, value|
    begin
      hash = JSON.parse(value)
      @env[key] = hash
    rescue
      @env[key] = value
    end
  end
  
  #There are many useful environment variables available in process.env,
  #please refer to the following document for detailed description:
  #http://docs.cloudfoundry.com/docs/using/deploying-apps/environment-variable.html
  
  #VCAP_APPLICATION contains useful information about a deployed application.
  appInfo = @env["VCAP_APPLICATION"]

  #VCAP_SERVICES contains all the credentials of services bound to
  #this application. For details of its content, please refer to
  #the document or sample of each service.
  services = @env["VCAP_SERVICES"]
  #TODO: Get service credentials and communicate with bluemix services.

  # render template
  haml :hi
end

post '/get_price' do
  request.body.rewind
  data = JSON.parse(request.body.read)

  content_type :json
  
  data.collect do  |item| 
  	{
  		name: item['name'], 
  		description: item['description'], 
  		quantity: item['quantity'], 
  		price: rand(100..100000) * item['quantity']
  	}
  end.to_json
end
