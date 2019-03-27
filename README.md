# Resque::Once

> Let worker process exit once it executed a job.

## Why we need this

Resque and other background job managers do two things.

1. Fetch a job from the queue and execute it.
2. Keep worker processes executing jobs.

This gem makes Resque do 1, but leave 2 for others, something called auto-scaling.

Modern web app infrastructure provides a functionality called auto-scaling, which keeps the number of processes as you specify. When your worker process exits, the functionality spawns new container, or maybe a computer instance, to execute the next job. It means Resque itself does not need to keep a worker process running.

If you are using container-based infrastructure, ECS or Fargate in AWS, this allows using fresh container on each job. This is sometimes essential to keep each container start with fresh status; no access to files used in the previous job processed.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resque-once'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resque-once

If you are working on non-Rails application, load the tasks from your `Rakefile`.

```ruby
require "resque/once/tasks"
```

## Usage

Use the `resque:once` rake task to start the job.

	$ rake resque:once

It immediately exits once it executed a job. To keep Resque processing the jobs, you need to re-spawn the worker.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/soutaro/resque-once.
