class Time
  def usa
    self.in_time_zone("Eastern Time (US & Canada)")
  end

  def to_string
    self.strftime('%d %B %Y')
  end

end