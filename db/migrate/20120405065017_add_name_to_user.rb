class AddNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string,  :default => ""
    add_column :users, :name_changes, :integer,  :default => 3
  end
end
