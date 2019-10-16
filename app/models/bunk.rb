# bunk.rb
require_relative 'activity.rb'

class Bunk
  attr_reader :name, :division, :gender, :id, :activity_history

  def initialize(name, division, gender, id = nil)
    @id = id  # Why is this a attribute?
    @name = name
    @division = division
    @gender = gender
    @activity_history = Hash.new([])
  end

  def add_to_activity_history(date, activity)
    @activity_history[date] += [activity]
  end
end

module BunkData
  # accesses a bunk form the db and returns a new bunk object.
  def load_bunk(id)
    sql = <<~SQL
        SELECT b.id, b.name, d.name AS division, b.gender
        FROM bunks AS b
        JOIN divisions AS d
          ON b.division_id = d.id
        WHERE b.id = $1;
      SQL

    result = query(sql, id)

    bunk_data = result.first

    instantiate_bunk(bunk_data)
  end

  # Add a bunk into the database. Bunk object is passed in.
  def add_bunk(bunk)
    name = bunk.name
    division = bunk.division
    gender = bunk.gender

    result = query("SELECT id FROM divisions WHERE name = $1;", division)
    division_id = result.values[0][0]

    sql = "INSERT INTO bunks (name, division_id, gender) VALUES ($1, $2, $3);"
    query(sql, name, division_id, gender)
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

  def delete_bunk(id)
    query("DELETE FROM bunks WHERE id = $1;", id)
  end

  def get_bunk_schedule(bunk_id)  # this one is designed for displaying not storing
    sql = <<~SQL
      SELECT a.name AS activity, a.location, t.start_time, t.end_time
      FROM schedule AS s
      JOIN activities AS a
        ON s.activity_id = a.id
      JOIN time_slots AS t
        ON t.id = s.time_slot_id
      WHERE bunk_id = $1 AND day_id = (SELECT id FROM days WHERE calendar_date = CURRENT_DATE)
      ORDER BY t.start_time;
    SQL

    results = query(sql, bunk_id)
    results.map do |tuple|
      {
        "Activity" => tuple["activity"],
        "Location" => tuple["location"],
        "Start Time" => tuple["start_time"],
        "End Time" => tuple["end_time"]
      }
    end
  end

  # def get_bunk_schedule_

  # Get a list of all of the bunks, returns an array of all of the bunk objects.
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
      instantiate_bunk(tuple)
    end
  end

  def load_bunk_with_activity_history(bunk_id)
    bunk = load_bunk(bunk_id)

    populate_bunk_activity_history(bunk)

    bunk
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

  private

  def instantiate_bunk(bunk_data)
    name = bunk_data["name"]
    division = bunk_data["division"]
    gender = bunk_data["gender"]
    id = bunk_data["id"].to_i

    Bunk.new(name, division, gender, id)
  end
end