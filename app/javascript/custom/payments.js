
$(document).on("payments#index:loaded", function() {
	cardProcessing(); 
  
});

function cardProcessing() {
  let interval = setInterval(function() {

    if($('#not_processing').length){
      clearInterval(interval);
    }
    else{
    $.ajax({url: "payments/refresh_partial"})
    }
  },3000);
}


  

