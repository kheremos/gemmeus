class CreateWorldMaps < ActiveRecord::Migration
  def change
    create_table :world_maps do |t|
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
