class DateUtils
	#New Year, Independance, Veterans day, Christmas
	STATIC_HOLIDAYS = ['1/1','7/4','11/11','12/25']
	# Birthday of Martin Luther King, third Monday in January
	# Washington's Birthday, third Monday in February
  # Labor Day, first Monday in September
  # Columbus Day, second Monday in October
  # Thanksgiving Day, fourth Thursday in November
	CHANGING_HOLIDAYS = ['1/3/1','2/3/1','9/1/1','10/2/1','11/4/4']
	
	def self.find_cutoff_date
	  #Build the date as the 10th of the current month
    current_month = Date.today.month
    current_year = Date.today.year
    target_day = 10
    start_date = Date.new(current_year, current_month, target_day)

    #If the date falls on week end or holiday, we move forward one day
    #until it's a business day
    while check_week_end_holiday(start_date) == true do
      start_date = start_date+1.days
    end
    
    return start_date
  end

  def self.find_warning_date(arg_date)  #Find the date we should warn users based on cutoff date
    dayCount = 0
    #We will go back 2 days (excluding week end and holidays)
    while dayCount < 2 do 
      if check_week_end_holiday(arg_date) == false
        dayCount = dayCount +1
      end
      arg_date = arg_date-1.days
    end  

    return arg_date
  end
  
  def self.check_week_end_holiday(arg_date)
  	#First we check if it's a week end
    return true if (arg_date.saturday? || arg_date.sunday?)
    
    #Extract month, day and year of target date
    tmp_month = arg_date.month
    tmp_day = arg_date.day
    tmp_year = arg_date.year
  	
    #Then we verify simple holidays
  	s_date = tmp_month.to_s + '/' + tmp_day.to_s

    if STATIC_HOLIDAYS.include?(s_date)
      return true
    end

    #Then we check holidays that falls on specific criterias of week / weekday
    tmp_day_num = arg_date.wday   #find the week day (mon-sun)
    tmp_week = ((tmp_day.floor - 1) / 7) + 1  #Find the week depending on day of month
    #Build a string with month/week/day of week
    s_date2 = tmp_month.to_s + '/' + tmp_week.to_s + '/' + tmp_day_num.to_s

	  if CHANGING_HOLIDAYS.include?(s_date2) 
      return true
    end

    # Find the last monday in may for memorial day
    dt_temp = Date.new(tmp_year, 5, -1)
    dt_temp -= (dt_temp.wday) -1

    if dt_temp == arg_date
    	return true
    end
    
    return false

  end

		
	
end