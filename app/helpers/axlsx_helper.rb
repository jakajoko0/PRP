module AxlsxHelper
	def set_axlsx_styles(wb)
		styles = {}
		wb.styles do |s|
		  styles[:header_title] = s.add_style sz: 18, b: true, alignment: {horizontal: :center, wrap_text: true }
		  styles[:header_left] = s.add_style alignment: {horizontal: :left}, b: true, sz: 10
		  styles[:header_center] = s.add_style alignment: {horizontal: :center}, b: true, sz: 10
		  styles[:header_right] = s.add_style alignment: {horizontal: :right}, b: true, sz: 10
		  styles[:data_left] = s.add_style alignment: {horizontal: :left}, sz: 10	
		  styles[:data_center] = s.add_style alignment: {horizontal: :center}, sz: 10	
		  styles[:data_right] = s.add_style alignment: {horizontal: :right}, sz: 10	
		  styles[:number] = s.add_style num_fmt: 4, sz: 10, alignment: {horizontal: :right}
		  styles[:currency] = s.add_style num_fmt: 6, sz: 10, alignment: {horizontal: :right}
  		styles[:pct] = s.add_style num_fmt: 9, sz: 10, alignment: {horizontal: :right}
  		styles[:number_bold] = s.add_style num_fmt: 4, sz: 10 , b: true
		end
		return styles
	end

end