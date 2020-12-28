$(document).on("financials#edit:loaded financials#new:loaded financials#create:loaded financials#update:loaded", function() {
  
  $('#financial_year').on('change', ()=> {
    const currentYear = parseInt($('#financial_year').val());
    
    if (financialExists(gon.previous, currentYear)) 
       $('#year_warning').html("This year already exists!").css("color", "red")
    else
      $('#year_warning').html("")

  });

  $('form input , form select').keydown(function (e) 
  { 
    if(e.keyCode == 13) {
      if (e.target.type == "submit")
      {
       return true;
      }
      else
      {
      e.preventDefault();
      let inputs = $(this).closest('form').find(':input:enabled:visible');
      inputs.eq(inputs.index(this)+1).focus();
      inputs.eq(inputs.index(this)+1).select();
      }
    }

  });

  $('form input').on('focus', () =>{ 
    $(this).select();
  });

  $(".revenue-sum").on('change', () => {
    let totalRevenues = getRevenues();
    $("#financial_total_revenues").val(totalRevenues.toFixed(2));
  });

  $(".expense-sum").on('change', () => {
    let totalExpenses = getExpenses();
    $("#financial_total_expenses").val(totalExpenses.toFixed(2));
  });
  
});

const financialExists = (historyData,targetYear) => {
  let years = historyData.map(data => data.year)
  return years.includes(targetYear);
 
}

const getRevenues = () => {
  let total = 0;
  $(".revenue-sum").each(function() {
    total += parseFloat($(this).val()?$(this).val():0);
    
  });
  return total;
}

const getExpenses = () => {
  let total = 0;
  $(".expense-sum").each(function() {
    total += parseFloat($(this).val()?$(this).val():0);
  });
  return total;
}



