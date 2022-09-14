
$(document).on("franchises_select#index:loaded", function() {
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
  


