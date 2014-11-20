3000acres
=========
[![Build Status](https://travis-ci.org/3000acres/3000acres.svg?branch=dev)](https://travis-ci.org/3000acres/3000acres)

[3000 Acres](http://www.3000acres.org) will connect people to land, to
resources and to each other.

We want to unlock the acres of underutilised land locked behind
chainlink fences. Bring urban farming to sites awaiting development and
activate our rooftops.

## Setup

Notes on setting up the app:

### Create admin user(s)

Via the rails console, find the user you want, eg:

    u = User.find_by_name('Skud')

Then do:

    u.add_role :admin

## For coders

3000 Acres is a Ruby on Rails 4 app.  Feel free to fork it and play with
it, raise issues and pull requests against the code, etc.  You may also
like to check out our higher-level [task
tracker](https://www.pivotaltracker.com/s/projects/938508) where the
project planning takes place.

For any code related queries, email
[skud@growstuff.org](mailto:skud@growstuff.org).

## License

This application is open source, licensed under the Affero General
Public License version 3 (AGPLv3).  See [LICENSE.txt](LICENSE.txt) for
the full details.

## Credits

Based (conceptually) on [596acres](http://596acres.org/) whose code can
also be found [on github](https://github.com/596acres/).

Some code comes from [Growstuff](http://growstuff.org/) under AGPLv3.

Map pins: [CC-BY-SA user Mono on Wikimedia
Commons](https://commons.wikimedia.org/wiki/File:Map_pin_icon.svg)


