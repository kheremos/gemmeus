module WorldMapsHelper

  def update_image(player_mx, player_my, world_x, world_y, plr_map)
    result = "$('.m#{player_mx}m#{player_my}').attr('src','/assets/#{plr_map.get_image(world_x, world_y)}');"

    result.html_safe

  end

end
