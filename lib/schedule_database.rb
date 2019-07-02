require 'pg'
require 'pry'

class ScheduleDatabase
  def initialize(logger)
    @db = PG.connect(dbname: "camp")  # Opens the connection to the local database
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

    youngest_division_result = query("SELECT id FROM divisions WHERE name = $1;", youngest_division)
    youngest_division_id = youngest_division_result.values[0][0]

    oldest_division_result = query("SELECT id FROM divisions WHERE name = $1;", oldest_division)
    oldest_division_id = oldest_division_result.values[0][0]

    sql = "INSERT INTO activities (name, location, youngest_division_id, oldest_division_id, max_bunks) VALUES ($1, $2, $3, $4, $5);"
    query(sql, name, location, youngest_division_id, oldest_division_id, max_bunks)
  end

  # Add a time slot to the time_slot table
  def add_time_slot(name, start_time, end_time)
    sql = "INSERT INTO time_slots (name, start_time, end_time) VALUES ($1, $2, $3);"
    query(sql, name, start_time, end_time)
  end

  # Add a date to the days table
  def add_date(date)
    sql = "INSERT INTO days (calendar_date) VALUES ($1);"
    query(sql, date)
  end

  # Add an entry to the schedule table, used to built a dailly schedule
  def add_entry_to_schedule(bunk, activity, time_slot, calendar_date)
    sql = "INSERT INTO schedule (bunk_id, activity_id, time_slot_id, day_id) VALUES ($1, $2, $3, $4);"
    query(sql, bunk, activity, time_slot, calendar_date)
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

  # Retrieve a schedule for a specified day, returns an array of hashes
  #  containing all of the activity details in order of bunk name
  def get_daily_schedule(day_id)

    date_result = query("SELECT calendar_date FROM days WHERE id = $1", day_id)
    calendar_date = date_result.values[0][0]

    sql = <<~SQL
        SELECT b.id, b.name AS bunk_name, div.name AS division,
               b.gender, a.name AS activity,
               a.location, t.start_time, t.end_time
        FROM schedule AS s
        JOIN bunks AS b ON s.bunk_id = b.id
        JOIN activities AS a ON s.activity_id = a.id
        JOIN time_slots AS t ON s.time_slot_id = t.id
        JOIN days AS d ON s.day_id = d.id
        JOIN divisions AS div ON b.division_id = div.id
        WHERE day_id = $1
        ORDER BY t.start_time;
      SQL

    results = query(sql, day_id)
    results.map do |tuple|
      { 
        date: calendar_date,
        bunk_name: tuple["bunk_name"],
        bunk_id: tuple["id"],
        division: tuple["division"],
        gender: tuple["gender"],
        activity: tuple["activity"],
        location: tuple["location"],
        start_time: tuple["start_time"],
        end_time: tuple["end_time"]
      }
    end
  end

  def get_bunk_schedule(bunk_id, day_id)
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
    sql = "SELECT * FROM days WHERE date_part('year', calendar_date) = date_part('year', CURRENT_DATE);"
    query(sql)
  end

  # Get a list of all of the activites, return an array of activity objects
  # Works
  def all_activities
    result = query("SELECT * FROM activities;") # Needs serious fixing
    activities = []
    result.each do |tuple|
      activities << Activity.new(tuple["name"], tuple["location"], tuple["youngest_division"], tuple["oldest_division"], tuple["max_bunks"])
    end
    activities
  end

  # Get a list of all of the bunks, returns an array of all of the bunk objects.
  # Works
  def all_bunks(gender)
  sql = <<~SQL
      SELECT b.name, d.name AS division, b.gender, b.id
      FROM bunks AS b
      JOIN divisions AS d
        ON b.division_id = d.id
      WHERE b.gender = $1
      ORDER BY b.name;
    SQL

    results = query(sql, gender) 
    bunks = []
    results.each do |tuple|
      bunks << Bunk.new(tuple["name"], tuple["division"], tuple["gender"], tuple["id"])
    end
    bunks
  end

  # Gets list of all of the time slots, returns a nested array with the starting and ending time
  def all_time_slots
    results = query("SELECT * FROM time_slots;")
    time_slots = []
    results.each do |tuple|
      time_slots << tuple["start_time"] #, tuple["end_time"]] # Maybe add the end time also
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
    names = []
    results.each do |tuple|
      names << tuple["name"]
    end
    names
  end

  private

  def query(statement, *params)
    #@logger.info("#{statement}: #{params}")
    @db.exec_params(statement, params)
  end
end
