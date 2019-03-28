class Booter

  APPS = {
    graph19: {
      root: 'graph19',
      components: %w(blog users)
    }
  }.freeze

  class << self

    def app
      @app ||= BootRoot.new(boot_flag, APPS[boot_flag])
    end

    def boot_flag
      @boot_flag ||= (ENV['GRAPH19_APP'] || 'graph19').to_sym
    end

  end
end

class BootRoot
  ROOTS = %w(graph19)

  def initialize(name, opts)
    @name = name
    @opts = opts
  end

  def components
    @components ||= @opts[:components].map{ |comp| initialize_component(comp) }
  end

  def root
    @root ||= initialize_component(@opts[:root])
  end

  def initialize_component(comp_name)
    if ROOTS.include?(comp_name)
      BootApp.new(comp_name)
    else
      BootComponent.new(comp_name)
    end
  end
  
end

class BootComponent
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def engine
    module_name = @name.classify
    module_name = module_name.pluralize if @name[-1] == 's'
    module_name.constantize.const_get(:Engine)
  end

  def path
    "./components/#{@name}"
  end

  def root?
    false
  end

end

class BootApp < BootComponent

  def path
    "./apps/#{@name}"
  end

  def root?
    true
  end
end
