class PrpTransactionsQuery

	def initialize(relation = PrpTransaction.all)
		@relation = relation
	end

	def latest_roy_trans(franchise_id)
		sql = <<-SQL
		  SELECT prp_transactions.id as id,
		  prp_transactions.date_posted as date_posted,
		  prp_transactions.trans_type as trans_type,
		  prp_transactions.trans_code as trans_code,
		  prp_transactions.trans_description as trans_description,
		  prp_transactions.amount as amount,
		  prp_transactions.transactionable_type as transactionable_type,
		  prp_transactions.transactionable_id as transactionable_id,
		  0.00 as balance
		  FROM prp_transactions
		  WHERE prp_transactions.franchise_id = ?
		  AND (( prp_transactions.trans_type = 1 AND prp_transactions.transactionable_type != 'Invoice' )
		  OR ( prp_transactions.trans_type = 2 ))
		  UNION
		  SELECT prp_transactions.id as id,
		  prp_transactions.date_posted as date_posted,
		  prp_transactions.trans_type as trans_type,
		  prp_transactions.trans_code as trans_code,
		  prp_transactions.trans_description as trans_description,
		  prp_transactions.amount as amount,
		  prp_transactions.transactionable_type as transactionable_type,
		  prp_transactions.transactionable_id as transactionable_id,
		  0.00 as balance
		  FROM prp_transactions INNER JOIN payments ON prp_transactions.transactionable_id = payments.id 
		  WHERE prp_transactions.franchise_id = ?
		  AND prp_transactions.trans_type = 3
		  AND payments.invoice_payment = 0
		  ORDER BY date_posted ASC , trans_type ASC, id ASC
		SQL
		puts "FRANCHISE ID: #{franchise_id}"
		trans = PrpTransaction.find_by_sql([sql, franchise_id, franchise_id]).last(5)

		bal = FranchisesQuery.new.get_royalty_balance(franchise_id) 

		trans.reverse.each do |t| 
			t.balance = bal
			if t.trans_type == "credit" || t.trans_type == "payment"
				bal = bal + t.amount
			else
				bal = bal - t.amount
			end
	  end

	  trans

	end

	def latest_inv_trans(franchise_id)
		sql = <<-SQL
		  SELECT prp_transactions.id as transaction_id,
		  prp_transactions.date_posted as date_posted,
		  prp_transactions.trans_type as trans_type,
		  prp_transactions.trans_code as trans_code,
		  prp_transactions.trans_description as trans_description,
		  prp_transactions.amount as amount,
		  prp_transactions.transactionable_type as transactionable_type,
		  prp_transactions.transactionable_id as transactionable_id,
		  0.00 as balance
		  FROM prp_transactions
		  WHERE prp_transactions.franchise_id = ?
		  AND ( prp_transactions.trans_type = 1 AND prp_transactions.transactionable_type = 'Invoice' )
		  UNION
		  SELECT prp_transactions.id as transaction_id,
		  prp_transactions.date_posted as date_posted,
		  prp_transactions.trans_type as trans_type,
		  prp_transactions.trans_code as trans_code,
		  prp_transactions.trans_description as trans_description,
		  prp_transactions.amount as amount,
		  prp_transactions.transactionable_type as transactionable_type,
		  prp_transactions.transactionable_id as transactionable_id,
		  0.00 as balance
		  FROM prp_transactions INNER JOIN payments ON prp_transactions.transactionable_id = payments.id 
		  WHERE prp_transactions.franchise_id = ?
		  AND prp_transactions.trans_type = 3
		  AND payments.invoice_payment = 1
		  ORDER BY date_posted ASC , trans_type ASC, transaction_id ASC
		SQL

		trans = PrpTransaction.find_by_sql([sql, franchise_id, franchise_id]).last(5)

		bal = FranchisesQuery.new.get_invoice_balance(franchise_id) 

		trans.reverse.each do |t| 
			t.balance = bal
			if t.trans_type == "payment"
				bal = bal + t.amount
			else
				bal = bal - t.amount
			end
	  end

	  trans

	end

	def trans_code_summary(start_date, end_date, franchise)
	  if franchise == -1 
      where_clause = ["date_posted >= ? AND date_posted <= ?",start_date, end_date]
    else
      where_clause = ["date_posted >= ? AND date_posted <= ? AND franchise_id = ?",start_date, end_date, franchise]
    end
    @relation.joins("INNER JOIN transaction_codes ON transaction_codes.code = prp_transactions.trans_code").select("prp_transactions.trans_code as code, transaction_codes.description as desc, sum(prp_transactions.amount) as total").where(where_clause).group("prp_transactions.trans_code, transaction_codes.description").order("prp_transactions.trans_code")

	end

	def trans_code_detail(start_date, end_date, franchise, code)
		if franchise == -1 
			where_clause = ["date_posted >= ? AND date_posted <= ? AND trans_code = ?", start_date, end_date, code]
		else
		  where_clause = ["date_posted >= ? AND date_posted <= ? AND prp_transactions.franchise_id = ? AND trans_code = ?", start_date, end_date, franchise, code]
		end
		if franchise == -1
		  @relation.includes(:franchise).where(where_clause).order("date_posted ASC") 
		else
			@relation.where(where_clause).order("date_posted ASC") 
		end
	end
end