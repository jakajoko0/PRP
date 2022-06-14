class WorkScripts
  require 'csv'
  include ActionView::Helpers
  
  def import_franchises
  	file = "#{Rails.root}/public/franchises.csv"
    ActiveRecord::Base.transaction do
  	  CSV.foreach(file, headers: true) do |row|
        new_franchise = Franchise.new row.to_hash

        new_franchise.phone = format_phone(new_franchise.phone)
        new_franchise.phone2 = format_phone(new_franchise.phone2)
        new_franchise.mobile = format_phone(new_franchise.mobile)
        new_franchise.fax = format_phone(new_franchise.fax)

        new_franchise.save!(validate: false)
      end
    end
  end

  def import_accountants
    file = "#{Rails.root}/public/accountants.csv"
    ActiveRecord::Base.transaction do 
      CSV.foreach(file, headers: true) do |row|
        acc = Accountant.new row.to_hash
        acc.save!(validate: false)
      end
    end
  end

  def import_insurances
    file = "#{Rails.root}/public/insurances.csv"
    ActiveRecord::Base.transaction do 
      CSV.foreach(file, headers: true) do |row|
        Insurance.create! row.to_hash
      end
    end
  end

  def import_website_pref
    file = "#{Rails.root}/public/website_pref.csv"
    ActiveRecord::Base.transaction do 
      CSV.foreach(file, headers: true) do |row|
        pref = WebsitePreference.new row.to_hash
        pref.without_auditing do
          pref.save!(validate: false)
        end
      end
    end
  end

  def import_bank_accounts
    file = "#{Rails.root}/public/banks.csv"
    ActiveRecord::Base.transaction do 
      CSV.foreach(file, headers: true) do |row|
        bank = BankAccount.new row.to_hash
        bank.without_auditing do 
          bank.save!(validate: false)
        end
      end
    end
  end

  def import_credit_cards
    file = "#{Rails.root}/public/cc.csv"
    ActiveRecord::Base.transaction do 
      CSV.foreach(file, headers: true) do |row|
        cc = CreditCard.new row.to_hash
        cc.without_auditing do 
          cc.save!(validate: false)
        end
      end
    end
  end

  def import_financials
    file = "#{Rails.root}/public/financials.csv"
    ActiveRecord::Base.transaction do 
      CSV.foreach(file, headers: true) do |row|
        f = Financial.new row.to_hash
        f.without_auditing do 
          f.save!(validate: false)
        end
      end
    end
  end

  def import_charge_codes
    file = "#{Rails.root}/public/charge_codes.csv"
    ActiveRecord::Base.transaction do 
      CSV.foreach(file, headers: true) do |row|
        TransactionCode.create! row.to_hash
      end
    end
  end

  def import_credit_codes
    file = "#{Rails.root}/public/credit_code.csv"
    ActiveRecord::Base.transaction do 
      CSV.foreach(file, headers: true) do |row|
        TransactionCode.create! row.to_hash
      end
    end
  end

  def import_unattached_receivable
    items = []
    file = "#{Rails.root}/public/lone_rec.csv"
    ActiveRecord::Base.transaction do 
      CSV.foreach(file, headers: true) do |row|
       items << row.to_h
      end
    PrpTransaction.import(items)
    end
  end

  def import_unattached_credits
    items = []
    file = "#{Rails.root}/public/lone_credits.csv"
    ActiveRecord::Base.transaction do
      CSV.foreach(file, headers: true) do |row|
        items << row.to_h
      end
      PrpTransaction.import(items)
    end
  end

  def import_users
    file = "#{Rails.root}/public/users.csv"
    ActiveRecord::Base.transaction do 
      #User.skip_callback(:create, :after, :log_event)
      CSV.foreach(file, headers: true) do |row|
        u = User.new row.to_hash
        
          u.save!(validate: false)
       
      end
    end
  end

  def import_invoices
    file = "#{Rails.root}/public/invoice.csv"
    ActiveRecord::Base.transaction do 
      CSV.foreach(file, headers: true) do |row|
        Invoice.create!(row.to_hash)
      end
    end
  end

  def import_invoice_items
    file = "#{Rails.root}/public/invoice_item.csv"
    ActiveRecord::Base.transaction do
      CSV.for_each(file, headers: true) do |row|
       InvoiceItem.create!(row.to_hash)
      end
    end
  end

  def format_phone(old_phone)
  	return " " if old_phone.nil?
  	striped_phone = old_phone.delete('()-')
  	striped_phone = striped_phone.delete(' ')
  	new_phone = number_to_phone(striped_phone, area_code: true)
  	new_phone
  end
end