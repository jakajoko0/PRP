$(document).on("website_preferences#edit:loaded website_preferences#new:loaded website_preferences#create:loaded website_preferences#update:loaded", function() {
  locale = gon.I18n;


  $.datepicker.setDefaults($.datepicker.regional[locale]);  

  $('#website_preference_created_at').datepicker({
	  showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-10:+10"});

  $('#website_preference_created_at').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  let paymentType = $('#website_preference_payment_method').val()  ;
  if (paymentType == 'ach') {
    $('#bank_tokens').show();
    $('#card_tokens').hide();
  }
  else {
    $('#bank_tokens').hide();
    $('#card_tokens').show();

  }

  $('#website_preference_payment_method').on('change', ()=> {
    let paymentType =   $('#website_preference_payment_method').val();
    
    if (paymentType == 'ach') {
      $('#bank_tokens').show();
      $('#card_tokens').hide();
      $('#website_preference_card_token').val('');
    }
    else {
      $('#bank_tokens').hide();
      $('#card_tokens').show();
      $('#website_preference_bank_token').val('');
    }

   });
  
  });



  


