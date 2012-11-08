$(function() {
  $('.rules_rule_set select[name*="[lhs_parameter_key]"]').on('change', function(ev) {
    var $rawInput;
    var selectedType;

    $rawInput = $(this).parent('li').siblings('[id*="rhs_parameter_raw_input"]').find('input');
    selectedType = $(this).find(':selected').data('type');

    $rawInput.get(0).type = selectedType;
  });

    $('.rules_rule_set select[name*="[evaluator_key]"]').on('change', function(ev) {
    var $rhsInputs;
    var requiresRHS;

    $rawInputs = $(this).parent('li').siblings('[id*="rhs_parameter"]').find('input, select');
    requiresRHS = $(this).find(':selected').data('requires-rhs');

    $rawInputs.prop('disabled', !requiresRHS);
  });
});
