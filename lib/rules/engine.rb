module Rules
  class Engine < ::Rails::Engine
    isolate_namespace Rules

    initializer :active_admin do |app|
      if defined? ActiveAdmin
        require 'rules/extensions/active_admin/dsl'
        ActiveAdmin.application.javascripts << 'rules/active_admin.js'
        app.config.assets.precompile << 'rules/active_admin.css'
        ActiveAdmin.application.stylesheets['rules/active_admin.css'] = { media: :all }
      end
    end
  end
end
