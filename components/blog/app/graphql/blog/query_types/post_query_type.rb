module Blog
  module QueryTypes
    module PostQueryType
      extend ActiveSupport::Concern

      included do 
        field :post, ::Blog::Types::PostType, null: true do
          argument :id, Integer, required: true
        end
      end

      def post(id:)
        ::Blog::Post.find(id)
      end

    end
  end
end