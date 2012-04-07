class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => "home"

  # GET /world_maps
  # GET /world_maps.json
  def home
    #puts user_signed_in?
    puts "Current User: #{current_user.inspect}"
    #puts "User Session: #{user_session.inspect}"

    if @user && @user.characters.empty?
      char = @user.characters.new
      puts "Character saved? #{char.save}"
      @user.current_character = char.id
      @user.save
    end

    respond_to do |format|
      format.html # index.erb.erb
      #format.json { render json: @world_maps }
    end
  end

  # GET /world_maps/1
  # GET /world_maps/1.json
  def show
    #@world_map = WorldMap.find(params[:id])
    @x = params[:x].to_i if params.has_key?(:x)
    @y = params[:y].to_i if params.has_key?(:y)
    @radius = params[:radius].to_i if params.has_key?(:radius)
    @x ||= 50; @y ||= @x; @radius ||= 7
    @world_map = WorldMap.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @world_map }
    end
  end

  # GET /world_maps/new
  # GET /world_maps/new.json
  def new
    @world_map = WorldMap.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @world_map }
    end
  end

  # GET /world_maps/1/edit
  def edit
    @world_map = WorldMap.find(params[:id])
  end

  # POST /world_maps
  # POST /world_maps.json
  def create
    @world_map = WorldMap.new(params[:world_map])

    respond_to do |format|
      if @world_map.save
        format.html { redirect_to @world_map, notice: 'World map was successfully created.' }
        format.json { render json: @world_map, status: :created, location: @world_map }
      else
        format.html { render action: "new" }
        format.json { render json: @world_map.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /world_maps/1
  # PUT /world_maps/1.json
  def update
    @world_map = WorldMap.find(params[:id])

    respond_to do |format|
      if @world_map.update_attributes(params[:world_map])
        format.html { redirect_to @world_map, notice: 'World map was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @world_map.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /world_maps/1
  # DELETE /world_maps/1.json
  def destroy
    @world_map = WorldMap.find(params[:id])
    @world_map.destroy

    respond_to do |format|
      format.html { redirect_to world_maps_url }
      format.json { head :no_content }
    end
  end
end
