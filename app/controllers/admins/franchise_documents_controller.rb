class Admins::FranchiseDocumentsController < ApplicationController
  before_action :set_franchise_document, only: [:destroy]


  def index
    @franchise_documents = FranchiseDocument.all_ordered
                            .paginate(per_page: 20, page: params[:page])
    authorize! :read, FranchiseDocument
  end

  def new 
    redirect_to root_url, notice: I18n.t('franchise_not_selected') unless params[:franchise_id]
    franchise_id = params[:franchise_id].to_i
	  @franchise_document = FranchiseDocument.new(franchise_id: franchise_id)

	  authorize! :new, @franchise_document
  end

  def create
    authorize! :create, FranchiseDocument
    result = CreateFranchiseDocument.call(params: franchise_document_params)

    if result.success?
  	  flash[:success] = I18n.t('franchise_document.create.confirm')
  	  redirect_to admins_franchise_documents_path
    else
      @franchise_document = result.franchise_document
  	  render action: :new 
    end
  end


  def destroy 
    authorize! :destroy, @franchise_document
    if @franchise_document.destroy
      flash[:success] = I18n.t('franchise_document.delete.confirm')
      redirect_to admins_franchise_documents_path
    else
      flash[:danger] = @franchise_document.errors.full_messages.to_sentence
      redirect_to admins_franchise_documents_path
    end
  end


  private
	  def set_franchise_document
		  @franchise_document = FranchiseDocument.find(params[:id])
    end

    def franchise_document_params
      params.require(:franchise_document).permit(:franchise_id, :description, :document_type, :document)
    end

end