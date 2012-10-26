ActiveAdmin::FormBuilder.class_eval do
  def has_rules(contexts = {})
    self.inputs 'Rules' do
      self.semantic_fields_for :rule_set do |rules_rule_set_form|
        rules_rule_set_form.has_many :rules do |rules_rule_form|
          rules_rule_form.input :lhs_parameter, :label => 'Left hand side', :collection => Rules.constants.map {|key, const| [const.name, key] }.sort_by {|name, key| name}
          rules_rule_form.input :evaluator, :as => :select, :collection => Rules.evaluators.map {|key, evaluator| [evaluator.name, key] }.sort_by {|name, key| name }
          rules_rule_form.input :rhs_parameter, :label => 'Right hand side'
        end
      end
    end
  end
end