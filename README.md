# Ohanakapa

A ruby wrapper for the [Ohana API][]

[Ohana API]:https://github.com/codeforamerica/ohana-api

## Quick start

Install via Rubygems

    gem install ohanakapa

... or add to your Gemfile

    gem "ohanakapa", "~> 1.0"

### Making requests

API methods are available as module methods (consuming module-level
configuration) or as client instance methods.

```ruby
# Provide an API Token
Ohanakapa.configure do |c|
  c.api_token = '1asdf34526'
end

# Fetch all locations
Ohanakapa.locations
```
or

```ruby
# Provide an API Token
client = Ohanakapa::Client.new :api_token => '1asdf34526'
# Fetch all locations
client.locations
```

### Consuming resources

Most methods return a `Resource` object which provides dot notation and `[]`
access for fields returned in the API response.

```ruby
# Fetch a location
location = Ohanakapa.location '521d33741974fcdb2b0022b3'
puts location.name
# => "Center on Homelessness"
puts location.fields
# => <Set: {:id, :accessibility, :ask_for, :coordinates, :description, :emails, :faxes, :hours, :name, :phones, :short_desc, :transportation, :urls, :address, :mail_address, :contacts, :updated_at, :organization, :services, :url, :other_locations}>
puts location[:address]
# => {
city: "Belmont",
state: "CA",
street: "472 Harbor Blvd.",
zip: "94002"
}
```

