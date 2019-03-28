#require_relative 'lib/concern_directory.rb'
module Blog
  class Post < ActiveRecord::Base
    # include Users::Concerns::Post # don't do this, use the ConcernDirectory
    ::ConcernDirectory.inclusions(self).each{ |ext| include ext }

    validates_presence_of :title

    has_many :comments;

  end
end