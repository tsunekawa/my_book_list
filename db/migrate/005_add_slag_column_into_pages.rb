class AddSlagColumnIntoPages < ActiveRecord::Migration
  def self.up
    add_column :pages,:slag,:string, :unique=>true
  end

  def self.down
    remove_column :pages,:slag
  end
end
