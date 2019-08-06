module TimeSlotData
    # Add a time slot to the time_slot table
  def add_time_slot(start_time, end_time)
    sql = "INSERT INTO time_slots (start_time, end_time) VALUES ($1, $2);"
    query(sql, start_time, end_time)
  end

   # Remove a time slot
  def remove_time_slot(start_time, end_time)
    sql = "DELETE FROM time_slots WHERE start_time = $1 AND end_time = $2;"
    query(sql, start_time, end_time)
  end

  def get_time_slot(time_slot_id)
    result = query("SELECT * FROM time_slots WHERE id = $1", time_slot_id)
    time_slot_info = result.tuple(0)
    {time_slot_info["id"] => [time_slot_info["start_time"], time_slot_info["end_time"]]}
  end

  def edit_time_slot(id, start_time, end_time)
    sql = "UPDATE time_slots SET start_time = $1, end_time - $2 WHERE id = $3;"
    query(sql, start_time, end_time, id)
  end

  def delete_time_slot(id)
    query("DELETE FROM time_slots WHERE id = $1;", id)
  end

    # Gets list of all of the time slots, returns a nested array with the starting and ending time
  def all_time_slots  # change to  returns an array of {id: [start_time, end_time]}
    results = query("SELECT * FROM time_slots ORDER BY start_time;")

    time_slots = {}

    results.each do |tuple|
      start_time = Time.strptime(tuple["start_time"], "%T").strftime("%l:%M")
      end_time = Time.strptime(tuple["end_time"], "%T").strftime("%l:%M")
      time_slots[tuple["id"].to_i] = [start_time, end_time]
    end

    time_slots
  end
end