$(document).on("insurance_expiration#index:loaded", function() {
  locale = gon.I18n;
 

  $.datepicker.setDefaults($.datepicker.regional[locale]);  

  $('#target_date').datepicker({
	showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-5:+5"});

  $('#target_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

});


  


