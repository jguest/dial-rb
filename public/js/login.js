$(function() {

    var $numberInput = $("#number-input"),
        oldVal = $numberInput.val();

    $numberInput.focus().val('').val(oldVal);

});
