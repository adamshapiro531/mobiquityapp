class SessionsController < ApplicationController
  layout false
 
	def new
	end

	def create
		@auth = request.env['omniauth.auth']['credentials']
		@auth_id = request.env['omniauth.auth']['info']['email']
		session[:id] = @auth_id
		session[:token] = @auth['token']
		redirect_to '/show'
	end

	def event
	end

	def show
	end

	def post_event
	  	@event = Event.new(params[:event])
	    respond_to do |format|
		    if @event.save
		        event = {
	                'summary' => @event.summary,
	                'location' => @event.location,
	                'start' => {
	                'dateTime' => Chronic.parse(@event.starttime)},  
	               	'end' => {         
	          		'dateTime' => Chronic.parse(@event.endtime)},   
	          		'attendees' => session[:id]
	            }
		        #Use the token from the data to request a list of calendars         token = user["token"]
			    client = Google::APIClient.new
			    client.authorization.access_token = session[:token]
		        service = client.discovered_api('calendar', 'v3')
		        result = client.execute(:api_method => service.events.insert,
		        :parameters => {'calendarId' => session[:id]},
		        :body => JSON.dump(event),
		        :headers => {'Content-Type' => 'application/json'})
		        format.html { redirect_to "/show", notice: 'Event was successfully created.' }  
			  	format.json {render json: @event, status: :created, location: @event } 
			else
				format.html { render action: "/event" }
				format.json { render json: @event.errors, status: :unprocessable_entity }   
			end  
		end  
	end

end
