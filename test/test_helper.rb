$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "resque/once"
require "resque"
require "open3"
require "test_job"
require "securerandom"

require "minitest/autorun"
