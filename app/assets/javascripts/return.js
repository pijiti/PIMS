$(document).ready(function() {
  $(".return_prescription_qty").change(function(){
    //  validation
      if (parseInt($(this).attr('min_dispensable')) > parseInt($(this).val()))
          alert("Minimum dispensable for the selected drug is " + $(this).attr('min_dispensable'));
      else if((parseInt($(this).val()) % parseInt($(this).attr('min_dispensable'))) != 0)
      {
          alert("Drugs must be dispensed in multiples of " + $(this).attr('min_dispensable'));
      }

    var field_value, i, tot_qty, batch_rate, tot_amount;
    tot_qty = 0;
    tot_amount = 0.0;
    var total_batches = $('.return_prescription_qty').last().attr('id').split("_")[2];
    total_batches = parseInt(total_batches);
    for(i = 1;i <= total_batches;i++){
      $(".prescriptionqty_"+i).each(function(index){
        // console.log(index + " " + $(this).val());
        field_value = null ? 0 : ($(this).val() || 0);
        tot_qty += parseInt(field_value);
      });
      batch_rate = $(".prescription_batch_"+i+"_rate").val();
      batch_rate = parseFloat(batch_rate);
      $(".prescription_batch_"+i+"_qty").val(tot_qty);
      // console.log("batch " + i + ":" + tot_qty);
      // console.log("batch_rate " + i + ":" + batch_rate);
      tot_qty = parseFloat(tot_qty);
      tot_amount += (tot_qty * batch_rate);
      tot_qty = 0;      
    }
    if (tot_amount > 0) {
        $('.issue_refund_btn').removeAttr('disabled');
      } else {
        $('.issue_refund_btn').attr('disabled', 'disabled');
      }
    $('.total_refund_amount').val(tot_amount.toFixed(2));
    $('h5.total_refund_amount').text("N "+tot_amount.toFixed(2));
  });


});