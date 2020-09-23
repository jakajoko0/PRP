class InsurancesQuery

	def initialize(relation = Insurance.all)
		@relation = relation
	end

	def insurance_expiring(target_date,sort)
		results = []
		records = @relation.includes(:franchise).where("((eo_insurance = 1 AND eo_expiration <= :target_date) OR (gen_insurance = 1 AND gen_expiration <= :target_date) OR (other_insurance = 1 AND other_expiration <= :target_date) OR (other2_insurance = 1 AND other2_expiration <= :target_date)) AND franchises.inactive = 0", target_date: target_date).order(sort)
		if records.size > 0
			records.each do |r|
				fnum = r.franchise.franchise_number
				fname = r.franchise.full_name
				fphone = r.franchise.phone
				femail = r.franchise.email

				if r.eo_insurance == 1 
					results << {franchise_number: fnum, full_name: fname, ins_type: I18n.t('reports.insurance_expiration.eo_label'), expires: r.eo_expiration, phone: fphone, email: femail }
					fnum, fname, fphone, pemail = "", "", "", ""
				end

				if r.gen_insurance == 1
					results << {franchise_number: fnum, full_name: fname, ins_type: I18n.t('reports.insurance_expiration.gen_label'), expires: r.gen_expiration, phone: fphone, email: femail }
					fnum, fname, fphone, pemail = "", "", "", ""
				end

				if r.other_insurance == 1
					results << {franchise_number: fnum, full_name: fname, ins_type: I18n.t('reports.insurance_expiration.other_label',desc: r.other_description), expires: r.other_expiration, phone: fphone, email: femail }
					fnum, fname, fphone, pemail = "", "", "", ""
				end

				if r.other2_insurance == 1
					results << {franchise_number: fnum, full_name: fname, ins_type: I18n.t('reports.insurance_expiration.other_label',desc: r.other2_description), expires: r.other2_expiration, phone: fphone, email: femail }
					fnum, fname, fphone, pemail = "", "", "", ""
				end

			end
		end
		return results
	end

	def insurance_missing(sort)
		records = @relation.includes(:franchise).where("eo_insurance = 0 AND gen_insurance = 0 AND other_insurance = 0 AND other2_insurance = 0 AND franchises.inactive = 0").order(sort)
	end

	private

	  

	
	


end