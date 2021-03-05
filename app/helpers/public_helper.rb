module PublicHelper
	def difference_arrow(style)
		case style
		when "green"
	    span_tag = <<-HTML
	    <span style="color:green">&#9650;</span>
	    HTML
	  when "red"  
	  	span_tag = <<-HTML 
	  	<span style="color:red">&#9660;</span>
	  	HTML
	  end
	  span_tag.html_safe
	end
end
