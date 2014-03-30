class AddCharactersToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :character, index: true
  end
end
