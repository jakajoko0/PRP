#This is a Structure used to collect transactions and display them in the dashboard
#Transactions include: FranchiseCredit , Receivable , CardPayment, BankPayment, CheckPayment
class ProcessingLog < Struct.new(:date_time ,:action, :items)
end