class Array
  def find_next(element)
    index = self.index(element)
    if !index.nil? && self.size != (index + 1)
      self[index+1]
    else
      nil
    end
  end

  def find_previous(element)
    index = self.index(element)
    if !index.nil? && (index - 1) >= 0
      self[index-1]
    else
      nil
    end
  end

end
