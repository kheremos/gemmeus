class Character < ActiveRecord::Base
  belongs_to :user

  alias_attribute :x, :xloc
  alias_attribute :y, :yloc
  alias_attribute :view, :vision

  #def x
  #  xloc
  #end
  #
  #def y
  #  yloc
  #end

end
