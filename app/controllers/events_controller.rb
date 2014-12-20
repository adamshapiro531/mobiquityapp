class EventsController < ApplicationController
	def create
    @event = Event.new(event_params)

    if @event.save

      render :nothing => true
      google_event = { 'summary' => @event.title, 'description' => @event.description, 'location' => @event.location, 'start' => {'dateTime' => @event.start_time}, 'end' => {'dateTime' => @event.end_time}, 'attendees' => [{"email" =>'landon.marder@gmail.com'}] }

      client = Google::APIClient.new
      client.authorization.access_token = current_user.token
      service = client.discovered_api('calendar', 'v3')

      result = client.execute(:api_method => service.events.insert,
                              :parameters => {'calendarId' => 'landon.marder@gmail.com', 'sendNotifications' => true},
                              :body => JSON.dump(google_event),
                              :headers => {'Content-Type' => 'application/json'})

      @event.google_event_id = result.data.id
      @event.save
    else
      render :nothing => true
    end
  end
end
