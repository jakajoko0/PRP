class TransLog < Struct.new(:trans_id,:gms_refid,:franchise, :date, :amount, :paid_with, :status)
end