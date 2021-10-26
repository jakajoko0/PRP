class StatementsQuery

  def initialize(relation = PrpTransaction.all)
  	@relation = relation
  end

  def balance_on(franchise_id, target_date)
  	debits = @relation.where(["franchise_id = ? AND date_posted <= ? AND trans_type = ?", franchise_id, target_date.to_time.end_of_day,1]).sum('amount')
    credits = @relation.where(["franchise_id = ? AND date_posted <= ? AND trans_type IN (?)", franchise_id, target_date.to_time.end_of_day,[2,3]]).sum('amount')
    return debits - credits
  end

  def statement_activity(franchise_id, start_date, end_date)
  	@relation.where("franchise_id = ? AND date_posted >= ? AND date_posted <= ?", franchise_id, start_date.to_time.beginning_of_day, end_date.to_time.end_of_day)
  	.order("date_posted ASC, trans_type ASC, id ASC")
  end
end  