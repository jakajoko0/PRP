class PrpTransaction < ApplicationRecord
belongs_to :franchise
belongs_to :transactionable, polymorphic: true, optional: true

audited  on: [:update, :destroy]


validates :franchise, presence: true
validates :date_posted, presence: true
validates :trans_type, presence: true
validates :trans_code, presence: {message: "Please select Transaction Code"}
validates_numericality_of :amount, {greater_than_or_equal_to: 0, message: "Please enter an amount"} 

enum trans_type: {receivable: 1, credit: 2 , payment: 3}

scope :all_credits, -> {includes(:franchise).where(trans_type: 2).order("date_posted DESC")}
scope :credits_for_franchise, -> (fran_id) {where(franchise_id: fran_id, trans_type: 2).order("date_posted DESC")}
scope :all_charges, -> {includes(:franchise).where(trans_type: 1).order("date_posted DESC")}
scope :charges_for_franchise, -> (fran_id) {where(franchise_id: fran_id, trans_type: 1).order("date_posted DESC")}


def quick_info
	"Credit Code #{trans_code} for #{amount} on #{date_posted} for #{franchise.number_and_name}"
end



end