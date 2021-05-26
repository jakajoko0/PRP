# frozen_string_literal: true

class TransactionCode < ApplicationRecord

  validates :code, presence: true
  validates :code, uniqueness: { message: 'This code already exists' }
  validates :description, presence: true
  validates :trans_type, presence: true
  validates :show_in_royalties, inclusion: { in: [true, false] }
  validates :show_in_invoicing, inclusion: { in: [true,false] }

  enum trans_type: { credit: 0, charge: 1 }

  scope :by_code, -> { order('code ASC') }
  scope :credits_only, -> { where(trans_type: 0).order('description ASC') }
  scope :charges_only, -> { where(trans_type: 1).order('description ASC') }
  scope :credits_royalty, -> { where(trans_type: 0, show_in_royalties: true ).order('description ASC') }

  def self.description_from_code(r_code)
    @trans_by_code ||= TransactionCode.select(:id, :code, :description)
                                      .map{|e| e.attributes.values}
                                      .inject({}) {|arr , trans_code| arr[trans_code[1]] = trans_code[2]; arr}
    return @trans_by_code[r_code] if @trans_by_code[r_code]
    result = TransactionCode.select('description')
                            .where('code = ?',r_code)
    if result.length > 0 
      return @trans_by_code[r_code] = result[0].description
    else
      return nil
    end
  end

  def self.description_from_id(r_id)
    @trans_by_id ||= TransactionCode.select(:id, :code, :description)
                                    .map{|e| e.attributes.values}
                                    .inject({}) {|arr , trans_code| arr[trans_code[0]] = trans_code[2]; arr}
    return @trans_by_id[r_id] if @trans_by_id[r_id]
    result = TransactionCode.select('description')
                            .where('id = ?', r_id)
    if result.length > 0 
      return @trans_by_id[r_id] = result[0].description
    else
      return nil
    end
  end

end