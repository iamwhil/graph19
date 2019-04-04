# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

::Users::ApplicationRecord.descendants.each do |descendant|
  ::ConcernDirectory.inclusions(descendant).each{ |ext| descendant.include ext }
end

::Blog::ApplicationRecord.descendants.each do |descendant|
  ::ConcernDirectory.inclusions(descendant).each{ |ext| descendant.include ext }
end