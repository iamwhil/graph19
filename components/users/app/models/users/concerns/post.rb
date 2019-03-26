module Users
  module Concerns
    module Post
      extend ActiveSupport::Concern
      ROOT = 'Post'

      included do
        belongs_to :user, class_name: "Users::User"
      end

      def hello
        puts "hello"
      end

    end

  end
end