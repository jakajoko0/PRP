module ReportHelper

	def sort_by_number_or_name(fieldname,rowclass,labelclass,selectclass)
    html = <<-HTML
    <div class = "#{rowclass}">
    	<label class = "#{labelclass}" for="#{fieldname}">Sort By</label>
    	<div class = "#{selectclass}">
    	  <select id="#{fieldname}" class="form-control form-control-sm col" name="#{fieldname}">
 			    <option value="1">
 			      Franchise Number
 			    </option>
 			    <option value = "2">
 			  	  Last Name
 			    </option>
 			  </select>
 		  </div>
 		</div>
 		HTML
 		html.html_safe
	end

	def include_inactives(fieldname,rowclass,labelclass,selectclass)
		html = <<-HTML
		<div class = "#{rowclass}">
			<label class = "#{labelclass}" for="#{fieldname}">Include Inactives</label>
			<div class = "#{selectclass}">
				<select id = "#{fieldname}" class = "form-control form-control-sm col" name = "#{fieldname}">
					<option value = "0">
						No 
					</option>
					<option value = "1">
						Yes
					</option>
				</select>
			</div>
		</div>
		HTML
		html.html_safe
	end

	

end