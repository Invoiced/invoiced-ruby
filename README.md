invoiced-ruby
========

This repository contains the Ruby client library for the [Invoiced](https://invoiced.com) API.

[![Build Status](https://travis-ci.org/Invoiced/invoiced-ruby.svg?branch=master)](https://travis-ci.org/Invoiced/invoiced-ruby)
[![Coverage Status](https://coveralls.io/repos/Invoiced/invoiced-ruby/badge.svg?branch=master&service=github)](https://coveralls.io/github/Invoiced/invoiced-ruby?branch=master)

## Installing

The Invoiced gem can be installed liked this:

```
gem install invoiced
```

It can be added to your Gemfile:

```
source 'https://rubygems.org'

gem 'invoiced'
```

## Requirements

- Ruby 1.9.3+
- rest_client, json, and active_support gems

## Usage

First, you must instantiate a new client

```ruby
require 'invoiced'

invoiced = Invoiced::Client.new("{API_KEY}")
```

Then, API calls can be made like this:
```ruby
# retrieve invoice
invoice = invoiced.Invoice.retrieve("{INVOICE_ID}")

# mark as paid
transaction = invoiced.Transaction.create(
    :invoice => invoice.id,
    :amount => invoice.balance,
    :method => "check")
```

If you want to use the sandbox API instead then you must set the second argument on the client to `true` like this:

```ruby
require 'invoiced'

invoiced = Invoiced::Client.new("{API_KEY}", true)
```

## Developing

The gem can be built with:

```
gem build invoiced.gemspec
```

The test suite can be ran with `rake test`