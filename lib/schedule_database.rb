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
    sql = "INSERT INTO bunks (name, division, gender) VALUES ($1, $2, $3);"
    query(sql, name, division, gender)
  end

  # accesses a bunk form the db and returns a new bunk object.
  # Works
  def load_bunk(id)
    sql = "SELECT * FROM bunks WHERE id = $1"
    result = query(sql, id)

    tuple = result.first

    Bunk.new(tuple["id"], tuple["name"], tuple["division"], tuple["gender"])
  end

  def add_activity(activity)
    name = activity.name
    location = activity.location
    youngest_division = activity.youngest_division
    oldest_division = activity.oldest_division
    max_bunks = activity.max_bunks
    sql = "INSERT INTO activities (name, location, youngest_division, oldest_division, max_bunks) VALUES ($1, $2, $3, $4, $5);"
    query(sql, name, location, youngest_division, oldest_division, max_bunks)
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
  def get_daily_schedule(date)
    sql = <<~SQL
        SELECT b.name AS bunk_name, b.division,
               b.gender, a.name AS activity,
               a.location, t.start_time, t.end_time
        FROM schedule AS s
        JOIN bunks AS b ON s.bunk_id = b.id
        JOIN activities AS a ON s.activity_id = a.id
        JOIN time_slots AS t ON s.time_slot_id = t.id
        JOIN days AS d ON s.day_id = d.id
        WHERE day_id = $1
        ORDER BY b.name;
      SQL
      results = query(sql, date)
      results.map do |tuple|
        { bunk_name: tuple["bunk_name"],
          division: tuple["division"],
          gender: tuple["gender"],
          activity: tuple["activity"],
          location: tuple["location"],
          start_time: tuple["start_time"],
          end_time: tuple["end_time"]
        }
    end
  end

  # Get a list of all of the activites, return an array of activity objects
  # Works
  def all_activities
    result = query("SELECT * FROM activities;")
    activities = []
    result.each do |tuple|
      activities << Activity.new(tuple["name"], tuple["location"], tuple["youngest_division"], tuple["oldest_division"], tuple["max_bunks"])
    end
    activities
  end

  # Get a list of all of the bunks, returns an array of all of the bunk objects.
  # Works
  def all_bunks
    results = query("SELECT * FROM bunks;")
    bunks = []
    results.each do |tuple|
      bunks << Bunk.new(tuple["id"], tuple["name"], tuple["division"], tuple["gender"])
    end
    bunks
  end

  # Gets list of all of the time slots, returns a nested array with the starting and ending time
  def all_time_slots
    results = query("SELECT * FROM time_slots;")
    time_slots = []
    results.each do |tuple|
      time_slots << [tuple["start_time"], tuple["end_time"]]
    end
    time_slots
  end

  private

  def query(statement, *params)
    #@logger.info("#{statement}: #{params}")
    @db.exec_params(statement, params)
  end
end