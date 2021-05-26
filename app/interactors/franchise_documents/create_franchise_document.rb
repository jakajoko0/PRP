# frozen_string_literal: true

# Interactor to isolate the business logic of Adding a Franchise Document
class CreateFranchiseDocument
  include Interactor

  def call
    @franchise_document = FranchiseDocument.new
    assign_values

    if @franchise_document.save
      context.franchise_document = @franchise_document
    else
      context.franchise_document = @franchise_document
      context.fail!
    end
  end

  def assign_values
    @franchise_document.franchise_id = context.params[:franchise_id]
    @franchise_document.document_type = context.params[:document_type].to_i
    @franchise_document.document = context.params[:document]
    @franchise_document.description = context.params[:description]
  end
end
