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

    function subtotal_calculation() {
        sub_total = 0;
        $('.prescription_qty').each(function (i, obj) {
            //Do not calculate if rate is NA or prescription qty is blank
            var selector_id = ($(obj).attr('id'));
            var row_id = selector_id.split('_')[1];
            if (($('#prescriptionrate_' + row_id).val() != "NA") && $('#prescriptionqty_' + row_id).val() != '') {
                sub_total += parseInt($(this).val()) * parseFloat($('#prescriptionrate_' + row_id).val());
                $('#subtotal_value').html(sub_total.toFixed(2));
            }
        });
        return parseFloat(sub_total.toFixed(2));
    }

    function total_calculation() {
        sub_total = 0;
        surcharge = 0;
        total = 0;
        $.ajax({
            type: "GET",
            url: "/surcharges/active.json",
            success: function (data) {

                sub_total = subtotal_calculation();

                if (data["name"]) {
                    surcharge_total = data["total"];
                    //calculate based on percent
                    if (data["charge_type"] != "Fixed") {
                        surcharge = parseFloat((sub_total * parseFloat(surcharge_total) * 0.01).toFixed(2));
                    }
                    else {
                        surcharge = surcharge_total;

                    }
                    $('#surcharges').html("<strong>" + data["name"] + "</strong> <i>" + surcharge + "</i>");
                }
                total = surcharge + sub_total;
                $('#grand_total').html("<strong>Total</strong> <i>" + total + "</i>");

            }
        });


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
        else {
            total_calculation();
        }

    }

    $('.prescription_batch').change(prescription_batch_change);
    $('.prescription_qty').change(prescription_qty_change);

    $('#prescription_batches').bind('cocoon:after-insert',
        function (e, prescription_batch) {
            new_id = new Date().getTime();
            $('.prescription_batch').change(prescription_batch_change);
            $('.prescription_qty').change(prescription_qty_change);
            prescription_batch.find('.prescription_batch').attr('id', 'prescriptionbatch_' + new_id);
            prescription_batch.find('.prescription_rate').attr('id', 'prescriptionrate_' + new_id);
            prescription_batch.find('.prescription_qty').attr('id', 'prescriptionqty_' + new_id);

        });

    $('#prescription_batches').on("cocoon:after-remove", function () {
        total_calculation();
    });

});


