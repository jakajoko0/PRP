class Admins::WebsitePreferencesController < ApplicationController
before_action :set_website_preference, only: [:audit, :edit, :update, :destroy]


def index
  @website_preferences = WebsitePreference.includes("franchise")
  .order("website_preferences.created_at DESC")
  .paginate(per_page: 20, page: params[:page])
  
  authorize! :read, WebsitePreference
end

def new 
  redirect_to root_url, notice: I18n.t('franchise_not_selected') unless params[:franchise_id]
  franchise_id = params[:franchise_id].to_i
  @current_franchise = Franchise.find(franchise_id)
	@website_preference = WebsitePreference.new(franchise_id: franchise_id)
  populate_bank_dropdown
  populate_card_dropdown
	authorize! :new, @website_preference
end

def create
  fran = website_preference_params[:franchise_id].to_i
  @current_franchise = Franchise.find(fran)
  authorize! :create, WebsitePreference
  result = CreateWebsitePreference.call(params: website_preference_params, user: current_authenticated)

  if result.success?
  	flash[:success] = I18n.t('website_preference.create.confirm')
  	redirect_to admins_website_preferences_path
  else
    @website_preference = result.website_preference
    populate_bank_dropdown
    populate_card_dropdown
  	render action: :new 
  end
end

def edit
	authorize! :edit, @website_preference
  @current_franchise = Franchise.find(@website_preference.franchise_id)
  populate_bank_dropdown
  populate_card_dropdown
  @website_preference.assign_proper_token
end

def update
	authorize! :update, @website_preference
  @current_franchise = Franchise.find(@website_preference.franchise_id)
   populate_bank_dropdown
  populate_card_dropdown
  result = UpdateWebsitePreference.call(website_preference: @website_preference,
                           params: website_preference_params,
                           user: current_authenticated
                           )
	
	if result.success?
		flash[:success] = I18n.t('website_preference.update.confirm')
		redirect_to admins_website_preferences_path
	else
    @website_preference = result.website_preference
		render 'edit'
	end
end

def destroy 
  authorize! :destroy, @website_preference
  if @website_preference.destroy
    flash[:success] = I18n.t('website_preference.delete.confirm')
    redirect_to admins_website_preferences_path
  else
    flash[:error] = @website_preference.errors.full_messages.to_sentence
    redirect_to admins_website_preferences_path
  end 
end

def audit
  @audits = @website_preference.audits.descending
end

private
	def set_website_preference
		@website_preference = WebsitePreference.friendly.find(params[:id])
  end


  def website_preference_params
     params.require(:website_preference)
    .permit(:franchise_id, :website_preference, :bank_token,
      :card_token, :payment_method )
  end

  

  def populate_bank_dropdown
      @bank_array = []
      banks = @current_franchise.bank_accounts.order("id")
      banks.each do |b|
        @bank_array << [b.bank_name + ' Ending In '+b.last_four, b.bank_token]
      end
   end
  
    def populate_card_dropdown
      @card_array = []
      cards = CreditCard.generate_dropdown_values(@current_franchise.id)
      cards.each do |c|
        @card_array << [c.card_type + ' Ending In '+c.last_four, c.card_token ]
      end
    end

  

end