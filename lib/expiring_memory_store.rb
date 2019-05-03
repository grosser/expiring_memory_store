# frozen_string_literal: true
class ExpiringMemoryStore
  MAX_EXPIRES_IN = 2**32

  def initialize
    @data = {}
    @mutex = Mutex.new
  end

  def get(key)
    _get(key)[1]
  end

  def set(key, value, expires_in: MAX_EXPIRES_IN)
    @data[key] = { value: value, expires_at: now + expires_in }
    value
  end

  def add(key, value, **args)
    @mutex.synchronize do
      return false if _get(key)[0]
      set(key, value, **args)
      return true
    end
  end

  def fetch(key, **args)
    @mutex.synchronize do
      success, value = _get(key)
      return value if success
      value = yield
      set key, value, **args
    end
  end

  # remove everything that is expired to prevent leaking memory over time
  def cleanup
    @mutex.synchronize do
      now = now()
      @data.delete_if { |_key, info| info[:expires_at] < now }
      true
    end
  end

  private

  def _get(key)
    return [false, nil] unless (info = @data[key])
    return [false, nil] unless info[:expires_at] > now
    [true, info[:value]]
  end

  def now
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end
end
