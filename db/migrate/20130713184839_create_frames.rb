class CreateFrames < ActiveRecord::Migration
  def change
    create_table :frames do |t|
      t.references :game
      t.integer :number, :null => false, :default => 1
      t.integer :throw1, :null => false, :default => 0
      t.integer :throw2, :null => false, :default => 0
      t.integer :bonus, :null => false, :default => 0
      t.integer :throws_count, :null => false, :default => 0
      t.timestamps
    end
  end
end
