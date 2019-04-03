# We could also inherit from GraphQL::Schema::RelayClassicMutation to integrate with
# Relay.  Look at the documentation for more info.  We don't need to do this.
# https://graphql-ruby.org/mutations/mutation_classes

class Mutations::BaseMutation < GraphQL::Schema::Mutation
  # We can add custom classes here.

  # This is used for generating payload types
  object_class Types::BaseObject

  # This is used for return fields on the mutation's payload
  field_class Types::BaseField

  # This is used for generating the 'input: { ... }' object type
  # input_object_class Types::BaseInputObject

end