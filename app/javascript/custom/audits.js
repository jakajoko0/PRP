
$(document).on("audits#index:loaded", function() {
	
  const 
  locale = gon.I18n;

  $.datepicker.setDefaults($.datepicker.regional[locale]);  

  $('#audits_start_date').datepicker({
    showOn: 'focus',
    changeYear: true,
    changeMonth: true
    });

  $('#audits_start_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");
  
  $('#audits_end_date').datepicker({
    showOn: 'focus',
    changeYear: true,
    changeMonth: true
    });

  $('#audits_end_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  
  
});



