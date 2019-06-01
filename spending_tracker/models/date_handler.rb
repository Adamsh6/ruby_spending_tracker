require('date')

class DateHandler

  def self.last_six_months
    date = Date.today
    # Sanitises date to allow for variable month sizes
    if date.day > 28
      date -= 3
    end
    month_array = []
    6.times do
      #Gets date in YY-MM format
      month_array << date.strftime('%Y-%m')
      #Reduces date by 1
      date = date << 1
    end
    return month_array
  end

  #Returns 1 if first month is more recent than second
  #Returns 0 if months are equivalent
  #Returns -1 if first month is less recent than second
  #Must take in first month in YYYY-MM format and second in YYYY-MM-DD format
  def self.compare_month(date_string, comparison_date_string)
    date = Date.parse(date_string + '-01')
    comparison_date = Date.parse(comparison_date_string)
    if date.year.to_i > comparison_date.year.to_i
      return 1
    elsif date.year.to_i < comparison_date.year.to_i
      return -1
    end

    if date.month.to_i > comparison_date.month.to_i
      return 1
    elsif date.month.to_i < comparison_date.month.to_i
      return -1
    else
      return 0
    end
  end
end
