class Group < ApplicationRecord

    validates_presence_of :gtype
    validates_inclusion_of :gtype, in: ['Contact', 'Entity', 'Property']
    
    has_many :group_members, :foreign_key => :group_id, :dependent => :destroy
    has_many :gmembers, :through => :group_members
    has_many :entities, :through => :group_members, :source => :gmember, :source_type => 'Entity'
    has_many :contacts, :through => :group_members, :source => :gmember, :source_type => 'Contact'
    has_many :properties, :through => :group_members, :source => :gmember, :source_type => 'Property'
    belongs_to :parent, :class_name => "Group"
    has_many :children, :class_name => "Group", :foreign_key => "parent_id"

end
