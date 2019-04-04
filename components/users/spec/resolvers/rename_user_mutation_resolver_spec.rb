require 'rails_helper'

module Users
  module Resolvers
    describe RenameUserMutationResolver  do

      context "When a new user name is passed in" do
        it "should update the user's name." do
          user = ::Users::User.create(name: "Scrappy")
          expect(user.name).to eq("Scrappy")
          args = {id: user.id, name: "Scooby"}
          resolver = RenameUserMutationResolver.new(nil, args, nil).call
          user.reload
          expect(user.name).to eq("Scooby")
          expect(resolver[:user][:name]).to eq("Scooby")
        end
      end
    end

  end
end