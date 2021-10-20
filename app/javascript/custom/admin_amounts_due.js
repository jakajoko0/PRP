$(document).on("amounts_due#index:loaded", function() {
	
  const locale = gon.I18n;

  $.datepicker.setDefaults($.datepicker.regional[locale]);  

  $('#target_date').datepicker({
    showOn: 'button',
    changeYear: true,
    changeMonth: true
    });

  $('#target_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");
  
  
});



