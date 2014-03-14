class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.boolean :pickupable
      t.boolean :walkoverable

      t.timestamps
    end
  end
end
