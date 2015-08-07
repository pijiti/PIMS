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

    $('.select_all_checkboxes').click(function(){
        if($(this).is(':checked'))
            $(this).closest('.batches_modal_table').find('.selector_checkbox').prop('checked', true);
        else
            $(this).closest('.batches_modal_table').find('.selector_checkbox').prop('checked', false);
    });

    $("[data-toggle=popover]").popover();


});


