class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_context
  before_filter :load_menus

  def load_menus
    @sidebar_items = {
        :top => ActiveSupport::OrderedHash.new,
        :bottom => ActiveSupport::OrderedHash.new
    }
    @main_menu_items = ActiveSupport::OrderedHash.new
    @sidebar_items[:top][@character.name] = "/" unless @character.nil?
    @sidebar_items[:top]["Home"] = "/"
    @sidebar_items[:top]["Characters"] = "/"
    @sidebar_items[:top]["Map"] = "/worldmap/explore/"
    @sidebar_items[:top]["Caleb Map"] = "/worldmap/generate/"
    # Links for when a user is logged in
    if @user
      @sidebar_items[:top]["Favorites"] = "/series/user/#{@user.id}" if @user.name == ":dumb)"
    end
    #@sidebar_items[:top]["Search All"] = "/searches"
    #@sidebar_items[:bottom]["Transactions"] = "/transactions"
  end

  def load_context
    @user = current_user
    @character = character unless @character
  end

  def character
    return nil if current_user.nil?
    # Create a new character if one doesn't exist
    if current_user.characters.empty?
      char = current_user.characters.new
      puts "New character saved? #{char.save}"
      current_user.current_character = current_user.characters.first.id
      current_user.save
    elsif current_user.current_character.nil?
      current_user.current_character = current_user.characters.first.id
      current_user.save
    end
    current_user.characters.find(current_user.current_character)
  end

end
