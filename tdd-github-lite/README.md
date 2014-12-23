# Flying Blind

In this challenge we're going to build a fully functional Rails app without opening the browser during development. You will write tests to cover views, models and controllers to verify that your app is working according to spec. At the very end, we'll give your app a try. Your test coverage will ensure that it works flawlessly.

It's important to resist the urge to open the browser just to take a peek. Think hard about what confidence you hope to gain by doing so, and instead figure out how to write a test that provides the same confidence. The assurance you would have gained by running through it yourself is now forever encoded and repeatable in your testing suite.


## Github Lite™

We will be building a tiny clone of Github on top of Github's own API. As a result, you'll need your code from the [Github API Challenge](../../../github-api-challenge). Make sure it's tested before jumping in.

## Release 1, New App

Create a new Rails project. We'll use RSpec and we won't be using ActiveRecord so ensure that your project is started without MiniTest and ActiveRecord. `rails new -h` gives you information on the command line options you can pass to accomplish this.

Don't forget to include `rails-rspec` in your gem file and run the required generator.

Commit immediately after `rails new` and your rspec configuration is complete. This will ensure that  your changes in the future will not be in the same commit as the massive number of files rails generates.

## Release 2, Github API

Copy the models from the [Github API Challenge](../../../github-api-challenge) into `app/model`, and the specs to `specs/models`. Any supporting modules or classes should be placed in the `lib` directory. Make sure to add the `lib` directory to the load path for your Rails app or those classes will not be available to your models.

```ruby
#application.rb
config.autoload_paths += %W(#{config.root}/lib)
```

As you continue to expand your Github models throughout this challenge, ensure you maintain test coverage as you go.

## Release Interlude, Notes on Testing

Read through the short notes on [controller testing](controller-testing.md) and [view testing](view-testing.md) before you continue.

## Release 3, Github Profile

Build a page that contains the information on the [Github Profile](https://www.github.com/mattbaker) page. Since you're doing this without a browser, you don't need to heavily style it, but do make sure your view is well organized.

Your profile does _not_ need to include:

 * Interactivity, like "Follow"
 * The "Repositories" or "Public Activity" tabs
 * The Public Contributions section
 * Javascript (yet)

### A note about pagination

Some queries in Github's API are [paginated](https://developer.github.com/guides/traversing-with-pagination/). For example, you can only request 30 repositories at a time. If you want to pull more than that, you need to make a second call and provide an offset.

## Release 4, Creating Repositories

If an authenticated user browses their own profile page, include a text field and button to create a new repository. You don't need to build an authentication system, the user of the token you're using in your API client is sufficient.

The form should be submitted asynchronously with client-side Javascript (you can use JQuery). Upon receipt of a response, the repository should be appended to the list of repositories on the user's page.

This will require both QUnit and RSpec tests to ensure your page is working correctly client-side.

## Release 5, Repository Page

Build a page that represents a single repository. It should include:

 * The name
 * The author, with a link to the author's page
 * The README, correctly formatted if it's Markdown (`.md`, `.mdown`)
 * The number of commits, branches and contributors

You will also need to update the user profile page, ensuring the user's repositories link to the correct Repository page. New repositories (added via AJAX) should also have correct links.

## Release 6, Let It Rip

Make sure you are confident in your test coverage. When you're ready, open the web browser and step through your site.

Outline any bugs you find manually in `notes.md`, then write tests for them. Write the tests _before_ you fix the bug. Since you didn't catch the bug the first time around, you have to ensure your new test _would have_ if it had existed. Fix and test all the bugs one bug at a time.
