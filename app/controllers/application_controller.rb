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
    @sidebar_items[:top]["Home"] = "/home"
    @sidebar_items[:top]["Characters"] = "/series"
    @sidebar_items[:top]["Map"] = "/worldmap/explore/250/200/100"
    # Links for when a user is logged in
    if @user
      @sidebar_items[:top]["Favorites"] = "/series/user/#{@user.id}" if @user.name == ":dumb)"
    end
    #@sidebar_items[:top]["Search All"] = "/searches"
    #@sidebar_items[:bottom]["Transactions"] = "/transactions"
  end


end
