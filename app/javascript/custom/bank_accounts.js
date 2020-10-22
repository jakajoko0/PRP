$(document).on("bank_accounts#edit:loaded bank_accounts#new:loaded bank_accounts#create:loaded bank_accounts#update:loaded", function() {

  $('#bank_account_routing').on('change', ()=> {
    routing = $('#bank_account_routing').val();
    
     $.ajax({
      url: "/bank_routings/bank_name",
      type: "GET",
      data: {routing_number: routing },
      success: function(data){
        if(data.bank_name != "NOT FOUND") {
        $('#bank_account_bank_name').val(data.bank_name);}
        else
        {
          $('#bank_account_bank_name').val("");
        }

      },
      error: function() { 
        $('#bank_account_bank_name').val("");
    }       
    });


  });

  
  });




