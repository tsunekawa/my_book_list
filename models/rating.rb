class Rating < ActiveRecord::Base
  belongs_to :account
  belongs_to :ratable, :polymorphic=>true
end
