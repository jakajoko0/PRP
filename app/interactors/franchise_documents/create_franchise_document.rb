class CreateFranchiseDocument
	include Interactor
	
	def call
		franchise_document = FranchiseDocument.new()
		franchise_document.franchise_id = context.params[:franchise_id]
		franchise_document.document_type = context.params[:document_type].to_i
		franchise_document.document = context.params[:document]
		franchise_document.description = context.params[:description]


		if franchise_document.save 
			context.franchise_document = franchise_document
    else
	  	context.franchise_document = franchise_document
	  	context.fail!
	  end
	end

end