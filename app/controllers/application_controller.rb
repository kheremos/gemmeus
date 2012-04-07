class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_menus

  def load_menus
    @user = current_user
    @sidebar_items = {
        :top => ActiveSupport::OrderedHash.new,
        :bottom => ActiveSupport::OrderedHash.new
    }
    @main_menu_items = ActiveSupport::OrderedHash.new
    character unless @character
    @sidebar_items[:top][@character.name] = "/home" unless @character.nil?
    @sidebar_items[:top]["Home"] = "/home"
    @sidebar_items[:top]["Characters"] = "/series"
    @sidebar_items[:top]["Map"] = "/worldmap/explore/"
    # Links for when a user is logged in
    if @user
      @sidebar_items[:top]["Favorites"] = "/series/user/#{@user.id}" if @user.name == ":dumb)"
    end
    #@sidebar_items[:top]["Search All"] = "/searches"
    #@sidebar_items[:bottom]["Transactions"] = "/transactions"
  end

  def load_context
    if current_user.current_character.nil?
      current_user.current_character = current_user.characters.first.id
      current_user.save
    end
    @character = current_user.characters.find(current_user.current_character) unless @character
  end

  def character
    return nil if current_user.nil?
    current_user.current_character = current_user.characters.first unless @character
    @character = current_user.characters.find(current_user.current_character)
  end

end
