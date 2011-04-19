# This is the basic migration for the corvette class.
class Createcorvettes < ActiveRecord::Migration

  def self.up
    create_table :corvettes do |t|
      t.string :name
      t.text :description
      t.string :mach_name
      t.integer :price
      t.integer :creator_id
      t.timestamps
    end
  end

  def self.down
    drop_table :corvettes
  end

end

