class AddInventoryProperties < ActiveRecord::Migration
  def change
    add_column :items, :item_type, :string
    add_column :items, :affects, :string
    add_column :items, :moves_player_x, :integer
    add_column :items, :moves_player_y, :integer
    add_column :items, :consumable, :boolean
    add_column :items, :battery_effect, :integer
    add_column :items, :health_effect, :integer
    add_column :items, :default_message, :string
  end
end
