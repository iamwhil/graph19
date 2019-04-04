# README... ReadMe... Read Me.

This README would normally document whatever steps are necessary to get the
application up and running.

This one has a picture of a turtle.
```    
                    __
         .,-;-;-,. /'_\
       _/_/_/_|_\_\) /
     '-<_><_><_><_>=/\
       `/_/====/_/-'\_\
        ""     ""    ""
```
Graph19 is a test bed for the newest components of a rails application in March 2019 using Rails 6, graphql-ruby 1.9+, Ruby 2.6.2, RSpec, and application composition via components.

## Setup 

It is probably best to use RVM for this.  www.rvm.io

* 1) Install the gpg key - you may need to install gpg2
* 2) Update your RVM (or clean install) to get the newest list of known rubies.
* 3) Install the ruby you would like.  
`rvm install ruby 2.6.2`
`rvm use 2.6.2`
* 4) Create a new gemset for this project
`rvm gemset create graph19`
* 5) use the gemset!
`rvm gemset use graph19`
* 6) Install Rails.  Because this is a beta-version we need to get the pre-release gem
`gem install rails --prerelease`
* 7) Creating a new app instead of using this as a starting point? `rails new some_fancy_name`
* 7) Better - Git this app!
* 8) Make sure your .ruby-version and .ruby-gemset files are set (ruby version 2.6.2) (gemset graph19).

## Ruby 2.6.2

Because it is new and fun.  And way faster than 2.4.2 our old loyal friend. (It now lives on a farm where it can play with the other ruby versions.)

## Rails 6.0.0.3 beta

This will be changed to 6.0 as soon as we can!  But no sooner.  Time is such a fickle thing.

## GraphQL 1.9.3

GraphQL 1.8 + and in parictular 1.9 does away with the old Types setup of the old 1.7 days.  They were horrible and dark days. This app will utilize 1.9.3 so that we can define GraphQL class types with ruby syntax instead! So much better!

## Postgres - the database!

Lets use postgres.  Because Heroku did!  Hahaha oh me. Because its more stable than SQLite and we run it with relative ease on AWS RDS.

## Engines / Components

We're gonna call them components because a bunch of components will make up our application.

### Justification. 

Because if we're going to use engines instead of just micro-services and separate apps for everything - I should explain why.

Pairin (www.pairin.com) does some fantastic things with engines.  It builds multiple apps from 1 codebase.  WHich keeps duplication of code to a bare minimum. Yay. The booter picks which components to load and builds apps based on the application environment.  This means that we can have an application that serves up data to one set of users, and another application which allows for the altering of the data.  Users on the read only version can try to post to the graph to edit data but the endpoint will not exist!  Yay for security.  There is no way around this, the end point simply does not exist to edit things in the app.

Okay so there are otherways to do this without all the fancy engine stuff... with graph itself.  Do we gain anything else?

Yes we do, we also can keep functionality siloed in the components.  If we don't want the application to be able to do something, we just don't include that component.  Or what if we want to add some crazy new feature?  We can keep all the logic for it in the component, no spaghetti code or logic where it does not belong.  So what if that crazy new feature was horrible?  Delete the component, and clean up is done.

So how do we do this?

Lets find out.

### Some files you will need.
Al created two classes that we need, the booter and the ConcernDirectory.
These need to be in the /lib folder.

Include the following lines in the Gemfile:
```
# Require the booter
require File.dirname(__FILE__) + '/lib/booter'

