class Key < ApplicationRecord
  def _initialize
    if Key.where(:used => false).count < 10000
      500.times do
        _true = true
        begin
          while _true do
            key_is = Time.now.to_f.to_s.gsub('.', '')
            Key.create!(key: key_is)
            _true = false
          end
        rescue Exception => e
          puts e.message
          puts e.backtrace
        end
      end
    end
  end

  class << self
    def unused_key
      key = where(used: false).take
      if key.blank?
        Key.new._initialize
      end
      key = where(used: false).take
      key.update(used: true)
      key.key
    end
  end

end
