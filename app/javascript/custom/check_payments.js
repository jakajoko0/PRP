import { highLight } from './date_utils';

$(document).on("check_payments#edit:loaded check_payments#new:loaded check_payments#create:loaded check_payments#update:loaded", function() {
	
  const 
  locale = gon.I18n;

  $.datepicker.setDefaults($.datepicker.regional[locale]);  

  $('#check_payment_date_entered').datepicker({
    showOn: 'button',
    changeYear: true,
    changeMonth: true,
    beforeShowDay: highLight
    });

  $('#check_payment_date_entered').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

    $('#check_payment_date_approved').datepicker({
    showOn: 'button',
    changeYear: true,
    changeMonth: true,
    beforeShowDay: highLight
    });

  $('#check_payment_date_approved').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  
  
});



