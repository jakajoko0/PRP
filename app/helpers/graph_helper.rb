module GraphHelper
	def all_royalties_by_month(target_year)
	  line_chart all_royalties_by_month_charts_path(target_year: target_year),
	  height: '300px',
	  width: '100%',
	  colors: ["#00143c","#80c389"],
	  decimal: ".",
	  thousands: " ",
	  title: I18n.t('dashboard.admin.total_royalties_by_month'),
	  library: {
	  	chart: {backgroundColor: 'transparent'},
	  	legend:{position: 'bottom'},
	  	xAxis: {title: {text: (I18n.t('dashboard.admin.month'))}},
	  	yAxis: {tickAmount: 6}
	  }
	end

	def collections_by_month(target_year)
	  line_chart collections_by_month_charts_path(target_year: target_year),
	  height: '300px',
	  width: '100%',
	  colors: ["#00143c","#80c389"],
	  decimal: ".",
	  thousands: " ",
	  title: I18n.t('dashboard.user.collections_by_month'),
	  library: {
	  	chart: {backgroundColor: 'transparent'},
	  	legend:{position: 'bottom'},
	  	xAxis: {title: {text: (I18n.t('dashboard.admin.month'))}},
	  	yAxis: {tickAmount: 6}
	  }
	end



	def revenue_by_state(target_year,target_month)
		geo_chart revenue_by_state_charts_path(target_year: target_year, target_month: target_month),
		library: {
		  magnifyingGlass: {enable: true,
			                 zoomFactor: 7.5},
			region: 'US',
			resolution: 'provinces',
			displayMode: 'region',
			colorAxis: {colors: ['#99aacb','#002b7f']},
			legend: {textstyle:{ color: '#002b7f',
			         fontsize: 16}}
			},
		adapter: "google"

	end

	def collections_by_category(target_year, target_month)
		data = collections_by_category_charts_path(target_year: target_year, target_month: target_month)
		pie_chart data,
		donut: true,
    colors: ['#ffa100','#80c389','#8b75cc',
    	'#05abc6', '#b0c3ff','#00143c','#3768d1',
      	      '#c70039'], 
	  library: {
	    plotOptions:{
	      pie: {
		      dataLabels: {enabled: false},
		      showInLegend: true
		    }
		  } 
		}
	end
end