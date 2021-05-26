class CreateEventLog
  include Interactor
  def call
    if context.log_event && !EventLog.create(event_date: DateTime.now, fran: context.event_info[:fran],
                                             lastname: context.event_info[:lastname], event_desc: context.event_info[:description], user_email: context.event_info[:user_email])
      context.fail!
    end
  end
end
