$(document).on("invoices#edit:loaded invoices#new:loaded invoices#create:loaded invoices#update:loaded", function() {
 
  locale = gon.I18n;

  $.datepicker.setDefaults($.datepicker.regional[locale]);  

    $('#invoice_date_entered').datepicker({
  showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-10:+10"});

  $('#invoice_date_entered').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  $('#invoices_add_item_button').on ("click", function(e)
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

  $(document).on ("click" , ".add_item", function(e)
    {
      alert("TAbarnack");
      const lastId = document.querySelector("#fieldsetContainer").lastElementChild.id
      const newId = parseInt(lastId, 10) + 1;    
      const newFieldset = document
                          .querySelector('[id="0"]')
                          .outerHTML
                          .replace(/0/g,newId)    
      document.querySelector("#fieldsetContainer").insertAdjacentHTML(
      "beforeend", newFieldset);
      e.preventDefault();
  });
  
  
});



