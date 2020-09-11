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

	
end

	

