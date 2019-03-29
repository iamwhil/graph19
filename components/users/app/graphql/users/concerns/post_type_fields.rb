module Users
  module Concerns
    module PostTypeFields
      extend ActiveSupport::Concern
      ROOT = "Blog::Types::PostType"

      included do

        field :user, ::Users::Types::UserType, null: false do 
          description "User for a given post."
          argument :id, Integer, required: true
          argument :name, String, required: true
        end
      end

      def user(args)
        puts "Args #{args.inspect}" #arguments? Yea... args.
        puts "Context #{context.inspect}" #Context? Set it and forget.. remember it.
        puts "Object #{object.inspect}" #Object we're playing with (post).
        object.user
      end

    end
  end
end