# Require the conern directory
require File.dirname(__FILE__) + '/lib/concern_directory'
``` 

### Creating a component

`rails plugin new components/COMPONENT_NAME --mountable -T -d postgresql`

-- mountable | will add namespace isolation to the engine. (and some other stuff --full would do.. app directory, config/routes.rb/ lib/component_name/engine.rb, etc.)

-- T | skips the test files. We'll use RSPEC and hop throught the tests with a test_suite.sh

-- d postgresql | Sets the date to today.  Haha, oh me.  Uses postgres as our database for this engine.

Making a new component?  How about doing that thing everyone loves doing?  Delete some things you don't need!  And if you need them, bring them back!

### Cleaning up the creation

The creation of the component will create quite a few files and do some things you don't want done.

A. Remove `gem 'gem_name', path 'components/gem_name'` from the Gemfile. We'll do this with the booter (Below).

B. Alter the [gemname].gemspec to contain valid information and no TODO's.

C. Include any gems that you need in the [gemname].gemspec

D. Using Graph? Create a `graphql/[gemname]` folder in the components app/ folder.  The /[gemname] will allow us to name space our graph objects.
* create `concerns`, `query_types` and `types` folders in the `graphql/[gemname]` folder.

* app/views
* app/assets

### Mounting a component - The Booter.

The main application's Gemfile needs to include the the engine.  

`gem 'components_name', path: 'path_to_component'`

This will load the component.  It will first require the components lib/component_name.rb and then the lib/component_name/engine.rb.

What if we have LOTS of components?  Well then lets include the Booter. 

The Booter can have an array of the components that you want to run for a given app.  And then in the Gemfile:

```
Booter.app.components.each do |component|
  gem component.name, path: component.path
end
```

See the booter.rb file.  Thanks Al.

### Migrations.

Rails documentation suggests that you copy all of the migrations from the engine into the application's db/migrations directory.  What if you have lots of migrations?  Fun - a command that will copy all of them over! bin/rails railties:install:migrations.  How convenient!  And when you don't need that component anymore and you delete it?  Go in and hand pick the migrations and remove them!  Yay you've successfully un-de-coupled the components!  

Lets not do that. 

Instead we mesh all the migrations together and run them in timestamp order.  Then if we delete a component - the migration is gone.  Its artifacts will still be in the database but new database instances will not have the artifacts.

Add this to the component's engine.rb file.

Source: https://content.pivotal.io/blog/leave-your-migrations-in-your-rails-engines

```
# allows migrations to be accessible at root
initializer :append_migrations do |app|
  unless app.root.to_s.match root.to_s
    config.paths["db/migrate"].expanded.each do |expanded_path|
      app.config.paths["db/migrate"] << expanded_path
    end
  end
end
```

### Model Concerns.

Concern: Something that worries you: Ethan "That person on Tinder is really hot and probably a model... but they could be crazy."

Concerns add functionality from one component into another.  If you're adding functionality into a model, create the concern in models/concerns/class_name.rb.  Similarily for services, mailers, etc.

To use the concern we need to include the concern in the model.  

For example:

```
class Post < ActiveRecord::Base
  include Users::Concerns::Post
...
```

However doing so now has coupled our components together.  They are no longer siloed.  If we delete the Users component, the Post is still going to try to include it and EXPLODE! :fire:

So to get around this we have the ConcernDirectory by Al.  
`ConcernDirectory.inclusions(self).each{ |ext| include ext }` which we can include in the model.

This essentially looks at the booter, finds all the components that we have and then inspects their engines to find the inclusions.  It then includes these files in the model.

Example.

We have 2 components, the users and the blog!  Blog posts will belong to a user.  But we don't want anything in the blog component to be hard coded and tied to the users component.  

In the users' engine we include the concerns that link to the posts component.


```
# components/users/lib/users/engine.rb

...
  def inclusions
    [
      Users::Concerns::Post
    ]
  end
```

In the post model within the blog component we add our ConcernDirectory functionality.

```
# components/blog/app/models/blog/post.rb 

class Post < ActiveRecord::Base
  ConcernDirectory.inclusions(self).each{ |ext| include ext }
...
```

Over in the user's component we create a concern for the post.

```
# components/users/app/users/models/concerns/post.rb
module Users
  module Concerns
    module Post
      extend ActiveSupport::Concern
      ROOT = 'Blog::Post'

      included do
        belongs_to :user, class_name: "Users::User"
      end

      def hello
        puts "hello"
      end

    end

  end
end
```

At this point the post model has a belongs_to user relation and a #hello method. Success.

### Graph Concerns

What's the point of all this segregation if we can't get the graph to play along?  Well we can.  Basically we'll always be adding fields to types (GraphQL objects).

This follows almost the same structure as the model concerns.  However we've adopted a slightly different file and naming structure to keep things right in our heads. And we all like being right in the head, no one likes missing marbles.  Those go in our mouths.

So lets gain understanding with another example.

We still have the blog and users components.  We have a post, and we want to be able to query for the user it belongs to.

So we'll assume we have our basic post_type returned by our post_query_type.

```
# components/blog/app/grapql/blog/query_types/post_query_type.rb
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
```

```
# components/blog/app/graphql/blog/types/post_type.rb
module Blog
  module Types
    class PostType < ::Types::BaseObject
      description "A blog post."

      field :id, Integer, null: false
      field :title, String, null:false
      field :trunacated_preview, String, null: false
      field :comments, [::Blog::Types::CommentType], null: true, 
        description: "This post's comments, or null if this post has comments disabled."
    end
  end
