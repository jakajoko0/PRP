class EventLogsQuery

	def initialize(relation = EventLog.all)
		@relation = relation
	end


	def for_email(email)
		puts email.blank?
    if !email.blank?
		  @relation.where(user_email: email)
    end
    @relation
	end

	def from_date(start_date)
		puts start_date.blank?
    if !start_date.blank?
      start_date = Date.strptime(start_date, I18n.translate('date.formats.default'))
		  @relation.where("event_date >=?",start_date)
    end
    @relation
	end

	def to_date(end_date)
		puts end_date.blank?
    if !end_date.blank?
      end_date = Date.strptime(end_date, I18n.translate('date.formats.default'))
		  @relation.where("event_date <=?",end_date)
    end
    @relation
	end

  def for_franchise(fran)
  	puts fran.blank?
    if !fran.blank?
      @relation.where(fran: fran)
    end
    @relation
  end



end