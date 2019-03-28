module Users
  module QueryTypes
    module UserQueryType
      extend ActiveSupport::Concern

      included do 
        field :user, ::Users::Types::UserType, null: true do
          argument :id, Integer, required: true
        end
      end

      def user(id:)
        ::Users::User.find(id)
      end

    end
  end
end