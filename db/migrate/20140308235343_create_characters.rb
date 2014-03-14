class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :health
      t.integer :battery
      t.integer :facing
      t.string :planet

      t.timestamps
    end
  end
end
