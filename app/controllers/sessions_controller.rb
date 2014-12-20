class SessionsController < ApplicationController
  layout false
  require 'google-api-client'
 
	def new
	end

	def create
		@auth = request.env['omniauth.auth']['credentials']
		@auth_id = request.env['omniauth.auth']['info']['email']
		redirect_to '/create'
	end

	def event
		@auth = request.env['omniauth.auth']['credentials']
	end

	def post_event
	  	@auth = request.env['omniauth.auth']['credentials']
	  	@auth_id = request.env['omniauth.auth']['info']['email']
	  	@event = Event.new(params[:event])
	    respond_to do |format|
		    if @event.save  
		       	user = @auth
		        event = {
	                'summary' => @event.summary,
	                'location' => @event.location,
	                'start' => {
	                'dateTime' => Chronic.parse(@event.starttime)},  
	               	'end' => {         
	          		'dateTime' => Chronic.parse(@event.endtime)}          
	            }
		        #Use the token from the data to request a list of calendars         token = user["token"]
			    client = Google::APIClient.new
			    client.authorization.access_token = @auth['token']
		        service = client.discovered_api('calendar', 'v3')
		        result = client.execute(:api_method => service.events.insert,
		        :parameters => {'calendarId' => @auth_id},
		        :body => JSON.dump(event),
		        :headers => {'Content-Type' => 'application/json'})
		        format.html { redirect_to "/create", notice: 'Event was successfully created.' }  
			  	format.json {render json: @event, status: :created, location: @event } 
			else
				format.html { render action: "/event" }
				format.json { render json: @event.errors, status: :unprocessable_entity }   
			end  
		end  
	end

end
