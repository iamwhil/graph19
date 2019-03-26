module Users
  class User < ApplicationRecord

    has_many :posts

  end
end
