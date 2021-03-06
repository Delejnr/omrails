 class PinsController < ApplicationController

  before_filter :authenticate_user!, except: [:index, :show]
  # GET /pins
  # GET /pins.json
  def index
    
    
    @pins = Pin.search(params[:search])
    
  
    
    @pins = @pins.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pins }
      format.js
    end
  end

  # GET /pins/1
  # GET /pins/1.json
  def show
    @pin = Pin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pin }
    end
  end

  # GET /pins/new
  # GET /pins/new.json
  def new
    
      @pin = current_user.pins.new()
      @pin.description = params[:description]
      @pin.thumb_url = params[:media]
        regExp = /http:\/\/(www\.)?vimeo.com\/(\d+)($|\/)/
       if params[:description] 
        if params[:yt_video_id]
          @pin.yt_video_id = params[:yt_video_id]
        else
          youtube_url = params[:url]
          match = youtube_url.match(regExp)
          if !match
            if youtube_url.match(/youtu\.be\/([^\?]*)/)
              @pin.yt_video_id = youtube_url.match(/youtu\.be\/([^\?]*)/)[1]
            else
              if youtube_url.match(/v=([^&]*)/)
                @pin.yt_video_id = youtube_url.match(/v=([^&]*)/)[1]
                @pin.site_id = "1"
              else
                
                @pin.yt_video_id = youtube_url.gsub('www','embed')
                @pin.site_id = "3"
              
              
              end
            end
          else
            @pin.yt_video_id = match[2]
            
            @pin.site_id = "2"

          end
        end
        @hidden = 'true'
      end
      

     
      
     
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pin }
    end
  end

  # GET /pins/1/edit
  def edit
    @pin = current_user.pins.find(params[:id])
  end

  # POST /pins
  # POST /pins.json
  def create
    @pin = current_user.pins.new(params[:pin])
    

    respond_to do |format|
      if @pin.save
        format.html { redirect_to @pin, notice: 'Pin was successfully created.' }
        format.json { render json: @pin, status: :created, location: @pin }
      else
        format.html { render action: "new" }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pins/1
  # PUT /pins/1.json
  def update
    @pin = current_user.pins.find(params[:id])

    respond_to do |format|
      if @pin.update_attributes(params[:pin])
        format.html { redirect_to @pin, notice: 'Pin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pins/1
  # DELETE /pins/1.json
  def destroy
    @pin = current_user.pins.find(params[:id])
    @pin.destroy

    respond_to do |format|
      format.html { redirect_to pins_url }
      format.json { head :no_content }
    end
  end

  def vote
    value = params[:type] == "up" ? 1 : -1
    @pin = Pin.find(params[:id])
    @pin.add_or_update_evaluation(:votes, value, current_user)
    redirect_to :back, notice: "Thank you for voting"
  end
  def copy
  
  pin = Pin.find(params[:pin])
  @channel = current_user.channels.last
  new_pin = current_user.pins.new(:description => pin.description, :yt_video_id => pin.yt_video_id, :site_id => pin.site_id, :channel_id => @channel.id, :thumb_url => pin.thumb_url)    
  respond_to do |format|
    
    if new_pin.save
      format.html { redirect_to edit_pin_path(new_pin)}
    else
      format.html { redirect_to root_url, notice: "Error saving pin." }
end
end
 # new_pin = current_user.pins.new(:description => pin.description, :yt_video_id => pin.yt_video_id)    
 # respond_to do |format|
 #   if new_pin.save
 #     format.html { redirect_to new_pin, notice: 'Pin was successfully created.' }
 #   else
 #     format.html { redirect_to root_url, notice: "Error saving pin." }
#end
#end

end
end
