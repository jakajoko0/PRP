
$(document).on("audit_trail_report#index:loaded", function() {
	
  const 
  locale = gon.I18n;

  $.datepicker.setDefaults($.datepicker.regional[locale]);  

  $('#start_date').datepicker({
    showOn: 'button',
    changeYear: true,
    changeMonth: true
    });

  $('#start_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");
  
  $('#end_date').datepicker({
    showOn: 'button',
    changeYear: true,
    changeMonth: true
    });

  $('#end_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  
  
});



