class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :session_id
      t.integer :number
      t.integer :current_frame_number, :null => false, :default => 1
      t.timestamps
    end
  end
end
