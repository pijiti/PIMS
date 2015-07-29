$(document).ready(function(){

    $('.supply .link-batches').click(function(){
        $(this).closest('.supply').find('.batches').toggleClass('hide')    ;
        return false;
    })  ;

//    $('.qty_batch').click(function(){
//        var rate = $(this).closest('.nested-fields').find('.rate_batch').ParseInt();
//        var qty  = $(this).closest('.nested-fields').find('.qty_batch').ParseInt();
//        if(rate && qty)
//            $(this).closest('.nested-fields').find('.batch_units').html(rate *)
//        return false;
//    })  ;



});