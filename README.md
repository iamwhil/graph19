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

## Engines

### Justification. Because if we're going to use engines instead of just micro-services and separate apps for everything - I should explain why.

Pairin (www.pairin.com) does some fantastic things with engines.  It builds multiple apps from 1 codebase.  WHich keeps duplication of code to a bare minimum. Yay. The booter picks which components to load and builds apps based on the application environment.  This means that we can have an application that serves up data to one set of users, and another application which allows for the altering of the data.  Users on the read only version can try to post to the graph to edit data but the endpoint will not exist!  Yay for security.  There is no way around this, the end point simply does not exist to edit things in the app.

Okay so there are otherways to do this without all the fancy engine stuff... with graph itself.  Do we gain anything else?

Yes we do we also can keep functionality siloed in the components.  If we don't want the application to be able to do something, we just don't include that component.  Or what if we want to add some crazy new feature?  We can keep all the logic for it in the component, no spaghetti code or logic where it does not belong.  So what if that crazy new feature was horrible?  Delete the component, and clean up is done.

So how do we do this?

Lets find out.