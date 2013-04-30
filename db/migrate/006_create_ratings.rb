class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :account_id
      t.integer :rate
      t.integer :ratable_id
      t.string  :ratable_type
      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
