class String

  def email?
    self == self.scan(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i)[0]
  end

  def shuffle
    self.split('').shuffle.join()
  end
end