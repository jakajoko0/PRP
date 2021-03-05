module Transactionable
  extend ActiveSupport::Concern
   included do 
     has_many :prp_transactions, as: :transactionable, dependent: :destroy
   end
end
