import { highLight } from './date_utils';

$(document).on("bank_payments#edit:loaded bank_payments#new:loaded bank_payments#create:loaded bank_payments#update:loaded", function() {
	
  const 
  locale = gon.I18n;

  $.datepicker.setDefaults($.datepicker.regional[locale]);  

  $('#bank_payment_payment_date').datepicker({
    showOn: 'button',
    changeYear: true,
    changeMonth: true,
    beforeShowDay: highLight
    });

  $('#bank_payment_payment_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  
  
});



