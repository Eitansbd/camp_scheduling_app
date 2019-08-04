require 'pg'
require 'time'

require_relative 'activity.rb'
require_relative 'bunk.rb'
require_relative 'daily_schedule.rb'
require_relative 'division.rb'
require_relative 'time_slots.rb'
require_relative 'calendar.rb'

class ScheduleDatabase
  include ActivityData
  include BunkData
  include DailyScheduleData
  include DivisionData
  include TimeSlotData
  include CalendarData

  def initialize(logger)
    if ENV["RACK_ENV"] == "test"
      @db = PG.connect(dbname: "camp_test")
    else
      @db = PG.connect(dbname: "camp")  # Opens the connection to the local database
    end
    @logger = logger   # Logger to log database activity
  end

  # Add a date to the days table
  def add_date(date)
    sql = "INSERT INTO days (calendar_date) VALUES ($1);"
    query(sql, date)
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

  def get_days_in_current_session # retrieves the days in the current year summer month
    sql =<<~SQL
        SELECT DISTINCT d.id, d.calendar_date, s.id IS NOT NULL AS scheduled
          FROM days AS d
          LEFT OUTER JOIN schedule AS s
               ON s.day_id = d.id
         WHERE date_part('year', d.calendar_date) = date_part('year', CURRENT_DATE)
         ORDER BY d.calendar_date;
      SQL
    results = query(sql)
    results.map do |tuple|
      {
        id: tuple["id"].to_i,
        calendar_date: Date.parse(tuple["calendar_date"]),
        scheduled: tuple["scheduled"] == 't' ? true : false
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


  private

  def query(statement, *params)
    #@logger.info("#{statement}: #{params}")
    @db.exec_params(statement, params)
  end
end
