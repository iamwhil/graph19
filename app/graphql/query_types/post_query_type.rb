module QueryTypes
  module PostQueryType
    extend ActiveSupport::Concern

    included do 
      field :post, Types::PostType, null: true do
        argument :id, Integer, required: true
      end
    end

    def post(id:)
      Post.find(id)
    end

  end
end