class ConcernDirectory

  class << self

    def inclusions(klass)
      lookup(:inclusions, klass)
    end

    def prepends(klass)
      lookup(:prepends, klass)
    end

    private

      def lookup(key, klass)
        return [] if Rails.env.test?

        klass_name = klass.to_s
        concern_directory[key][klass_name] || []
      end

      def concern_directory
        @concern_directory ||= app_directory.inject({}) do |summ, comp|
          summ[:inclusions] ||= {}
          summ[:prepends] ||= {}

          (comp.engine.try(:inclusions) || []).each do |klass|
            root = klass::ROOT

            summ[:inclusions][root] ||= []
            summ[:inclusions][root] << klass
          end

          (comp.engine.try(:prepends) || []).each do |klass|
            root = klass::ROOT
            summ[:prepends][root] ||= []
            summ[:prepends][root] << klass
          end

          summ
        end
      end

      def app_directory
        Booter.app.components.reverse
      end

  end

end
