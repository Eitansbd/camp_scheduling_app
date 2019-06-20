require 'pg'

class ScheduleDatabase
  def initialize(logger)
    @db = PG.connect(dbname: "camp")
    @logger = logger
  end

  def add_bunk(name, division, gender)
    sql = "INSERT INTO bunks (name, division, gender) VALUES ($1, $2, $3);"
    query(sql, name, division, gender)
  end

  def add_activity(name, location)
    sql = "INSERT INTO activities (name, location) VALUES ($1, $2);"
    query(sql, name, location)
  end

  def add_time_slot(start_time, end_time)
    sql = "INSERT INTO time_slots (start_time, end_time) VALUES ($1, $2);"
    query(sql, start_time, end_time)
  end

  def add_date(date)
    sql = "INSERT INTO days (calendar_date) VALUES ($1);"
    query(sql, date)
  end

  def add_entry_to_schedule(bunk, activity, time_slot, calendar_date)
    sql = "INSERT INTO schedule (bunk_id, activity_id, time_slot_id, day_id) VALUES ($1, $2, $3, $4);"
    query(sql, bunk, activity, time_slot, calendar_date)
  end

  def remove_bunk(name)
    sql = "DELETE FROM bunks WHERE name = $1;"
    query(sql, name)
  end

  def remove_activity(name)
    sql = "DELETE FROM activities WHERE name = $1;"
    query(sql, name)
  end

  def remove_entry_from_schedule(bunk, time_slot, date)
    sql = "DELETE FROM schedule WHERE bunk_id = $1 AND time_slot_id = $2 AND day_id = $3;"
    query(sql, bunk, time_slot, date)
  end

  def remove_day(calendar_date)
    sql = "DELETE FROM days WHERE calendar_date = $1;"
    query(sql, calendar_date)
  end

  def remove_time_slot(start_time, end_time)
    sql = "DELETE FROM time_slots WHERE start_time = $1 AND end_time = $2;"
    query(sql, start_time, end_time)
  end

  def get_daily_schedule(date)
    sql = <<~SQL
        SELECT b.name AS bunk_name, b.division,
               b.gender, a.name AS activity,
               a.location, t.start_time, t.end_time
        FROM schedule AS s
        JOIN bunk AS b ON s.bunk_id = b.id
        JOIN acitivity AS a ON s.activity_id = a.id
        JOIN time_slot AS t ON s.time_slot_id = t.id
        JOIN days AS d ON s.day_id = d.id
        WHERE day_id = $1
        ORDER BY b.name;
      SQL
      query(sql, date)
    end

  private

  def query(statement, *params)
    #@logger.info("#{statement}: #{params}")
    @db.exec_params(statement, params)
  end
end

#ScheduleDatabase.new(nil).add_bunk("11:00:00", "12:00:00")
