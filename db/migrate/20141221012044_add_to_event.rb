class AddToEvent < ActiveRecord::Migration
  def change
  	create_table :events do |t|
      t.string :summary
      t.string :location
      t.string :starttime
      t.string :endtime

      t.timestamps
  	end
  end
end
