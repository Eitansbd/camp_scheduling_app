# calendar.rb

module CalendarData
  def add_calendar(dates_array)
    sql = "INSERT INTO days (calendar_date) VALUES "
    sql_values = dates_array.map.with_index { |_, index| "($#{index + 1})" }.join(", ")
    sql = sql + sql_values

    @db.exec_params(sql, dates_array.map(&:to_s))
  end

    # Remove a day from the calendar
  def remove_day(calendar_date)
    sql = "DELETE FROM days WHERE calendar_date = $1;"
    query(sql, calendar_date)
  end
end