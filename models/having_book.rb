class HavingBook < ActiveRecord::Base
  belongs_to :book, :foreign_key=>:amazon_item_id
  belongs_to :account
  belongs_to :amazon_item
end
