$(document).on("statements#index:loaded", function() {
	
  const locale = gon.I18n;

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
  
  $('#franchise').change(function(){
  $.get("/admins/statement_date", function(data,status,xhr){
       fr_date = eval(data);
       

       $("#start_date").val(fr_date);
       $("#end_date").val('');
        }       );
});
  
  
});



