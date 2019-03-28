class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  require 'post'
  Dir.foreach("#{Rails.root}/app/models") do |model_path|
    require model_path.gsub('.rb') unless ['.', '..']
  end
  descendants.each do |descendant|
    ::ConcernDirectory.inclusions(descendant).each{ |ext| include ext }
  end  
end
