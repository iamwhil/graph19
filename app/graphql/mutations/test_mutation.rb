class Mutations::TestMutation < Mutations::BaseMutation
  null true

  argument :id, ID, required: true

  field :message, String, null: true
  def resolve(id:)
    message = "Sup dawg"
    {
      message: message,
    }
  end
  
end