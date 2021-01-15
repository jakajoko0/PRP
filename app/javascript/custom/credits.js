$(document).on("credits#edit:loaded credits#new:loaded credits#create:loaded credits#update:loaded", function() {
  locale = gon.I18n;


  $.datepicker.setDefaults($.datepicker.regional[locale]);  

  $('#prp_transaction_date_posted').datepicker({
	showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-10:+10"});

  $('#prp_transaction_date_posted').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

 
  
  });



  


