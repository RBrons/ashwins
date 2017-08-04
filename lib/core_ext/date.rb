class Date
  def usa
    self.in_time_zone("Eastern Time (US & Canada)")
  end

  def days_gone
    ((Time.zone.parse(self.to_s) - Time.zone.now) / 1.day).round
  end

  def to_string
    self.strftime('%d %B %Y')
  end

end