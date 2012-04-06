class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.integer :user_id
      t.string :name,  :default => "Adventurer"
      t.integer :experience,  :default => 0
      t.integer :class_id, :default => 1
      t.integer :level,  :default => 1
      t.integer :vision,  :default => 3
      t.integer :world_map_id, :default => 1
      t.integer :xloc, :default => 50
      t.integer :yloc, :default => 50

      t.timestamps
    end
  end
end
