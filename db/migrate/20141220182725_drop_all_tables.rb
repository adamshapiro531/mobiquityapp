class DropAllTables < ActiveRecord::Migration
  def change
  	drop_table :users
  	drop_table :events
  end
end
