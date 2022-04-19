class FranchiseGroupDetail < ActiveRecord::Base
  belongs_to :franchise_group_master
  belongs_to :franchise
  validates_presence_of :franchise_id, message: "Franchise ID cannot be blank"  
  validates :franchise_id, :uniqueness => {:scope => [:franchise_group_master_id], :message => 'This franchise already exists in this group'}
end


