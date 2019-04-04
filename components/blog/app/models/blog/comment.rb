module Blog
  class Comment < ApplicationRecord

    belongs_to :post
    
  end
end