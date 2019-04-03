module Users
  module Resolvers
    class RenameUserMutationResolver

      attr_accessor :user

      def initialize(obj, args, ctx)
        @obj = obj
        @args = args.to_h
        @ctx = ctx
      end 

      def call
        find_user
        rename_user
        return_result
      end

      private 

        def find_user
          @user = User.find(@args[:id])
        end

        def rename_user
          @user.update(name: @args[:name])
        end

        def return_result
          {
            user: @user
          } 
        end

    end
  end
end