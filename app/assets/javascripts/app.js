$(document).ready(function () {

    $('.datepicker').datepicker({
//            format: "yyyy/mm/dd"
            format: "dd/mm/yyyy"
        }
    );

    $('.approval-close').click(function () {
        $(".selector_checkbox").prop('checked', false);
    });

    $('.approve-btn').click(function () {
        var input = $("<input>").attr("type", "hidden").attr("name", "supply[approval_type]").val("approve");
        $(this).closest('form').append($(input)).submit();
    });
    $('.reject-btn').click(function () {
        var input = $("<input>").attr("type", "hidden").attr("name", "supply[approval_type]").val("reject");
        $(this).closest('form').append($(input)).submit();
    });

    $('.select_all_checkboxes').click(function () {
        if ($(this).is(':checked'))
            $(this).closest('.batches_modal_table').find('.selector_checkbox').prop('checked', true);
        else
            $(this).closest('.batches_modal_table').find('.selector_checkbox').prop('checked', false);
    });

    $("[data-toggle=popover]").popover();


    //data table initializations

    $(".data_table").dataTable({
    });

    $('.active_store').change(function () {
        $(this).closest('form').submit();
    });


//    PRESCRIPTIONS START

    function total_calculation()
    {
        total = 0
        $('.prescription_qty').each(function(i, obj) {
            if(!($('#prescriptionrate_'+i).val() == "NA"))
                total += parseInt($(this).val()) * parseFloat($('#prescriptionrate_'+i).val());
        });
        $('#subtotal_value').html(total.toFixed(2));
    }

    function prescription_batch_change() {
        //        alert($(this).val())
        var store_id = $('#current_active_store').text();
        var brand_id = $(this).val();
        var selector_id = ($(this).attr('id'));
        var row_id = selector_id.split('_')[1];
//        alert(row_id);
//        $('#prescriptionrate_0').val('10');

        $.ajax({
            type: "GET",
            url: "/inventory/rate.json",
            data: { store_id: store_id, brand_id: brand_id, row_id: row_id },
            success: function (data) {
                $('#prescriptionrate_' + data["row"]).val(data["rate"]);
                $('#prescriptionqty_' + data["row"]).attr("min_dispensable", data["min_dispensable"]);
                total_calculation();
            }
        });
    }



    function prescription_qty_change() {
        if (parseInt($(this).attr('min_dispensable')) > parseInt($(this).val()))
            alert("Minimum dispensable for the selected drug is " + $(this).attr('min_dispensable'));
        else
        {
            total_calculation();
        }

    }

    $('.prescription_batch').change(prescription_batch_change);
    $('.prescription_qty').change(prescription_qty_change);

    $('#prescription_batches').bind('cocoon:after-insert',
        function () {
            $('.prescription_batch').change(prescription_batch_change);
            $('.prescription_qty').change(prescription_qty_change);
        });

});


