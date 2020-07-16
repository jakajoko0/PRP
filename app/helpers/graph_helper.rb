module GraphHelper
	def all_royalties_by_month(arg_year)
	  line_chart all_royalties_by_month_charts_path(target_year: arg_year),
	  height: '300px',
	  width: '100%',
	  colors: ["#002b7f","#7fba00"],
	  decimal: ".",
	  thousands: " ",
	  title: "Total Royalties by Month",
	  library: {
	  	chart: {backgroundColor: 'transparent'},
	  	legend:{position: 'bottom'},
	  	xAxis: {title: {text: "Month"}},
	  	yAxis: {tickAmount: 5}
	  }
	end
end