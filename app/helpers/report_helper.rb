module ReportHelper

	def sort_by_number_or_name(fieldname,rowclass,labelclass,selectclass,options)
  option_text = "<select id='#{fieldname}' class='form-control form-control-sm col' name='#{fieldname}'>"
  options.each do |value,text|
  	option_text += "<option value ='#{value}'>#{text}</option>"
  end
  option_text += "</select>"


    html = <<-HTML
    <div class = "#{rowclass}">
    	<label class = "#{labelclass}" for="#{fieldname}">#{I18n.t('reports.general.sort_by')}</label>
    	<div class = "#{selectclass}">
    		#{option_text}
 		  </div>
 		</div>
 		HTML
 		html.html_safe
	end

	def include_inactives(fieldname,rowclass,labelclass,selectclass)
		html = <<-HTML
		<div class = "#{rowclass}">
			<label class = "#{labelclass}" for="#{fieldname}">#{I18n.t('reports.general.inc_inactives')}</label>
			<div class = "#{selectclass}">
				<select id = "#{fieldname}" class = "form-control form-control-sm col" name = "#{fieldname}">
					<option value = "0">
						#{I18n.t('reports.general.choice_no')}
					</option>
					<option value = "1">
						#{I18n.t('reports.general.choice_yes')}
					</option>
				</select>
			</div>
		</div>
		HTML
		html.html_safe
	end

	def month_and_year_dropdowns(labelname,monthfield, yearfield, rowclass, monthlabelclass, monthselectclass, yearselectclass)
		html = "<div class = '#{rowclass}'>"
		html += "<label class = '#{monthlabelclass}' for=#{monthfield}>#{labelname}</label>"
		html += "<div class = '#{monthselectclass}'>"
		html += select_month(Date.today, {prefix: "#{monthfield}", field_name:'selected_month'}, {class: 'form-control form-control-sm col'})
		html += '</div>'
		html += "<div class = '#{yearselectclass}'>"
		html += select_year(Date.today, {start_year: Date.today.year, end_year: Date.today.year+10, prefix: "#{yearfield}", field_name: 'selected_year' }, {class: 'form-control form-control-sm col'})
		html += '</div>'
		html += '</div>'
		html.html_safe
	end

	def date_argument(labelname,fieldname,rowclass,labelclass,fieldclass)
	  html = <<-HTML
		<div class = "#{rowclass}">
			<label class = "#{labelclass}" for="#{fieldname}">#{labelname}</label>
			<div class = "#{fieldclass}">
				<input id = "#{fieldname}" class = "form-control form-control-sm col text-center" name = "#{fieldname}" style="display:inline-block; vertical-align: middle; width: 65%; margin: 0 5px 0 0;">
			</div>
		</div>
		HTML
		html.html_safe
	end
	
end

	

