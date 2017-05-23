class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # def redirect
  #   client = Signet::OAuth2::Client.new({
  #     client_id: Rails.application.secrets.google_client_id,
  #     client_secret: Rails.application.secrets.google_client_secret,
  #     authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
  #     scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
  #     redirect_uri: callback_url
  #   })

  #   redirect_to client.authorization_uri.to_s
  # end

  # def callback
  #   client = Signet::OAuth2::Client.new({
  #     client_id: Rails.application.secrets.google_client_id,
  #     client_secret: Rails.application.secrets.google_client_secret,
  #     token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
  #     redirect_uri: callback_url,
  #     code: params[:code]
  #   })

  #   response = client.fetch_access_token!

  #   session[:authorization] = response

  #   redirect_to new_event_url
  # end

  # def calendars
  #   client = Signet::OAuth2::Client.new({
  #     client_id: Rails.application.secrets.google_client_id,
  #     client_secret: Rails.application.secrets.google_client_secret,
  #     token_credential_uri: 'https://accounts.google.com/o/oauth2/token'
  #   })

  #   client.update!(session[:authorization])

  #   service = Google::Apis::CalendarV3::CalendarService.new
  #   service.authorization = client

  #   @calendar_list = service.list_calendar_lists
  # end

  # def new_event
  #   client = Signet::OAuth2::Client.new({
  #     client_id: Rails.application.secrets.google_client_id,
  #     client_secret: Rails.application.secrets.google_client_secret,
  #     token_credential_uri: 'https://accounts.google.com/o/oauth2/token'
  #   })

  #   client.update!(session[:authorization])

  #   service = Google::Apis::CalendarV3::CalendarService.new
  #   service.authorization = client

  #   today = Date.today

  #   event = Google::Apis::CalendarV3::Event.new({
  #     start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
  #     end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
  #     summary: 'New event!'
  #   })

  #   service.insert_event(params[:calendar_id], event)

  #   redirect_to events_url(calendar_id: params[:calendar_id])
  # end

  # def authenticate_user!(options={})
  #   if user_signed_in?
  #     super(options)
  #   else
  #     redirect_to new_user_session_path
  #     ## if you want render 404 page
  #     ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
  #   end
  # end

  # def after_sign_in_path_for(resource)
  #   if resource.admin? or resource.receptionist?
  #     '/dayLog/list'
  #   elsif resource.maid?
  #     '/roomStatus/list' 
  #   elsif resource.maitenance?
  #     '/issueLog/list'
  #   end
  # end

end
