class CreateHavingBooks < ActiveRecord::Migration
  def self.up
    create_table :having_books do |t|
      t.integer :account_id, :null=>false
      t.integer :amazon_item_id, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :having_books
  end
end
