module CompassHelper
  def two_number_format(number)
    if number.to_s.size == 1
      "0#{number}"
    else
      number
    end
  end

  def get_hours_minutes_and_seconds(time)
    time = time.to_i
    hours = time / 3600
    hours_in_seconds = hours * 3600
    minutes = (time - hours_in_seconds) / 60
    minutes_in_seconds = minutes * 60
    seconds = time - (hours_in_seconds + minutes_in_seconds)
    [hours, minutes, seconds]
  end
end
