class BankRouting < ApplicationRecord

  def self.bank_name_from_routing(routing_number)
  	result = BankRouting.select("name").where(routing: routing_number).first
  	result.nil? ? "NOT FOUND" : result.name
  end


end