class CreateNdlItems < ActiveRecord::Migration
  def self.up
    create_table :ndl_items do |t|
      t.string :isbn
      t.string :ndc
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :ndl_items
  end
end
