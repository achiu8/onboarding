# Controller Testing

In a well designed web-app, controllers are simple. Business logic is pushed to the Model and presentation details are the responsibility of the view. Controllers sit in the middle, acting as the "glue" that keeps it all together.

Light as controllers can be, testing them is crucial. They broker all communication in your system. Testing a controller usually means verifying that they're "connecting the dots", interacting with their respective models and views correctly. More specifically, controller testing can include:

 * Interactions with the Models, like CRUD operations
 * Interactions with the Views, like assignment of instance variables
 * Routing logic, whether that means routing to different URLs or "routing" to different templates

## Questions to Answer

In testing your controllers you'll find yourself answering questions like:

 * Did the controller redirect based on some condition?
 * Did the controller send a different response based on some condition?
 * Did the controller render the right template?
 * Are all logical branches of the controller action tested?
 * Were instance variables assigned correctly/
 * Was the model instructed to do the right thing?
   * Perform an appropriate query
   * Persist itself
   * Update itself

## Syntax

Check the [RSpec docs](https://www.relishapp.com/rspec/rspec-rails/docs/controller-specs) for controller test specific syntax.
