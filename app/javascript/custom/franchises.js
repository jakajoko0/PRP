$(document).on("franchises#edit:loaded franchises#new:loaded franchises#create:loaded franchises#update:loaded", function() {
  locale = gon.I18n;

  $.datepicker.setDefaults($.datepicker.regional[locale]);  

  $('#franchise_start_date').datepicker({
	showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-60:+1"});

  $('#franchise_start_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  $('#franchise_renew_date').datepicker({
	showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-10:+30"});

  $('#franchise_renew_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  $('#franchise_term_date').datepicker({
	showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-10:+30"});

  $('#franchise_term_date').next('button.ui-datepicker-trigger').css("verticalAlign","middle");
  
  $('#franchises_add_item_button').on ("click", function(e)
  {
    
   
   time = new Date().getTime();
   regexp = new RegExp($(this).data('id'), 'g');
   $(this).before($(this).data('fields').replace(regexp,time)) ;
  
   e.preventDefault();
   
  });

  $(document).on ("click" , ".remove_items", function(e)
  {
   $(this).prev('input[type=hidden]').val('1');
   $(this).closest('fieldset').hide();
   e.preventDefault();
   
  });

  });

$(document).on("franchises#index:loaded", function() {
  $("#franchise_search input[type=text]").keyup(function() 
    {
    $.get($("#franchise_search").attr("action"), $("#franchise_search").serialize()+"&destination="+gon.destination,  null, "script");
    return false;
  });

$("#franchise_search input[type=checkbox]").on('change', function() { 
      $.get($("#franchise_search").attr("action"), $("#franchise_search").serialize()+"&destination="+gon.destination,  null, "script");
      return false;
    })

});



