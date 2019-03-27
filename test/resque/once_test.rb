require "test_helper"

class Resque::OnceTest < Minitest::Test
  def queue_name
    @queue_name ||= "test:#{SecureRandom.uuid}"
  end

  def test_queue_and_exit
    worker = Resque::Worker.new(queue_name)
    Resque::Job.create(queue_name, TestJob, "Hello resque")

    o, s = Open3.capture2e({ "QUEUE" => queue_name.to_s }, "rake", "-E", "require '../test/test_job'", "-Rlib/tasks", "resque:once", chdir: Pathname(__dir__).parent.to_s)

    assert s.success?
    assert_match /TestJob: Hello resque/, o
  end

  def test_queue_and_exception
    worker = Resque::Worker.new(queue_name)
    Resque::Job.create(queue_name, TestJob, "Hello resque", true)

    o, s = Open3.capture2e({ "QUEUE" => queue_name.to_s }, "rake", "-E", "require '../test/test_job'", "-Rlib/tasks", "resque:once", chdir: Pathname(__dir__).parent.to_s)

    assert s.success?
    # No message from TestJob.perform
    refute_match /TestJob: Hello resque/, o
    # Puts error message reported from TestJob.on_failure
    assert_match /RuntimeError: TestError: Hello resque/, o

    # No job left in the queue
    assert_nil Resque::Job.reserve(queue_name)
  end
end
