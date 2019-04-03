module Users
  module Resolvers
    class RenameUserMutationResolver

      def initialize(obj, args, ctx)
        @obj = obj
        @args = args.to_h
        @ctx = ctx
      end 

      def call
        puts "hello"
      end
    end
  end
end