**Note:** URL fields are culled into a separate `.rels` collection for easier
[Hypermedia](#hypermedia-agent) support.

```ruby
# Fetch an organization
org = Ohankapa.organization '521d32b91974fcdb2b000002'
org.rels[:locations].href
# => "http://ohanapi.herokuapp.com/api/organizations/521d32b91974fcdb2b000002/locations"
```

### Accessing HTTP responses

While most methods return a `Resource` object or a Boolean, sometimes you may
need access to the raw HTTP response headers. You can access the last HTTP
response with `Client#last_response`:

```ruby
location  = Ohanakapa.location '521d32b91974fcdb2b000002'
response  = Ohanakapa.last_response
etag      = response.headers[:etag]
```

## Authentication

Ohanakapa supports the API Token method supported by the Ohana
API:

### Application authentication

Ohanakapa supports application-only authentication using API Token application client
credentials. Using application credentials will result in making API calls on behalf of an application in order to take advantage of
the higher rate limit.

```ruby
client = Ohanakapa::Client.new(:api_token => "<your 32 char token>")

location = client.locations '521d32b91974fcdb2b000002'
```

## Configuration and defaults

While `Ohanakapa::Client` accepts a range of options when creating a new client
instance, Ohanakapa's configuration API allows you to set your configuration
options at the module level. This is particularly handy if you're creating a
number of client instances based on some shared defaults.

### Configuring module defaults

Every writable attribute in {Ohanakapa::Configurable} can be set one at a time:

```ruby
Ohanakapa.api_endpoint = 'http://api.ohana.dev'
Ohanakapa.web_endpoint = 'http://ohana.dev'
```

or in batch:

```ruby
Ohanakapa.configure do |c|
  c.api_endpoint = 'http://api.ohana.dev'
  c.web_endpoint = 'http://ohana.dev'
end
```

### Using ENV variables

Default configuration values are specified in {Ohanakapa::Default}. Many
attributes will look for a default value from the ENV before returning
Ohanakapa's default.

```ruby
# Given $OHANAKAPA_API_ENDPOINT is "http://api.ohana.dev"
Ohanakapa.api_endpoint

# => "http://api.ohana.dev"
```

## Hypermedia agent

Ohanakapa is [hypermedia][]-enabled. Under the hood,
{Ohanakapa::Client} uses [Sawyer][], a hypermedia client built on [Faraday][].

### Hypermedia in Ohanakapa

Resources returned by Ohanakapa methods contain not only data but hypermedia
link relations:

```ruby
org = Ohanakapa.organization '521d32b91974fcdb2b000002'

# Get the locations rel, returned from the API
# as locations_url in the resource
org.rels[:locations].href
# => "http://ohanapi.herokuapp.com/api/organizations/521d32b91974fcdb2b000002/locations"

locations = org.rels[:locations].get.data
locations.last.name
# => "Vocational Rehabilitation Services (VRS) Workcenter"
```

When processing API responses, all `*_url` attributes are culled in to the link
relations collection. Any `url` attribute becomes `.rels[:self]`.

### URI templates

You might notice many link relations have variable placeholders. Ohanakapa
supports [URI Templates][uri-templates] for parameterized URI expansion:

```ruby
org = Ohanakapa.organization '521d33741974fcdb2b002289'
rel = org.rels[:locations]
# => #<Sawyer::Relation: locations: get http://ohanapi.herokuapp.com/api/organizations/521d33741974fcdb2b002289/locations>

# Get a page of locations
org.rels[:locations].get.data

# Get issue #2
repo.rels[:issues].get(:uri => {:number => 2}).data
```

### The Full Hypermedia Experience™

If you want to use Ohanakapa as a pure hypermedia API client, you can start at
the API root and and follow link relations from there:

```ruby
root = Ohanakapa.root
root.rels[:repository].get :uri => {:owner => "ohanakapa", :repo => "ohanakapa.rb" }
```


[hypermedia]: http://en.wikipedia.org/wiki/Hypermedia
[Sawyer]: https://github.com/lostisland/sawyer
[Faraday]: https://github.com/lostisland/faraday
[uri-templates]: http://tools.ietf.org/html/rfc6570

## Advanced usage

Since Ohanakapa employs [Faraday][faraday] under the hood, some behavior can be
extended via middleware.

### Debugging

Often, it helps to know what Ohanakapa is doing under the hood. Faraday makes it
easy to peek into the underlying HTTP traffic:

```ruby
stack = Faraday::Builder.new do |builder|
  builder.response :logger
  builder.use Ohanakapa::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Ohanakapa.middleware = stack
Ohanakapa.location '521d33741974fcdb2b0022ab'
```
```
I, [2013-08-29T23:37:58.314434 #26983]  INFO -- : get http://ohanapi.herokuapp.com/api/locations/521d33741974fcdb2b0022ab
D, [2013-08-29T23:37:58.314535 #26983] DEBUG -- request: Accept: "application/vnd.ohanapi-v1+json"
User-Agent: "Ohanakapa Ruby Gem 1.0.0"
I, [2013-08-29T23:37:58.706479 #26983]  INFO -- Status: 200
D, [2013-08-29T23:37:58.706565 #26983] DEBUG -- response: cache-control: "max-age=0, private, must-revalidate"
content-type: "application/json"
date: "Fri, 30 Aug 2013 06:37:58 GMT"
etag: "\"bce45b81bf5b2e01cabf2c24308ac140\""
status: "200 OK"
x-rack-cache: "miss"
x-ratelimit-limit: "60"
x-ratelimit-remaining: "59"
x-request-id: "2ad07e30d8e53c25e9e364254d69b34b"
x-runtime: "0.037184"
x-ua-compatible: "IE=Edge,chrome=1"
content-length: "3961"
connection: "Close"
...
```

See the [Faraday README][faraday] for more middleware magic.

### Caching

If you want to boost performance, stretch your API rate limit, or avoid paying
the hypermedia tax, you can use [Faraday Http Cache][cache].

Add the gem to your Gemfile

    gem 'faraday-http-cache'

Next, construct your own Faraday middleware:

```ruby
stack = Faraday::Builder.new do |builder|
  builder.use Faraday::HttpCache
  builder.use Ohanakapa::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Ohanakapa.middleware = stack
```

Once configured, the middleware will store responses in cache based on ETag
fingerprint and serve those back up for future `304` responses for the same
resource. See the [project README][cache] for advanced usage.


[cache]: https://github.com/plataformatec/faraday-http-cache
[faraday]: https://github.com/lostisland/faraday

## Hacking on Ohanakapa

If you want to hack on Ohanakapa locally, we try to make [bootstrapping the
project][bootstrapping] as painless as possible. Just clone and run:

    script/bootstrap

This will install project dependencies and get you up and running. If you want
to run a Ruby console to poke on Ohanakapa, you can crank one up with:

    script/console

Using the scripts in `./scripts` instead of `bundle exec rspec`, `bundle
console`, etc.  ensures your dependencies are up-to-date.

### Running and writing new tests

Ohanakapa uses [VCR][] for recording and playing back API fixtures during test
runs. These fixtures are part of the Git project in the `spec/cassettes`
folder. For the most part, tests use an authenticated client, using a token
stored in `ENV['OHANAKAPA_TEST_API_TOKEN']`. If you're not recording new
cassettes, you don't need to have this set. If you do need to record new
cassettes, this token can be any Ohana API token because the test suite strips
the actual token from the cassette output before storing to disk.

Since we periodically refresh our cassettes, please keep some points in mind
when writing new specs.

* **Specs should be idempotent**. The HTTP calls made during a spec should be
  able to be run over and over. This means deleting a known resource prior to
  creating it if the name has to be unique.
* **Specs should be able to be run in random order.** If a spec depends on
  another resource as a fixture, make sure that's created in the scope of the
  spec and not depend on a previous spec to create the data needed.
* **Do not depend on authenticated user info.** Instead of asserting
  actual values in resources, try to assert the existence of a key or that a
  response is an Array. We're testing the client, not the API.

[bootstrapping]: http://wynnnetherland.com/linked/2013012801/bootstrapping-consistency
[VCR]: https://github.com/vcr/vcr

## Submitting a Pull Request

0. Check out [Hacking on Ohanakapa](https://github.com/codeforamerica/ohanakapa-ruby#hacking-on-ohanakapa) in the README guide for
   bootstrapping the project for local development.
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add specs for your unimplemented feature or bug fix.
4. Run `bundle exec rspec-queue spec`. If your specs pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rspec-queue spec`. If your specs fail, return to step 5.
7. Run `open coverage/index.html`. If your changes are not completely covered
   by your tests, return to step 3.
8. Add documentation for your feature or bug fix.
9. Run `bundle exec rake doc:yard`. If your changes are not 100% documented, go
   back to step 8.
10. Add, commit, and push your changes.
11. [Submit a pull request.][pr]

[fork]: https://help.github.com/articles/fork-a-repo
[branch]: http://learn.github.com/p/branching.html
[pr]: https://help.github.com/articles/using-pull-requests


## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby
implementations:

* Ruby 1.9.2
* Ruby 1.9.3
* Ruby 2.0.0

If something doesn't work on one of these Ruby versions, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be responsible for providing patches in a timely
fashion. If critical issues for a particular implementation exist at the time
of a major release, support for that Ruby version may be dropped.

[travis]: https://travis-ci.org/ohanakapa/ohanakapa.rb

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver]. Violations
of this scheme should be reported as bugs. Specifically, if a minor or patch
version is released that breaks backward compatibility, that version should be
immediately yanked and/or a new version should be immediately released that
restores compatibility. Breaking changes to the public API will only be
introduced with new major versions. As a result of this policy, you can (and
should) specify a dependency on this gem using the [Pessimistic Version
Constraint][pvc] with two digits of precision. For example:

    spec.add_dependency 'ohanakapa', '~> 1.0'

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74

## Copyright
Copyright (c) 2013 Code for America. See [LICENSE](https://github.com/codeforamerica/ohana-api/blob/master/LICENSE.md) for details. This wrapper is based on the excellent [GitHub Ruby API wrapper](https://github.com/octokit/octokit.rb), which is Copyright (c) 2009-2013 Wynn Netherland, Adam Stacoviak, Erik Michaels-Ober.