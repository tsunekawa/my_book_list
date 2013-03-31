class CreateAmazonItems < ActiveRecord::Migration
  def self.up
    create_table :amazon_items do |t|
      t.string :asin, :null=>false      
      t.timestamps
    end
  end

  def self.down
    drop_table :amazon_items
  end
end
