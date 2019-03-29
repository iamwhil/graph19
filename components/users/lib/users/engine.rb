module Users
  class Engine < ::Rails::Engine
    isolate_namespace Users

    # allows migrations to be accessible at root
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    class << self

      # ConcernDirectory uses this array to determine which concerns to include
      def inclusions
        [
          Users::Concerns::Post,
          Users::Concerns::PostTypeFields
        ]
      end

    end

  end
end
