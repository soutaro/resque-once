class TestJob
  def self.perform(message, raise_error = false)
    raise("TestError: #{message}") if raise_error
    STDOUT.puts "TestJob: #{message}"
  end

  def self.on_failure(*args)
    pp args
  end
end
