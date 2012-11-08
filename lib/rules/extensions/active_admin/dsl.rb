ActiveAdmin::FormBuilder.class_eval do
  def has_rules
    inputs 'Rules' do
      semantic_fields_for :rule_set do |rules_rule_set_form|
        rules_rule_set_form.has_many :rules do |rules_rule_form|
          rules_rule_form.input :lhs_parameter_key, :label => 'Left hand side', collection: rules_parameter_collection(object.rule_set)
          rules_rule_form.input :evaluator_key, :label => 'Evaluator', :as => :select, :collection => Rules.evaluators.map {|key, evaluator| [evaluator.name, key, {:'data-requires-rhs' => evaluator.requires_rhs?}] }.sort_by {|name, key| name }
          rules_rule_form.input :rhs_parameter_raw, :label => 'Enter a value', :wrapper_html => { :class => "rules_rhs_parameter" }
          rules_rule_form.input :rhs_parameter_key, :label => 'Or choose a value', collection: rules_parameter_collection(object.rule_set), :wrapper_html => { :class => "rules_rhs_parameter" }
        end
        rules_rule_set_form.input :evaluation_logic, :as => :select, :label => 'Must match', collection: [['All Rules', 'all'], ['Any Rules', 'any']]
      end
    end
  end

  def rules_parameter_collection(rule_set)
    @rules_parameter_collection ||= Rules.constants.merge(rule_set.try(:attributes) || {}).map {|key, const| [const.name, key, {:'data-type' => const.try(:type) || 'string'}] }
  end
end

ActiveAdmin::Views::Pages::Show.class_eval do
  def show_rules
    panel "Rules" do
      div resource.rule_set.evaluation_logic == 'any' ? 'Must match any rule' : 'Must match all rules'
      table_for resource.rule_set.rules do |rule|
        column('Left hand side') { |rule| rule.lhs_parameter.to_s }
        column('Condition') { |rule| rule.evaluator }
        column('Right hand side') { |rule| rule.rhs_parameter.to_s }
      end
    end
  end
end
