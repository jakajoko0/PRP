class SettlementLog < Struct.new(:trans_id, :gms_refid, :franchise, :date,  :trans_type, :amount, :paid_with, :status, :reason, :processed)
end