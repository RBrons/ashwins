class Comment < ApplicationRecord
  include MyFunction
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  after_save :add_key
end