end
```

This will query our post just fine.  But what about the user?  Well we could add a user field to the post_type that references the Users component's user type.  But ... remember that whole separate but equal thing?  Injustice.  So here we just keep our components and all their bits siloed.

So lets build a concern over in the users component that adds the user field to the post type.

```
# components/users/app/graphql/users/concerns/post_type_fields.rb
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
        puts "Context #{context.inspect}" #Context? Set it and forge.. remember it.
        puts "Object #{object.inspect}" #Object we're playing with (post).
        object.user
      end

    end
  end
end

```

* Note the `ROOT = "Blog::Types::PostType"` - without it the concern will try to add itself to PostTypeFields over in the Blog::Types... which does not exist.  We've added 'Fields' so we know what we're adding to the post type.  Just teh compooter is stoopid and does knot know what w'ere trying tod o.

Now that we have our concern we need to tie it into our PostType.

```
# components/blog/app/graphql/blog/types/post_type.rb
module Blog
  module Types
    class PostType < ::Types::BaseObject
      description "A blog post."
      ::ConcernDirectory.inclusions(self).each{ |ext| include ext }
...
```

The ConcernDirectory again will look for concerns from the inclusions specified in the engine.rb files for components included in the booter.

```
# components/users/lib/users/engine.rb
...
  def inclusions
    [
      Users::Concerns::Post,
      Users::Concerns::PostTypeFields
    ]
  end
...
```

Sample Query: 
```
query{
  post(id:1) {
    id
    user(id:1,name:"Tom"){
      name
    }
  }
}
```

response:
```
{
  "data": {
    "post": {
      "id": 1,
      "user": {
        "name": "Fred"
      }
    }
  }
}
```

### Mutations - now the turtle makes sense!

Mutations are quite a bit more involved than queries but their implementation is a bit simpler.
There is a bit of setup to get mutations to work accordingly.
Within each component you will want to create 1) a graphql/mutations folder and a graphql/mutations.rb file.

First we should create the base mutation type all other mutations will inherit from.

```
# app/graphql/mutations/base_mutation.rb
# We could also inherit from GraphQL::Schema::RelayClassicMutation to integrate with
# Relay.  Look at the documentation for more info.  We don't need to do this.
# https://graphql-ruby.org/mutations/mutation_classes

class Mutations::BaseMutation < GraphQL::Schema::Mutation
  # This is used for generating payload types
  object_class Types::BaseObject

  # This is used for return fields on the mutation's payload
  field_class Types::BaseField

  # This is used for generating the 'input: { ... }' object type.
  # I'd rather pass in arguments instead of some sort of input hash, so we don't do this.
  # input_object_class Types::BaseInputObject
end
```

Next lets make a mutation! What a splendid time for an example!

```
# components/users/app/graphql/users/mutations/update_user_mutation.rb
module Users
  module Mutations
    class UpdateUserMutation < ::Mutations::BaseMutation # The inheritance!
      null true

      argument :id, ID, required: true
      argument :name, String, required: false

      field :user, Types::UserType, null: true

      def resolve(id:, name:)
        user = ::Users::User.find(id)
        user.update_attributes(name: name)
        {
          user: user
        }
      end
    end
  end
end
```
Note! The resolve's return value is a hash of the fields.

The component/mutations.rb file explicitly includes mutation fields into the schema (once we include the mutations in the base graph).

```
# components/users/app/graphql/users/mutations.rb
module Users
  module Mutations
    extend ActiveSupport::Concern

    included do 
      field :update_user, mutation: ::Component::Mutations::UpdateUserMutation
    end

  end
end
```

At this point we have the mutation and it should be created, but it is not in our schema!  To include it in our schema we need to include the component's mutations into the base mutation type (the entry point for mutations). 

In our root mutations type we include the mutations we want.
```
# app/graphql/mutation_type.rb
class MutationType < Types::BaseObject

  field :test_field, String, null: false,
    description: "An example field added by the generator"
  def test_field
    "Hello World"
  end

  include Users::Mutations

