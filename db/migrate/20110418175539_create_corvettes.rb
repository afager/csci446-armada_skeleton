# This is the basic migration for the corvette class.
class CreateCorvettes < ActiveRecord::Migration

  def self.up
    create_table :corvettes do |t|
      t.string :name
      t.text :description
      t.integer :mach_num
      t.integer :price
      t.integer :creator_id
      t.timestamps
    end
  end

  def self.down
    drop_table :corvettes
  end

end

