module Rules
  class Engine < ::Rails::Engine
    isolate_namespace Rules

    initializer :active_admin do
      if defined? ActiveAdmin
        require 'rules/extensions/active_admin/dsl'
        ActiveAdmin.application.javascripts << 'rules/active_admin.js'
      end
    end
  end
end
