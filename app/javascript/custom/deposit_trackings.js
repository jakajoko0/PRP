$(document).on("deposit_trackings#edit:loaded deposit_trackings#new:loaded deposit_trackings#create:loaded deposit_trackings#update:loaded", function() {
 
  locale = gon.I18n;

  $.datepicker.setDefaults($.datepicker.regional[locale]);  

    $('#deposit_tracking_deposit_date').datepicker({
  showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-10:+10"});

  $('#deposit_tracking_deposit_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  
  
});



