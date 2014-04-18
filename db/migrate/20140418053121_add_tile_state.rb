class AddTileState < ActiveRecord::Migration
  def change
    change_table :tiles do |t|
      t.string :state
    end
  end
end
