module AxlsxHelper
	def set_axlsx_styles(wb)
		styles = {}
		wb.styles do |s|
		  styles[:header_title] = s.add_style sz: 18, b: true, alignment: {horizontal: :center, wrap_text: true }
		  styles[:header_title_left] = s.add_style sz: 18, b: true, alignment: {horizontal: :left, wrap_text: true }
		  styles[:header_title_right] = s.add_style sz: 18, b: true, alignment: {horizontal: :right, wrap_text: true }
		  styles[:header_left] = s.add_style alignment: {horizontal: :left}, b: true, sz: 10
		  styles[:header_center] = s.add_style alignment: {horizontal: :center}, b: true, sz: 10
		  styles[:header_right] = s.add_style alignment: {horizontal: :right}, b: true, sz: 10
		  styles[:header_box] = s.add_style sz: 12, b: true, alignment: {horizontal: :center}, border: {style: :medium, color: "00000000"}
		  styles[:header_box_left] = s.add_style sz: 12, b: true, alignment: {horizontal: :left}, border: {style: :medium, color: "00000000"}
		  styles[:header_box_right] = s.add_style sz: 12, b: true, alignment: {horizontal: :right}, border: {style: :medium, color: "00000000"}
		  styles[:data_left] = s.add_style alignment: {horizontal: :left}, sz: 10	
		  styles[:data_center] = s.add_style alignment: {horizontal: :center}, sz: 10	
		  styles[:data_right] = s.add_style alignment: {horizontal: :right}, sz: 10	
		  styles[:number] = s.add_style num_fmt: 4, sz: 10, alignment: {horizontal: :right}
		  styles[:number_box] = s.add_style num_fmt: 4, sz: 10, alignment: {horizontal: :right}, border: {style: :medium, color: "00000000"}
		  styles[:number_bold] = s.add_style num_fmt: 4, sz: 10 , b: true
		  styles[:number_fix] = s.add_style num_fmt: 3, sz: 10, alignment: {horizontal: :right}
		  styles[:number_fix_bold] = s.add_style num_fmt: 3, b: true, sz: 10, alignment: {horizontal: :right}
		  styles[:number_fix_box] = s.add_style num_fmt: 3, sz: 10, alignment: {horizontal: :right}, border: {style: :medium, color: "00000000"}
		  styles[:currency] = s.add_style num_fmt: 6, sz: 10, alignment: {horizontal: :right}
		  styles[:currency_bold] = s.add_style num_fmt: 6, b: true, sz: 10, alignment: {horizontal: :right}
  		styles[:currency_red] = s.add_style num_fmt: 40, sz: 10, alignment: {horizontal: :right}
  		styles[:currency_red_bold] = s.add_style num_fmt: 40, b: true, sz: 10, alignment: {horizontal: :right}
  		styles[:pct] = s.add_style num_fmt: 10, sz: 10, alignment: {horizontal: :right}
  		styles[:pct_bold] = s.add_style num_fmt: 10, b: true, sz: 10, alignment: {horizontal: :right}
  		styles[:pct_box] = s.add_style num_fmt: 10, sz: 10, alignment: {horizontal: :right}, border: {style: :medium, color: "00000000"}
  		styles[:pct_box_bold] = s.add_style num_fmt: 10, b: true, sz: 10, alignment: {horizontal: :right}, border: {style: :medium, color: "00000000"}
  		styles[:pct_fixed] = s.add_style num_fmt: 9, sz: 10, alignment: {horizontal: :right}
  		styles[:pct_fixed_bold] = s.add_style num_fmt: 9, b: true, sz: 10, alignment: {horizontal: :right}
  		styles[:pct_fixed_box] = s.add_style num_fmt: 9, sz: 10, alignment: {horizontal: :right}, border: {style: :medium, color: "00000000"}
  		styles[:pct_fixed_box_bold] = s.add_style num_fmt: 9, b: true, sz: 10, alignment: {horizontal: :right}, border: {style: :medium, color: "00000000"}
		end
		return styles
	end

end