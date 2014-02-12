3000acres
=========

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

### Set up CMS

Sign in as an admin user, then go to the CMS admin page (/cms-admin) and
set up as follows:

* A site called "topnav", identifier "topnav", path "/"
* A layout called "default", using the application layout
    * If you want to set up a "title" field for each page, make your
      layout's content read something like:

    &lt;h1&gt;
    {{ cms:page:title:string }}
    &lt;/h1&gt;

    {{ cms:page:content:text }}

    * This title will then be included in the HTML title (used by the browser
      etc)

* Under pages, set up:
    * A top-level page called "topnav"
    * Under that, any pages that you want to appear in the top navbar,
      eg. "About", "Donate", etc.

All this "topnav" guff is required to get the pages to show up
automatically in the top navigation bar.

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


