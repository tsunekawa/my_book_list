class Rating < ActiveRecord::Base
  validates_uniqueness_of :account_id, :scope=>[:ratable_id,:ratable_type]

  belongs_to :account
  belongs_to :ratable, :polymorphic=>true
end
