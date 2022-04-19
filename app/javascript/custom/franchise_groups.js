$(document).on("franchise_group_masters#edit:loaded franchise_group_masters#new:loaded franchise_group_masters#create:loaded franchise_group_masters#update:loaded", function() {
 
  $('#franchise_group_add_item_button').on ("click", function(e)
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



