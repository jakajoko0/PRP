$(document).on("insurances#edit:loaded insurances#new:loaded insurances#create:loaded insurances#update:loaded", function() {
  locale = gon.I18n;


  $.datepicker.setDefaults($.datepicker.regional[locale]);  

  $('#insurance_eo_expiration').datepicker({
	showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-60:+1"});

  $('#insurance_eo_expiration').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  $('#insurance_gen_expiration').datepicker({
	showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-60:+1"});

  $('#insurance_gen_expiration').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  $('#insurance_other_expiration').datepicker({
  showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-60:+1"});

  $('#insurance_other_expiration').next('button.ui-datepicker-trigger').css("verticalAlign","middle");
 
  
  });


$(document).on("insurances#index:loaded", function() {
  $("#insurance_search input").keyup(function() 
    {
    $.get($("#insurance_search").attr("action"), $("#insurance_search").serialize(),  null, "script");
    return false;
  });

});

  


