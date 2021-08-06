# frozen_string_literal: true

class FranchiseDocument < ApplicationRecord
  belongs_to :franchise
  has_one_attached :document

  validates :description, presence: true
  validates :document_type, presence: true
  validates :document,
            attached: true,
            content_type: [:gif, :png, :jpg, :jpeg, :pdf, :xls, :xlsx, :tif, 'application/msword',
                           'application/vnd.openxmlformats-officedocument.wordprocessingml.document'],
            size: { less_than: 10.megabytes, message: 'Document must be less than 10Mb' }

  enum document_type: { 'tax return' => 1, 'insurance' => 2, 'p&l' => 3 , 'client list' => 4, 'other' => 5 }

  scope :for_franchise, lambda { |fran_id|
                          FranchiseDocument.includes(document_attachment: :blob).where(franchise_id: fran_id).order('created_at DESC')
                        }
  scope :all_ordered, lambda {
                        FranchiseDocument.includes(:franchise, document_attachment: :blob).order('created_at DESC')
                      }
end
