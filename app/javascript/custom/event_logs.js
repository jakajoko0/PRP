
$(document).on("event_logs#index:loaded", function() {
	
  const 
  locale = gon.I18n;

  $.datepicker.setDefaults($.datepicker.regional[locale]);  

  $('#event_logs_start_date').datepicker({
    showOn: 'focus',
    changeYear: true,
    changeMonth: true
    });

  $('#event_logs_start_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");
  
  $('#event_logs_end_date').datepicker({
    showOn: 'focus',
    changeYear: true,
    changeMonth: true
    });

  $('#event_logs_end_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  
  
});



