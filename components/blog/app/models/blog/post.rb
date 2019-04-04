module Blog
  class Post < ApplicationRecord
    #::ConcernDirectory.inclusions(self).each{ |ext| include ext }

    validates_presence_of :title

    has_many :comments

  end
end
