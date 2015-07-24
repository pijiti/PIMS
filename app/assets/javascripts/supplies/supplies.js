$(document).ready(function(){

    $('.supply .link-batches').click(function(){
        $(this).closest('.supply').find('.batches').toggleClass('hide')    ;
        return false;
    })

});