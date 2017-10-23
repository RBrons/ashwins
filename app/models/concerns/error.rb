class Error
  class << self
    def send e
      ExceptionNotifier.notify_exception(e, :data => {:msg => "Error via exeption handling "}) if Rails.env.production?
    end
    def logger_ e
      my_log ||= Logger.new("#{Rails.root}/log/logger.log")
      puts e.message unless e.message.nil?
      my_log.debug(e.message.try(:join, "\n") || e.message) unless e.message.nil?
      puts e.backtrace unless e.backtrace.nil?
      my_log.debug(e.backtrace.try(:join, "\n") || e.backtrace) unless e.backtrace.nil?
      my_log.debug('**************************************************************************')
    end
  end
end