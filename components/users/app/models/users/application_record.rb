module Users
  class ApplicationRecord < ActiveRecord::Base
    include ConcernHelper
    self.abstract_class = true
    descendants.each do |descendant|
      ::ConcernDirectory.inclusions(descendant).each{ |ext| include ext }
    end
  end
end
