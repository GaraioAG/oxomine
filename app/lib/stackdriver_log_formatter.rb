class StackdriverLogFormatter < ActiveSupport::Logger::SimpleFormatter
  def call(severity, _timestamp, _progname, msg)
    "#{severity}: #{msg.is_a?(String) ? msg : msg.inspect}\n"
  end
end
