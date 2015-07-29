$(document).ready(function(){

    $('.datepicker').datepicker({
//            format: "yyyy/mm/dd"
           format: "dd/mm/yyyy"
        }
    );

    $('.approval-close').click(function(){
        $(".selector_checkbox").prop('checked',false);
    });

    $('.approve-btn').click(function(){
        var input = $("<input>").attr("type", "hidden").attr("name" , "supply[approval_type]").val("approve");
        $(this).closest('form').append($(input)).submit();
    });
    $('.reject-btn').click(function(){
        var input = $("<input>").attr("type", "hidden").attr("name" , "supply[approval_type]").val("reject");
        $(this).closest('form'). append($(input)).submit();
    });
});


