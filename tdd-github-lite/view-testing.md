# View Testing

The primary goals behind view testing are:

* Verify the logic in the template is correct
* Verify the presence of components (data or DOM) critical to your client-side code (Javascript).

The intention is _not_ to create an integration test (for example, checking if clicking "foo" leads to "bar"). Integration tests are often handled with something like Capybara.

## Logic

Logic includes if-conditions, filtering lists, or any logical branch that may affect the HTML output of a template based on the data going in. Just as the test the branches in your code, you need to test branches in ERB.

## The DOM

Some DOM elements may be critical to the function of your page client-side. Ensuring your template produces the right DOM elements on the server side can help you detect failure points between server-side (Rails) and client-side (JS) before deployment or integration tests.

## "Running" a View

View tests are stored in `spec/views/`. View tests follow naming conventions like other specs in Rails. For example, the `index` view for a `BlogPost` would live in `spec/views/blog_posts/index.html.erb_spec.rb`.

Controller code is not executed in a view test. Instead you assign the instance variables your template consumes by using `assign`. Think of this as providing inputs to the "function" your erb template represents.

```ruby
assign(:numbers, [1, 2, 3, 4])
```

When the proper instance variables are set, you can render the view with the `render` method. The result of invoking `render` is assigned to the `rendered` variable. You can also use different [view matchers](https://relishapp.com/rspec/rspec-rails/v/3-1/docs/view-specs/view-spec) to assert things about the rendered content.

For example:

```ruby
require 'rails_helper'

describe "posts/index" do
  it 'has both posts' do
    assign(:posts, [Post.new(title:'foo', body:'bar'),Post.new(title:'baz', body:'bang')])
    render
    expect(assert_select('tr').length).to eq(2)
    assert_select 'td', 'foo'
    assert_select 'td', 'baz'
  end
end
```
## A Note on View Logic

As much complexity as possible should be pushed to the controllers and views, and views themselves should contain very little logic. If you do have branching logic in your view, create scenarios for each conditional branch to ensure that it's covered.
