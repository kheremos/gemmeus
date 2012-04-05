module ApplicationHelper


  def display_flashes
    if flash[:error]
      "<p class='error'>#{h(flash[:error])}</p>".html_safe
    end
    if flash[:notice]
      "<p id='notice'>Note: #{h notice} </p>".html_safe
    else
      # Do nothing
    end
  end

end
