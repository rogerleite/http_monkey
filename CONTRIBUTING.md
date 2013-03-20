# Adding new features

We love pull requests. Here's a quick guide:

1. Fork the repo.

2. Run the tests. We only take pull requests with passing tests, and it's great
to know that you have a clean slate: `bundle && rake test`

3. Add a test for your change. Only refactoring and documentation changes
require no new tests. If you are adding functionality or fixing a bug, we need
a test!

4. Make the test pass.

5. Push to your fork and submit a pull request.

At this point you're waiting on us. We like to at least comment on, if not
accept, pull requests within three business days (and, typically, one business
day). We may suggest some changes or improvements or alternatives.

Some things that will increase the chance that your pull request is accepted:

* Use Ruby idioms and helpers
* Include tests that fail without your code, and pass with it
* Update the documentation and README for anything affected by your contribution

Syntax:

* Two spaces, no tabs.
* No trailing whitespace. Blank lines should not have any space.
* Prefer &&/|| over and/or.
* MyClass.my_method(my_arg) not my_method( my_arg ) or my_method my_arg.
* a = b and not a=b.
* Follow the conventions you see used in the source already.

NOTE: Adapted from https://raw.github.com/nesquena/rabl/master/CONTRIBUTING.md

# Bug triage

This section explains how bug triaging is done for your project. Help beginners by including examples to good bug reports and providing them questions they should look to answer.

* You can help report bugs by filing them on [Github Issues](https://github.com/rogerleite/http_monkey/issues).
* You can look through the existing bugs on [Github Issues](https://github.com/rogerleite/http_monkey/issues).

* Look at existing bugs and help us understand if
** The bug is reproducible? Is it reproducible via script? What are the steps to reproduce?

* You can close fixed bugs by testing old tickets to see if they are
happening
* You can update our change log [here](https://github.com/rogerleite/http_monkey/blob/master/CHANGELOG.md).
* You can remove duplicate bug reports

# Documentation

This section includes any help you need with the documentation and where it can be found. Code needs explanation, and sometimes those who know the code well have trouble explaining it to someone just getting into it.

* Help us with documentation, it's a [complete website](http://rogerleite.github.com/http_monkey/) on `gh-pages` branch.
Instructions to run the site local is [here](https://github.com/rogerleite/http_monkey/blob/gh-pages/Readme.md).
