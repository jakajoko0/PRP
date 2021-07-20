import { setCutoffDate } from './date_utils';

$(document).on("remittances#edit:loaded remittances#new:loaded remittances#create:loaded remittances#update:loaded", function() {
   
  let locale = gon.I18n;

  //***************************************************************************************** 
  //Once the form page is loaded set the datepicker options
  //***************************************************************************************** 
  $.datepicker.setDefaults($.datepicker.regional[locale]);  

  $('#remittance_date_received').datepicker({
	  showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-10:+10"});

  $('#remittance_date_received').next('button.ui-datepicker-trigger').css("verticalAlign","middle");

  $('#remittance_date_posted').datepicker({
	  showOn: 'button',
    changeYear: true,
    changeMonth: true,
    yearRange:"-10:+10"});

  $('#remittance_date_posted').next('button.ui-datepicker-trigger').css("verticalAlign","middle");
  
  
  const report_year = parseInt($("#remittance_year").val());
  const report_month = parseInt($("#remittance_month").val());
  
  //***************************************************************************************** 
  //Evaluate if the report is late
  //***************************************************************************************** 
  
  const cutoff_date = setCutoffDate(report_year, report_month);
  const today_date = new Date();
  today_date.setHours(0,0,0,0);
  evaluateLateness(cutoff_date, today_date);

  //***************************************************************************************** 
  //Init Form With Current Values and Calculations
  //***************************************************************************************** 
  
  initForm(report_year, report_month);

  //***************************************************************************************** 
  //Place event listener on year and month change
  //***************************************************************************************** 
  $(document).on("change", '#remittance_month, #remittance_year', function()
  {
    let new_year = parseInt($('#remittance_year').val());
    let new_month = parseInt($('#remittance_month').val());
    let new_cutoff = setCutoffDate(new_year, new_month);
    let today_date = new Date();
    evaluateLateness(new_cutoff, today_date);
    evaluatePeriodExists(new_year, new_month, true);

  });

  //*****************************************************************************************
  //We want to prevent users from using Enter because it submits the form
  //However, for this particular form, we want the enter key moving from one
  //field to another so we will move to the next available field instead
  //*****************************************************************************************
  $('form input , form select').keydown(function (e) 
  { 
    if(e.keyCode == 13) {
      e.preventDefault();
      let inputs = $(this).closest('form').find('.remittance_input');
      inputs.eq(inputs.index(this)+1).focus();
      inputs.eq(inputs.index(this)+1).select();
    }

  });
  //*****************************************************************************************
  //Select Field Content for Quick modification
  //***************************************************************************************** 
  $('form input').on('focus', () =>{ 
    $(this).select();
  });

  //*****************************************************************************************
  //If Date Posted is Changed
  //***************************************************************************************** 
  $(document).on("change", "#remittance_date_posted", function() {
    let new_date = new Date($(this).datepicker({dateFormat: 'dd,MM,yyyy'}).val());
    let new_year = parseInt($('#remittance_year').val());
    let new_month = parseInt($('#remittance_month').val());
    let new_cutoff = setCutoffDate(new_year, new_month);

    evaluateLateness(new_cutoff, new_date);
    
  })

  //*****************************************************************************************
  //When a Collection Amount is Changed
  //***************************************************************************************** 
  $(document).on("change", ".collections-sum", function() {
    let new_total = getCollections();
    let royalty = calcRoyalty(new_total);

    $("#remittance_total_collect").val(new_total.toFixed(2));
    $("#remittance_calculated_royalty").val(royalty.toFixed(2));

    useProperRoyalty();
    
    recalcForm();
    
  })

  //*****************************************************************************************
  //When a Credit Amount is Changed or the Actual Royalty Amount itself
  //***************************************************************************************** 
  $(document).on("change", ".credits-sum , #remittance_royalty, #remittance_late_fees", function() {
    recalcForm();
  });

  //*****************************************************************************************
  //When the Minimum Royalty is Changed
  //***************************************************************************************** 
  $(document).on("change", "#remittance_minimum_royalty", function() {

    useProperRoyalty();

    recalcForm();

  });
  
  //*****************************************************************************************
  //When a credit type is changed
  //***************************************************************************************** 
  $(document).on("change", "#remittance_credit1 , #remittance_credit2, #remittance_credit3", function() {
    let selectedCredit = $(this).val();
    let selector = $(this).attr("id")+"_amount";
    
    handleCreditSelection(selectedCredit, selector);
    
  });

  //*****************************************************************************************
  //On Submit, we verify real quick if the collections are
  //zero, if so, we warn them but let them save anyway if they want
  //*****************************************************************************************
  
  $(document.querySelector('form')).on("submit", function() {
    
    let coll = getCollections();
    let showMsg = false;
    let msg = "";

    if(coll==0) {
      showMsg = true;
      msg = "The total collections are 0.00\r\n";
    }

    if (showMsg == true) {
      msg += "Are you sure you want to save the report in this current state?";
      let response = confirm(msg);

      if (response == true){
        return true;
      }
      else
      {
        e.preventDefault();
        return false;
      }  
    }
    else
      return true;
   
  });
});

//*****************************************************************************************
//Static Functions called by events created above
//***************************************************************************************** 

const getCollections = () => {
  let total = 0;
  $(".collections-sum").each(function(){
    if ($(this).attr('id') != "remittance_excluded")
      total += parseFloat($(this).val());
  });
  return total;
};

const getCredits = () => {
  let total = 0;
  $(".credits-sum").each(function() {
    total += parseFloat($(this).val()?$(this).val():0);
  })
  return total;
};

const getLateFees = () => {
  return parseFloat($("#remittance_late_fees").val()?$("#remittance_late_fees").val():0);
};

const calcRoyalty = (totalCollections) => {
  return totalCollections * gon.royalty_rate;
};

const recalcForm = ()=> {
  let credits = getCredits();
  let late_fees = getLateFees();
  let roy = parseFloat($("#remittance_royalty").val()?$("#remittance_royalty").val():0);
  //console.log(credits);
  //console.log(late_fees);
  //console.log(roy);
  let total_due = roy - credits + late_fees;
  $("#remittance_total_due").val(total_due.toFixed(2));
};

const useProperRoyalty = () => {
  let min_roy = parseFloat($("#remittance_minimum_royalty").val());
  let calc_roy = parseFloat($("#remittance_calculated_royalty").val());
  if (min_roy > calc_roy)
    {
      $("#remittance_royalty").val(min_roy.toFixed(2));
    }
    else
    {
      $("#remittance_royalty").val(calc_roy.toFixed(2));
    }

}

const handleCreditSelection = (selectedCredit, selector) => {
  switch(selectedCredit) {
      //if it's advanced rebate, we calculate the rebate against collections
      case '28':
        let rebate = getCollections() * (gon.rebates[0].advanced_rebate / 100);
        $('#'+selector).val(rebate.toFixed(2));
        if (gon.admin == false) {
          $('#'+selector).prop("readonly", true);
        }
        recalcForm();
        break;
      case '35':
        let bal = parseFloat(gon.rebates[0].prior_year_rebate);
        $('#'+selector).val(bal.toFixed(2));
        $('#'+selector).prop("readonly",false);
        recalcForm();
        break;
      default:
        $('#'+selector).val("0.00");
        $('#'+selector).prop("readonly",false);
        recalcForm();
        break;
    }
};

const evaluateLateness = (cutoff_date, today_date) => {
  
  if(cutoff_date < today_date)
  {
    $('#late').css("display", "block");
    $('#late_fees').css("display", "flex");
    $('#late_msg').css("display", "block");
    $('#remittance_late').val("1");
  }
  else
  {
    $('#late').css("display", "none");
    $('#late_fees').css("display", "none");
    $('#late_msg').css("display", "none");
    $('#remittance_late').val("0");
    $('#remittance_late_fees').val("0.00");
    recalcForm();

  }
}

const initForm = (report_year, report_month) => {
  //First we make sure we sum the collections
  let action = $('body').data().action;
  let new_remittance = false;

  if (action == 'new' || action == 'create')
    new_remittance = true;

  const totalCollect = getCollections();
  
  $("#remittance_total_collect").val(totalCollect.toFixed(2));

  //Then we evaluate the credit lines and disable the proper fields
  if (gon.min_royalty > 0.00) {
    $("#remittance_minimum_royalty").prop("readonly", true);
  }

  initCredits();
  
  evaluatePeriodExists(report_year, report_month, new_remittance);

  recalcForm();

}

const initCredits = () => {
  let credit1 = $("#remittance_credit1").val();
  let credit2 = $("#remittance_credit2").val();
  let credit3 = $("#remittance_credit3").val();

  if (credit1 == '28' && gon.admin == false){
    $("#remittance_credit1_amount").prop("readonly", true);
  }
  
  if (credit2 == '28' && gon.admin == false){
    $("#remittance_credit2_amount").prop("readonly", true);
  }

  if (credit3 == '28' && gon.admin == false){
    $("#remittance_credit3_amount").prop("readonly", true);
  }

}

const periodExists = (obj, year, month)=> {
  for(var i = 0; i < obj.length; i++) {
    if (obj[i].year == year && obj[i].month == month) {
      return true;
    }
  }
  
  return false;
  
}


const evaluatePeriodExists = (year, month, new_report) => {
  if(periodExists(gon.previous, year, month) == true && new_report){
    $('#period-header').removeClass("login-header");
    $('#period-header').addClass("danger-header");
    $('#period_title').html("Period (This period already exists)")
    alert("This report already exists");
  }
  else
  {
    $('#period-header').removeClass("danger-header");
    $('#period-header').addClass("login-header");
    $('#period_title').html("Period")

  }
}
