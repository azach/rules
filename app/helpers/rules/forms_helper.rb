module Rules
  module FormsHelper
    def rules_for(rule_set)
      render partial: 'rules/rule_set', locals: {rule_set: rule_set}
    end
  end
end