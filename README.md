Rules
=========
[![build status](https://secure.travis-ci.org/azach/rules.png?branch=master)](https://secure.travis-ci.org/azach/rules) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/azach/rules)

A Ruby gem engine that allows you to add customizable business rules to any ActiveRecord model. Rules integrates with ActiveAdmin to make it trivial to allow admin users to create rules on the fly for your models.

Installation
------------
Add it to your Gemfile:

```ruby
gem "rules"
```

Update your schema:

```ruby
rake rules:install:migrations
rake db:migrate
```

to create the required tables to store your rules.

Setting Up Rules
------------
To use rules on a model, include ```Rules::HasRules```. You can also optionally define any attributes that are available for that model using ```has_rule_attributes```.

This will allow the user to build rules against this attribute. For example, you may want to allow users to build rules against the email address in the order. In this case, your model would look like:

```ruby
class Order < ActiveRecord::Base
  include Rules::HasRules

  has_rule_attributes({
    customer_email: {
      name: "customer email address"
    }
  })
end
```

To evaluate a set of a rules, use the ```rules_pass?``` method on the instance. You may also pass the values of the attributes that you allowed users to define rules against at this point.

For example:

```ruby
order = Order.new
order.email_address = "morbo@example.com"
order.rules_pass?(customer_email: order.email_address)
```

Defining Rules
------------
Rules are meant to be defined by business users using an admin interface. For this reason, the gem provides integration with ActiveAdmin to make this easier.

There are two helper methods you can use, one for your show action and one for your form.

For the show action:

```ruby
show_rules
```

For the form action:

```ruby
f.has_rules
```

This will give you something like:

![ActiveAdmin form for editing rules](https://github.com/azach/rules/raw/master/spec/dummy/app/assets/images/edit_example.png)

Configuration
------------
You can add an initializer to configure default options.

```ruby
Rules.configure do |config|
  config.errors_are_false           = true  # return false if an evaluator raises an error (true by default)
  config.missing_attributes_are_nil = true  # return nil when a value is not passed for an attribute parameter
end
```

Default Constants
------------
TODO

Default Evaluators
------------
TODO
