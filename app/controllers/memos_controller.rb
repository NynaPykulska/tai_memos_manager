class MemosController < ApplicationController
   	
    protect_from_forgery with: :null_session
    before_action :authenticate_user!

   include MemoHelper       
   $stored_date = nil

    def redirect
      client = Signet::OAuth2::Client.new({
        client_id: Rails.application.secrets.google_client_id,
        client_secret: Rails.application.secrets.google_client_secret,
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
        redirect_uri: callback_url
      })
      puts "params ------------------------"
      puts params[:date]
      $stored_date = params[:date]
      puts "params ------------------------"

      redirect_to client.authorization_uri.to_s
    end

    def callback
      client = Signet::OAuth2::Client.new({
        client_id: Rails.application.secrets.google_client_id,
        client_secret: Rails.application.secrets.google_client_secret,
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        redirect_uri: callback_url,
        code: params[:code]
      })

      response = client.fetch_access_token!

      session[:authorization] = response

      redirect_to calendars_url
    end

    def calendars
      client = Signet::OAuth2::Client.new({
        client_id: Rails.application.secrets.google_client_id,
        client_secret: Rails.application.secrets.google_client_secret,
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token'
      })

      client.update!(session[:authorization])

      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client

      @calendar_list = service.list_calendar_lists

      
    end

     def new_event
      client = Signet::OAuth2::Client.new({
        client_id: Rails.application.secrets.google_client_id,
        client_secret: Rails.application.secrets.google_client_secret,
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token'
      })

      client.update!(session[:authorization])

      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client

      puts "@stored_date ------------------------"
      puts $stored_date
      puts "@stored_date ------------------------"
      date = Date.strptime($stored_date, "%Y-%m-%d")

      @memos = Memo.where('deadline BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day).all
      @memos.each do |memo|
        event = Google::Apis::CalendarV3::Event.new({
          start: Google::Apis::CalendarV3::EventDateTime.new(date: date),
          end: Google::Apis::CalendarV3::EventDateTime.new(date: date + 1),
          summary: memo.description
        })
        service.insert_event(params[:calendar_id], event)
      end

      # event = Google::Apis::CalendarV3::Event.new({
      #   start: Google::Apis::CalendarV3::EventDateTime.new(date: date),
      #   end: Google::Apis::CalendarV3::EventDateTime.new(date: date + 1),
      #   summary: 'New event!'
      # })

      # puts "event"
      # puts event
      # puts event.start
      # puts event.end
      # puts "------------------------"

      # service.insert_event(params[:calendar_id], event)

      redirect_to list_url
    end

   	def list
      if params[:date].blank?
        @date = Date.current();

      else
        @date = Date.strptime(params[:date], "%Y-%m-%d")
      end
      @memos = Memo.where('deadline BETWEEN ? AND ?', @date.beginning_of_day, @date.end_of_day).all

      @stored_date = @date
      @done = 0
      @not_done = 0

      @memos.each do |m|
        m.is_done ? @done+=1 : @not_done+=1
      end
   	end

    def mark_ready
      @memo = Memo.find(params[:id])
      @memo.update_attribute(:is_done, true)
      @memo.update_attribute(:deadline, Date.today)
      @memo.is_done = true
      render :nothing => true
      # redirect_to :action => 'list'
    end

    def reopen
      @memo = Memo.find(params[:id])
      @memo.update_attribute(:is_done, false)
      @memo.update_attribute(:deadline, nil)
      @memo.is_done = false
      render :nothing => true
      # redirect_to :action => 'list'
    end

   	def list_open																																						
   		@memos = Memo.where("is_done = ?", true)
   	end

   	def list_ready
   		@memos = Memo.where("is_done = ?", false)
   	end
   
   	def show
   		@memo = Memo.find(params[:id])
   	end
   
   	def new

   	end

 	def create
    @room = Room.where("room_id = ?", memo_params[:room_id]).first

      @date = DateTime.strptime(params[:memo]["deadline"], '%Y-%m-%d').change({ hour: params[:memo]["deadline(4i)"].to_i, min: params[:memo]["deadline(5i)"].to_i})  
      @memo = @room.memos.create(room_id: memo_params[:room_id], description: memo_params[:description], deadline: @date, deadline: memo_params[:deadline], is_done: memo_params[:is_done], is_recurring: false )
      redirect_back(fallback_location: root_path)
  end
   
	def memo_params
   		params.require(:memo).permit(:room_id, :description, :deadline, :deadline, :memo_time, :time_stamp, :is_done, :is_recurring, :start_date, :end_date, :recurrence, :pattern)
	end

 	def edit
    @c = Memo.find(params[:id])
  end
   
 	def update
    @memo = Memo.find(params[:id])
    @memo.update_attributes(memo_params)
    redirect_back(fallback_location: root_path)
  end

 	def memo_param
 		params.require(:memo).permit(:room_no, :description, :deadline)
	end
   
 	def delete
 		Memo.find(params[:id]).destroy
 		redirect_to :back
 	end

  def delete_recurrence
    Memo.where(:event_id => params[:event_id]).destroy_all
    redirect_to :back
  end

 	def show_rooms
 		@room = Room.find(params[:id])
	end											

end