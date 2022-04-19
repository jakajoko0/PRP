class FranchiseStatsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false 

  def perform

    current_year = Date.today.year
    current_month = Date.today.month
    Franchise.all.each do |franchise|
      franchise.calculate_total_averages(current_month,current_year)
      franchise.save
    end
  
    
  end	


end

    

