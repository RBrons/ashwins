def nil_or_zero(data)
  return true if data == false
  return true if data.nil?
  return true if data.to_i == 0
  return false
end