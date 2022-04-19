class FranchiseConsolidation < ActiveRecord::Base
	belongs_to :franchise
	has_many :cons_remittance, class_name: "Remittance" , foreign_key: 'franchise_number'
  validates_uniqueness_of :franchise_number, :message => 'This franchise entry already exists'

	def self.franchise_list(franchise_id)
	  where("franchise_id = ?", franchise_id)
	end

	def self.franchise_list_array(franchise_id)
	  self.franchise_list(franchise_id).pluck(:franchise_number)
	end

	def self.all_franchises
	  FranchiseConsolidation.pluck(:franchise_number)
	end
end