end
```

Here we see two things.  

One - a field directly included on the Mutation Type.  This field would show up in EVERY schema for every app we launch from this code base.  This is probably a bad idea and will never be the case.  So lets not do this.

Two - the `include Users::Mutations`.  This could be pulled in with the ConcernDirectory so we don't hard code it.  Here in this example we're explicitly including it to illustrate what is going on.  We're including the Users::Mutations defined at `components/users/app/graphql/users/mutations.rb`. 

What a good illustration.  I'm a regular Bob Ross.

### Resolvers

What if you would really really like to test the mutation? What if that mutations resolve block gets HUGE?  Well in either case its much easier to keep things small, and testable by using a resolver.

A resolver is basically just a class that does the resolution for us.  We can create a resolver for our rename_user_mutation.rb (eerily similar to update_user_mutation... but with a resolver.  OoOoOooO... eerie)

First take a look at your resolve clause.
```
def resolve(id:, name:)
  user = ::Users::User.find(id)
  user.update_attributes(name: name)
  {
    user: user
  }
end
```

Next move the resolution block logic to a new class and refactor at your leisure!

```
# components/users/app/graphql/users/resolvers/rename_user_mutation_resolver.rb
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
```

Back in the mutation instead of resolving with our little resolve block we can use our new fancy resolver!

```
# rename_user_mutation.rb
def resolve(args)
  ::Users::Resolvers::RenameUserMutationResolver.new(object, args, context).call
end
```

A couple things. 1. 2. Done.

A. You're probably thinking that was a silly thing to do... 3 lines into a 37 line class?!  Agreed.  But what if it was not 3 lines, what if it was LOTS of lines ... like 5... and included lots of complicated and convoluted logic?  Well now a resolver is looking pretty good.  It cleans up your muatation and you can test it!

B. "But... coulnd't you previously call the resolve / resolve_field with a proc? Why don't you do that now?!"  Fair enough.  If you have a work flow with resolvers you're calling with a proc God speed.  Have fun.  However I really like this approach because there is no black magic with the `(obj, args, ctx)` implicitly being passed to .call and you get a shiney initializer!

## RSpec - Regular Spectacular!

I assume that's what that stands for.

So lets say we want to run some tests because our name is not Sebastian.

The first thing we need to do is include RSpec at a high level, so lets do that in our Gemfile.  Lets live dangerously and not specify a version.  (As we're still in rails 6 beta when rails 6 comes out an official release for rspec-rails may follow.  We want to specify that in the future.)

```
group :development, :test do
  # ...
  gem 'rspec-rails'
end
```
That was easy!  Because we're not done.

Now in the individual components we need to require RSpec.  Lets do that in our gemspec files.

```
# components/component/component.gemspec 
spec.add_development_dependency "rspec-rails"
```

Now we're done.  Gotcha! 

Install rspec by running `rails g rspec:install` in the component's root directory.  This will create the spec folder, spec_helper.rb and rails_helper.rb.

Next we need to make sure that the engine is utilizing rspec when generating things. Eg models. Eg. dinosaurs.

In the engine.rb we can specify our test framework for the generators.

```
# engine.rb
config.generators do |generator|
  generator.test_framework :rspec
