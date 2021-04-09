class FranchiseDocumentsController < ApplicationController
  before_action :set_franchise_document, only: [:destroy]

  def index
  	@franchise_documents = FranchiseDocument.for_franchise(current_user.franchise_id)
                           .paginate(per_page: 20, page: params[:page])
  	authorize! :read, FranchiseDocument
  end

  def new 
  	@franchise_document = current_user.franchise.franchise_documents.new()
  	authorize! :new, @franchise_document
  end

  def create 
  	authorize! :create, FranchiseDocument 
    result = CreateFranchiseDocument.call(params: franchise_document_params)

    if result.success? 
			flash[:success] = I18n.t('franchise_document.create.confirm')
    	redirect_to franchise_documents_path
 		else
      @franchise_document = result.franchise_document
 			render action: :new
		end  	
  end

  def destroy
    if @franchise_document.destroy
      flash[:success] = I18n.t('franchise_document.delete.confirm')
      redirect_to franchise_documents_path
    else
      flash[:danger] = @franchise_document.errors.full_messages.to_sentence
      redirect_to franchise_documents_path
    end
  end

  private 
    def franchise_document_params
    	params.require(:franchise_document).permit(:franchise_id, :description, :document_type, :document)
    end

    def set_franchise_document
    	@franchise_document = FranchiseDocument.find(params[:id])
    end

end