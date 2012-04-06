class AddCurrentCharacterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_character, :integer

  end
end
