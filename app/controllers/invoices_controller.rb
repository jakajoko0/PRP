# frozen_string_literal: true

# For Users to List, Add, Edit, Delete Invoices
class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[audit edit update destroy show]

  def index
    @pending = Invoice.recent_pending(current_user.franchise_id)
    @posted = Invoice.recent_posted(current_user.franchise_id)
    authorize! :read, Invoice
  end

  def new
    # Create the new Invoice object with defaults
    @invoice = current_user.franchise.invoices.new(date_entered: DateTime.now)
    @invoice.invoice_items.build
    # Make sure users can create a new invoice
    authorize! :new, @invoice
  end

  def create
    # Make sure users can create a new invoice
    authorize! :create, Invoice

    # Call the CreateInvoice interactor
    result = CreateInvoice.call(params: invoice_params,
                                user: current_authenticated,
                                admin: false)

    if result.success?
      flash[:success] = I18n.t('invoice.create.confirm')
      redirect_to invoices_path
    else
      @invoice = result.invoice
      render action: :new
    end
  end

  def edit
    # Make sure user can edit remittance
    authorize! :edit, @invoice
  end

  def update
    # Make sure the user can update a remittance
    authorize! :update, @invoice

    # Call the UpdateRemittance Interactor
    result = UpdateInvoice.call(invoice: @invoice,
                                params: invoice_params,
                                user: current_authenticated,
                                admin: false)

    if result.success?
      flash[:success] = I18n.t('invoice.update.confirm')
      redirect_to invoices_path
    else
      @invoice = result.invoice
      render 'edit'
    end
  end

  def destroy
    # Make sure the user can destroy a remittance
    authorize! :destroy, @invoice
    if @invoice.destroy
      flash[:success] = I18n.t('invoice.delete.confirm')
    else
      flash[:danger] = @invoice.errors.full_messages.to_sentence
    end
    redirect_to invoices_path
  end

  def show; end

  private

  def set_invoice
    @invoice = Invoice.friendly.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:franchise_id, :note, :date_entered, :paid,
                                    invoice_items_attributes: %i[code amount id _destroy])
  end
end
