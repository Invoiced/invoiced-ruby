invoiced-ruby
========

This repository contains the Ruby client library for the [Invoiced](https://invoiced.com) API.

[![CI](https://github.com/Invoiced/invoiced-php/actions/workflows/ci.yml/badge.svg)](https://github.com/Invoiced/invoiced-php/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/Invoiced/invoiced-ruby/badge.svg?branch=master&service=github)](https://coveralls.io/github/Invoiced/invoiced-ruby?branch=master)
[![Gem Version](https://badge.fury.io/rb/invoiced.svg)](https://badge.fury.io/rb/invoiced)

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

- Ruby 2.1+
- `rest_client` gem
- `jwt` gem

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
payment = invoiced.Payment.create(
    :amount => invoice.balance,
    :method => "check",
    :applied_to => [
        {
            :type => "invoice",
            :invoice => invoice.id,
            :amount => invoice.balance
        }
    ])
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

## Deploying

The package can be uploaded to pypi with the following commands:

```
gem build invoiced.gemspec
gem push invoiced-X.Y.Z.gem
```