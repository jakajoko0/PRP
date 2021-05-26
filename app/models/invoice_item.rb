# frozen_string_literal: true

class InvoiceItem < ApplicationRecord
	belongs_to :invoice

  validates :amount, presence: true
  validates :code ,  presence: true
  validates_numericality_of :amount, greater_than_or_equal_to: 0, message: :no_negative
end