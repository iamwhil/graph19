module Blog
  class Engine < ::Rails::Engine
    isolate_namespace Blog

    # allows migrations to be accessible at root
    initializer :append_migrations do |app|

      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    initializer :find_concerns do |app|
      require 'byebug'

      ::Booter.app.components.each do |component|
        app.config.eager_load_paths += Dir["#{Rails.root}/components/#{component.name}/app/models/*/*.rb"]
      end

      ::Booter.app.components.each do |component|
        Rails.application.reloader do 
          Dir["#{Rails.root}/components/#{component}/app/models/*/*.rb"].each {|file| require_dependency file} 
        end
      end

      ::Booter.app.components.each do |component|
        "#{component.name.camelize}::ApplicationRecord".constantize.descendants.each do |descendant|
          ::ConcernDirectory.inclusions(descendant).each{ |ext| descendant.include ext }
        end
      end
    end

    config.generators do |g| 
      g.test_framework :rspec
    end
    
  end
end
