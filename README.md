# README

This README would normally document whatever steps are necessary to get the
application up and running.

This one does not. Sukka.

Graph19 is a test bed for the newest components of a rails application in March 2019.

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

Yes we do we also can keep functionality siloed in the components.  If we don't want the application to be able to do something, we just don't include that component.  Or what if we want to add some crazy new feature?  We can keep all the logic for it in the component, no spaghetti code or logic where it does not belong.  So what if that crazy new feature was horrible?  Delete the component, and clean up is done.

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
* create query_types and types folder in the `graphql/[gemname]` folder.

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

Rails documentation suggests that you copy all of the migrations from the engine into the application's db/migrations directory.  What if you have lots of migrations?  Fun a command that will copy all of them over! bin/rails railties:install:migrations.  How convenient!  And when you don't need that component anymore and you delete it?  Go in and hand pick the migrations and remove them!  Yay you've successfully un-de-coupled the components!  

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

### Concerns.

Concern: Something that worries you: Ethan "That person on Tinder is really hot... but they could be crazy."

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

```
class Post < ActiveRecord::Base
  ConcernDirectory.inclusions(self).each{ |ext| include ext }
...
```

@todo : Graph calls into other components.

@todo : RSPEC and runner.

@todo : can we add the inclusions in active record?