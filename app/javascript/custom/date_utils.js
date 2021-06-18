//Function that sets the cutoff date for entering reports for a given year/month
export const setCutoffDate = (yr,mo)=> {
  if (mo == 12)
  {
   yr = yr +1;
   mo = 0;
  }
  
  //set new date for first of month  
  let first_of_month = new Date(yr,mo,1);
  
  //move that date to the 10
  first_of_month.setDate(10);


  let cutoff = first_of_month
  //check if the 10th is a week end or holiday and add days until
  //we fall on a business day
  while(holiday_or_weekend(cutoff)== true) 
    { 
     cutoff.setDate(cutoff.getDate()+1);
    }
  
  //return the cutoff date
  return cutoff;

}

export const holiday_or_weekend = function (dt_date){
  //Get Day of Month
  let n_date = dt_date.getDate();
  //Get Month
  let n_month = dt_date.getMonth() + 1;
  //Generate a month/date to compare
  let s_date = n_month + "/" + n_date;

  //Check if it's a week end
  if (dt_date.getDay() == 6 || dt_date.getDay() == 0) {
      return true;}
  
  //Then check for static holidays   
  if (s_date == '1/1'   // New Year
  || s_date == '7/4'    //Independence Day
  || s_date == '11/11'  //Veterans Day
  || s_date == '12/25'  //Christmas Day
  ) { return true;}

  //Calculate current weekday from the beginning of the month
  // month/week/day

  let wday = dt_date.getDay();
  let wnum = Math.floor((n_date - 1) /7 ) + 1 ;
  let s_date2 = n_month + "/" + wnum + "/" + wday;

  if (s_date2 == '1/3/1' //MLK, Third Mon in Jan
  || s_date2 == '2/3/1'  //President Day, THird Mon in Feb
  || s_date2 == '9/1/1'  //Labor Day, First Mon in Sept
  || s_date2 == '10/2/1' //Colombus Day, Second Monday in Oct
  || s_date2 == '11/4/4'  //Thanksgiving, Fourth Thursday in Nov  
  ) {return true;}

  //Get Weekday number from end of the month 
  //month/week/day
  let dt_temp = new Date (dt_date);
  dt_temp.setDate(1);
  dt_temp.setMonth(dt_temp.getMonth() + 1);
  dt_temp.setDate(dt_temp.getDate() - 1);
  wnum = Math.floor((dt_temp.getDate() - n_date - 1) / 7) + 1;
  let s_date3 = n_month + '/' + wnum + '/' + wday;

  if ( s_date3 == '5/1/1'  // Memorial Day, last Monday in May
   ) {return true;}

  //if none of the holidays returned true, we return false  
  return false;
}

export const highLight = (date) => {
  //console.log(date.toString());
  let cutoff_dates = [];

  let today_date = new Date();
  today_date.setHours(0,0,0,0);
  let tmp_year = today_date.getFullYear();
  
  for (let i = 1; i<=12; i++){
    cutoff_dates[i] = setCutoffDate(tmp_year,i);
  }

  

  for (let i = 1; i<=12; i++){
    if (cutoff_dates[i].toString() == date.toString()){
      return [true, 'ui-state-error', 'Deadline for prior month report'];
     }
  }
  
  return [true, '',''];

  
}