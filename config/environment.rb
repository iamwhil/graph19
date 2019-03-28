# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ApplicationRecord.descendants.each do |descendant|
  ::ConcernDirectory.inclusions(descendant).each{ |ext| descendant.include ext }
end