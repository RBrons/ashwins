class GroupMember < ApplicationRecord
    belongs_to :group
    belongs_to :gmember, :polymorphic => true
end
