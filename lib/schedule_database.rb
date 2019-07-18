require 'pg'
require 'pry'
require 'time'

class ScheduleDatabase
  def initialize(logger)
    if ENV["RACK_ENV"] == "test"
      @db = PG.connect(dbname: "camp_test")
    else
      @db = PG.connect(dbname: "camp")  # Opens the connection to the local database
    end
    @logger = logger   # Logger to log database activity
  end

  # Add a bunk into the database. Bunk object is passed in.
  # Works
  def add_bunk(bunk)
    name = bunk.name
    division = bunk.division
    gender = bunk.gender

    result = query("SELECT id FROM divisions WHERE name = $1;", division)
    division_id = result.values[0][0]

    sql = "INSERT INTO bunks (name, division_id, gender) VALUES ($1, $2, $3);"
    query(sql, name, division_id, gender)
  end

  # accesses a bunk form the db and returns a new bunk object.
  # Works
  def load_bunk(id)
    sql = <<~SQL
        SELECT b.id, b.name, d.name AS division, b.gender
        FROM bunks AS b
        JOIN divisions AS d
          ON b.division_id = d.id
        WHERE b.id = $1;
      SQL

    result = query(sql, id)

    tuple = result.first

    Bunk.new(tuple["name"], tuple["division"], tuple["gender"], tuple["id"])
  end

  def add_activity(activity)
    name = activity.name
    location = activity.location
    youngest_division = activity.youngest_division
    oldest_division = activity.oldest_division
    max_bunks = activity.max_bunks
    double = activity.double

    youngest_division_result = query("SELECT id FROM divisions WHERE name = $1;", youngest_division)
    youngest_division_id = youngest_division_result.values[0][0]

    oldest_division_result = query("SELECT id FROM divisions WHERE name = $1;", oldest_division)
    oldest_division_id = oldest_division_result.values[0][0]

    sql = "INSERT INTO activities (name, location, youngest_division_id, oldest_division_id, max_bunks) VALUES ($1, $2, $3, $4, $5);"
    query(sql, name, location, youngest_division_id, oldest_division_id, max_bunks)
  end

  # Add a time slot to the time_slot table
  def add_time_slot(start_time, end_time)
    sql = "INSERT INTO time_slots (start_time, end_time) VALUES ($1, $2);"
    query(sql, start_time, end_time)
  end

  # Add a date to the days table
  def add_date(date)
    sql = "INSERT INTO days (calendar_date) VALUES ($1);"
    query(sql, date)
  end

  # Add an entry to the schedule table, used to build a dailly schedule
  def add_entry_to_schedule(bunk, activity, time_slot, calendar_date)
    sql = "INSERT INTO schedule (bunk_id, activity_id, time_slot_id, day_id) VALUES ($1, $2, $3, $4);"
    query(sql, bunk, activity, time_slot, calendar_date)
  end

  def add_daily_schedule(daily_schedule)
    day_id = daily_schedule.day_id.to_i

    database_inputs = []

    daily_schedule.schedule.each do |time_slot_id, bunks|
      bunks.each do |bunk, activity|
        database_inputs << [bunk.id, activity.id, time_slot_id, day_id]
      end
    end

    sql = "INSERT INTO schedule (bunk_id, activity_id, time_slot_id, day_id) VALUES "
    sql_values = database_inputs.map.with_index do |input_cell, index|
      count = index * 4
      "($#{count + 1}, $#{count + 2}, $#{count + 3}, $#{count + 4})"
    end

    sql = sql + sql_values.join(", ")

    @db.exec_params(sql, database_inputs.flatten)

  end

  # Remove a bunk from the list
  def remove_bunk(id)
    sql = "DELETE FROM bunks WHERE name = $1;"
    query(sql, id)
  end

  #Remove an activity from the list
  def remove_activity(id)
    sql = "DELETE FROM activities WHERE name = $1;"
    query(sql, id)
  end

  # Remove a schedule entry
  def remove_entry_from_schedule(bunk, time_slot, date)
    sql = "DELETE FROM schedule WHERE bunk_id = $1 AND time_slot_id = $2 AND day_id = $3;"
    query(sql, bunk, time_slot, date)
  end

  # Remove a day from the calendar
  def remove_day(calendar_date)
    sql = "DELETE FROM days WHERE calendar_date = $1;"
    query(sql, calendar_date)
  end

  # Remove a time slot
  def remove_time_slot(start_time, end_time)
    sql = "DELETE FROM time_slots WHERE start_time = $1 AND end_time = $2;"
    query(sql, start_time, end_time)
  end

  def get_daily_schedule(day_id)

    # Creates a dailySchedule object and populate the scheule instance variable with
    # the time_slots, bunks and activities. Returns the daily schedule object

    results = query("SELECT * FROM schedule WHERE day_id = $1", day_id)

    time_slots = all_time_slots

    activities = all_activities

    bunks = all_bunks

    daily_schedule = DailySchedule.new(day_id, time_slots, activities, bunks, new_schedule=false)

    results.each do |tuple|
      time_slot_id = tuple["time_slot_id"].to_i
      bunk = bunks.find { |bunk| bunk.id == tuple["bunk_id"].to_i}
      activity = activities.find { |activity| activity.id == tuple["activity_id"].to_i}
      daily_schedule.schedule[time_slot_id][bunk] = activity
    end

    daily_schedule
  end

  def get_default_schedule

    # Create a DailySchedule object that contains all of the time slots, activities and bunks.
    # The bunks contain info about thier activity history and contains a hash that stores all of the
    #  history info

    activities = all_activities

    bunks = all_bunks

    time_slots = all_time_slots

    default_schedule = DailySchedule.new(0, time_slots, activities, bunks)

    results = query("SELECT * FROM default_schedule;")

    results.each do |tuple|
      time_slot_id = tuple["time_slot_id"].to_i
      bunk = bunks.find { |bunk| bunk.id == tuple["bunk_id"].to_i}
      activity = activities.find { |activity| activity.id == tuple["activity_id"].to_i}
      default_schedule.schedule[time_slot_id][bunk] = activity
    end

    default_schedule
  end

  def get_activity_history
    sql = <<~SQL
      SELECT * FROM schedule AS s
      JOIN days AS d ON d.id = s.day_id
      WHERE date_part('year', calendar_date) = date_part('year', CURRENT_DATE);
    SQL

    results = query(sql)

    results.map do |tuple|
      {
        bunk_id: tuple["bunk_id"].to_i,
        activity_id: tuple["activity_id"].to_i,
        day_id: tuple["date"].to_i
      }
    end
  end

  def populate_bunk_activity_history(bunk)  # For displaying the history
    sql = <<~SQL
        SELECT a.name, a.location, a.id, d.calendar_date
        FROM schedule AS s
        JOIN activities AS a
          ON s.activity_id = a.id
        JOIN days AS d
          ON s.day_id = d.id
        WHERE s.bunk_id = $1
          AND date_part('year', calendar_date) = date_part('year', CURRENT_DATE);
      SQL

    results = query(sql, bunk.id)
    results.each do |tuple|
      activity = Activity.new(tuple["name"], tuple["location"], tuple["id"])
      bunk.add_to_activity_history(tuple["calendar_date"], activity)
    end
  end

  def get_bunk_schedule(bunk_id, day_id)  # this one is designed for displaying not storing
    sql = <<~SQL
      SELECT a.name AS activity, a.location, t.start_time, t.end_time, t.name AS time_slot
      FROM schedule AS s
      JOIN activities AS a
        ON s.activity_id = a.id
      JOIN time_slots AS t
        ON t.id = s.time_slot_id
      WHERE bunk_id = $1 AND day_id = $2
      ORDER BY t.start_time;
    SQL

    results = query(sql, bunk_id, day_id)
    results.map do |tuple|
      {
        "Activity" => tuple["activity"],
        "Location" => tuple["location"],
        "Start Time" => tuple["start_time"],
        "End Time" => tuple["end_time"],
        "Time Slot" => tuple["time_slot"]
      }
    end
  end

  def get_days_in_month # retrieves the days in the current year summer month
    sql = "SELECT * FROM days WHERE date_part('year', calendar_date) = date_part('year', CURRENT_DATE) ORDER BY calendar_date;"
    results = query(sql)
    results.map do |tuple|
      {
        id: tuple["id"].to_i,
        calendar_date: Date.parse(tuple["calendar_date"])
      }
    end
  end

  def get_todays_day_id
    result = query("SELECT id FROM days WHERE calendar_date = CURRENT_DATE;")
    result.ntuples.zero? ? nil : result.values[0][0]
  end

  def get_date_from_day_id(day_id)
    result = query("SELECT calendar_date FROM days WHERE id = $1", day_id)
    result.values[0][0]
  end

  def get_day_id_from_date(date)
    result = query("SELECT id FROM days WHERE calendar_date = $1", date)
    result.values[0][0]
  end

  def get_activity(activity_id)
    sql = <<~SQL
        SELECT a.name, a.location, a.id, youngest.name AS youngest_division_name,
               oldest.name AS oldest_division_name, a.max_bunks, a.double
        FROM activities AS a
        JOIN divisions AS youngest
          ON youngest_division_id = youngest.id
        JOIN divisions AS oldest
          ON oldest_division_id = oldest.id
        WHERE a.id = $1;
      SQL

    result = query(sql, activity_id)
    activity = result.tuple(0)
    Activity.new(activity["name"],
                   activity["location"],
                   activity["id"].to_i).set_activity_parameters(activity["max_bunks"].to_i,
                                                             activity["youngest_division_name"],
                                                             activity["oldest_division_name"],
                                                             activity["double"])
  end

  def get_time_slot(time_slot_id)
    result = query("SELECT * FROM time_slots WHERE id = $1", time_slot_id)
    time_slot_info = result.tuple(0)
    {time_slot_info["id"] => [time_slot_info["start_time"], time_slot_info["end_time"]]}
  end

  def get_division(division_id)
    sql = "SELECT id, name, age FROM divisions WHERE id = $1;"
    result = query(sql, division_id)
    tuple = result.first
    {
      id: tuple["id"],
      name: tuple["name"],
      age: tuple["age"]
    }
  end

  def edit_activity(activity)
    sql = <<~SQL
        UPDATE activities
        SET name = $1, location = $2,
            youngest_division_id = (SELECT id FROM divisions WHERE name = $3),
            oldest_division_id = (SELECT id FROM divisions WHERE name = $4),
            max_bunks = $5, double = $6;
        WHERE id = $7
      SQL

    query(sql, activity.name, activity.location, activity.youngest_division,
          activity.oldest_division, activity.max_bunks, activity.double, activity.id)
  end

  def edit_time_slot(id, start_time, end_time)
    sql = "UPDATE time_slots SET start_time = $1, end_time - $2 WHERE id = $3;"
    query(sql, start_time, end_time, id)
  end

  def edit_division(id, name)
    query("UPDATE divisions SET name = $1 WHERE id = $2;", name, id)
  end

  def edit_bunk(bunk)
    sql = <<~SQL
        UPDATE bunks
           SET name = $1,
               division_id = (SELECT id FROM divisions WHERE name = $2),
               gender = $3
         WHERE id = $4;
      SQL

    query(sql, bunk.name, bunk.division, bunk.gender, bunk.id)
  end

  def delete_activity(id)
    query("DELETE FROM activities WHERE id = $1", id)
  end

  def delete_time_slot(id)
    query("DELETE FROM time_slots WHERE id = $1;", id)
  end

  def delete_division(id)
    query("DELETE FROM divisions WHERE id = $1;", id)
  end

  def delete_bunk(id)
    query("DELETE FROM bunks WHERE id = $1;", id)
  end

  def delete_previous_daily_schedule(day_id)
    query("DELETE FROM schedule WHERE day_id = $1", day_id)
  end

  # Get a list of all of the activites, return an array of activity objects
  # Works
  def all_activities
    sql = <<~SQL
    SELECT a.name, a.location, a.id, youngest.name AS youngest_division_name,
           oldest.name AS oldest_division_name, a.max_bunks, a.double
    FROM activities AS a
    JOIN divisions AS youngest
      ON youngest_division_id = youngest.id
    JOIN divisions AS oldest
      ON oldest_division_id = oldest.id;
    SQL

    result = query(sql)

    result.map do |tuple|
      Activity.new(tuple["name"],
                   tuple["location"],
                   tuple["id"].to_i).set_activity_parameters(tuple["max_bunks"].to_i,
                                                             tuple["youngest_division_name"],
                                                             tuple["oldest_division_name"],
                                                             tuple["double"])
    end
  end

  # Get a list of all of the bunks, returns an array of all of the bunk objects.
  # Works
  def all_bunks
  sql = <<~SQL
      SELECT b.name, d.name AS division, b.gender, b.id
      FROM bunks AS b
      JOIN divisions AS d
        ON b.division_id = d.id
      ORDER BY d.age, b.gender DESC, b.name;
    SQL

    results = query(sql)

    results.map do |tuple|
      Bunk.new(tuple["name"], tuple["division"], tuple["gender"], tuple["id"].to_i)
    end
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

  # Add a new division
  def add_division(name, age)
    sql = "INSERT INTO divisions (name, age) VALUES ($1, $2);"
    query(sql, name, age)
  end

  # Returns a list of all of the divisions ordered by their age
  def all_divisions
    results = query("SELECT * FROM divisions ORDER BY age;")

    results.map do |tuple|
      { id: tuple["id"].to_i,
        name: tuple["name"] }
    end
  end

  private

  def query(statement, *params)
    #@logger.info("#{statement}: #{params}")
    @db.exec_params(statement, params)
  end
end
