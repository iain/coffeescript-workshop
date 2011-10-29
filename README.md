# CoffeeScript Workshops

This is part of the javascript/coffeescript workshops, given on 2011-11-01 and 2011-11-09 by
[Iain Hecker](http://iain.nl) at [Finalist](http://finalist.nl).

* [CoffeeScript reference](http://coffeescript.org)

## Installation

First, clone this repository.

To make things easier, I've included a script to get you up and runnig.

### Locally

If you're running on Ubuntu, simply run `install.sh`.

If you're on mac, make sure you have the proper compile tools, git, python and curl before running
`install.sh`.

### In a Virtual Machine

If you're running Windows, or don't want to change your local installation,
install VirtualBox and Ruby, and run:

    gem install vagrant
    vagrant up

This will take a lot of time the first time, because it will download Linux and compile Node.js.
You can easily drink a pot of coffee while you wait. (har har har)

Login to your freshly created VM:

    vagrant ssh

Go to the project directory:

    cd /vagrant

From here you can run the rest of the scripts.

If you're done, don't forget to shut down the VM with `vagrant halt`.


## Running specs

Run the specs of a sample project:

    jasmine-node --coffee DIRECTORY

So the example specs (to see if everything installed correctly):

    jasmine-node --coffee example

It has one passing spec and one failing spec.