end
```

If you're one of those people who uses `rails generate model ...` now your rspec tests will be generated as well.  If you're a cool kid you probably build these files by hand - don't forget your tests!

### Dummy.

So RSpec does this thing where it basically runs against a dummy application.  We can get this to work when generating our component with `--dummy-app=spec/dummy`.  This basically builds an entire application in spec/dummy.  Its huge.  And for as many components as you have you'll have this dummy application.

To keep the "oh I can't get wet" people happy - lets have one dummy-application at [rails-root]/spec/dummy.  Basically this is a copy of the dummy app.

This dummy app does not know about the components right off hand, they need to be required.  When a dummy app exists for each component its application.rb file will `require gem-name`.  We want to do this dynamically in our universal dummy app.

In the application.rb in the dummy app `require gem-name` has been replaced with `require ENV['TEST_ENGINE']`. 

Inside of the rails_helper.rb file for each component's specs we need to set the gem-name. 

```
# component/spec/rails_helper.rb
ENV['RAILS_ENV'] ||= 'test'
ENV['TEST_ENGINE'] = 'component name' # <--- right there!
require File.expand_path('../../../../spec/dummy/config/environment', __FILE__)
...
```

### I can't hear you! -Every test to every component.

At this point we can run tests in individual components.  Go ahead try. I dare you.  From the component `bundle exec rspec spec`.  See I told you so.

However, if the tests reference ANY other ANYTHING from ANY other component.  Everything starts to fall apart.

To get the tests to recognise other components we have to do a couple things.

First in the Gemfile of the test, require the other component.  This is the only place where we hard code references to other components.  Perhaps we could utilize the ConcernDirectory here, but the booter would need to have an app that requires ALL of the components.  So for now we'll specify them 1 at a time in the Gemfile.

```
# Example: Will include the blog engine in the users component.
# components/users/Gemfile
...
gem 'blog', path: "../blog"
...
```

Now we can test our concerns.  In the individual concern tests we need to include the concern into the base class.  We don't do this dynamically so that we don't force validations/associations/functions we may not want on the base class.

```
# components/users/spec/models/concerns/post_spec.rb
require 'rails_helper'

::Blog::Post.include Users::Concerns::Post

describe ::Blog::Post do 
...
```

### Making things easier with shoulda.

The shoulda matchers add quite a bit of ease to testing ActiveRecord validations and relations.  So lets use them!

First include the shoulda matches in the component's .gemspec file.

```
#components/component/component.gemspec
Gem::Specification.new do |spec|
...
spec.add_development_dependency "shoulda" # put me somewhere pretty.
```

Now in the rails helper lets require the shoulda matchers and configure them. If we don't things will break. Like your dreams of running tests.

```
#components/component/spec/rails_helper.rb
...
# somewhere after the abort line
require 'shoulda/matchers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails 
  end
end
...
```
Now we're talk'n.  Well at least inter-componently.

Phew that is a lot of work. Lets take a break with a picture of a duck.
```
      ,~~.
     (  9 )-_,
(\___ )=='-'
 \ .   ) )
  \ `-' /
   `~j-'
     "=:
```

### How about we run all the tests!

There are some cleaner ways we could go about this utilzing ruby to run our files.  But for the sake of time we're gonna hijack Al's runner.

At the app's core we need to include the test_suite.sh file.
```
#!/bin/bash

trap "exit" INT

result=0

cd "$( dirname "${BASH_SOURCE[0]}" )"

for test_script in $(find . -name test_runner.sh); do
  echo `dirname $test_script`
  if [ "$2" != "" ] && [ "./$2" != `dirname $test_script` ]
  then
    continue
  fi

  pushd `dirname $test_script` > /dev/null
  chmod +x ./test_runner.sh
  if [ "$1" == "ci" ]; then
    ./test_runner.sh ci $3
  else
    ./test_runner.sh main $3
  fi

  ((result+=$?))
  popd > /dev/null
done

if [ $result -eq 0 ]; then
  tput setaf 2;
  echo "==================== SUCCESS ===================="
  echo "          You will be showered in riches         "
else
  tput setaf 1;
  echo "=====================  FAILURE  ===================="
  echo "You have brought shame upon yourself and your family"
fi

exit $result
```

Then in each component's root we need to have a test_runner.sh

```
#!/bin/bash

exit_code=0

echo "**Running container specs**"
if [ "$1" == "ci" ]; then
  bundle check --path=../../vendor/bundle || bundle install --path=../../vendor/bundle --jobs=4 --retry=3
else
  bundle check || bundle install
fi

bundle exec rspec spec
exit_code+=$?

exit $exit_code
```

Now running `./test_suite.sh` from the app's root directory will run all tests in each of the components.

### What about that resolver test?

Oh yea! Good memory.  Now that we have a functional test suite we can also test our resolvers.  The example resolver test below tests the update user name resolver from the before time.

```
# components/users/spec/resolvers/rename_user_mutation_resolver_spec.rb
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
```

The major things to note here are the `resolver = ` and teh resolver response.  Make sure to create a new resolver with the expected parameters (object, arguments, context) and the fields in the resolver after called will be the fields specified in the resolver.


@todo : can we add the inclusions in active record? See PMac's PR