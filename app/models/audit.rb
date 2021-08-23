Audit = Audited.audit_class

class Audit
  scope :for_actions, lambda { |acts| where(action: acts) if !acts.blank?}
  scope :from_date, lambda { |target_date| where("created_at >= ?", target_date) if !target_date.blank? }
  scope :to_date, lambda { |target_date| where("created_at <= ?", target_date) if !target_date.blank? }
  scope :for_resource, lambda { |resource| where("auditable_type = ?", resource) if !resource.blank?}
 
  def target_franchise
    #First we try to get the record and franchise
    res = auditable_type.constantize.find_by(id: auditable_id)
    
    if res
      if auditable_type == "Franchise"
        return res.number_and_name
      else
        return res.franchise.number_and_name
      end
    end

    #if not, we try to check from the user
    user.try(:franchise).try(:number_and_name) || "UNAVAILABLE"
  end

end