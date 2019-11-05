class Activity
  attr_reader :name, :location, :max_bunks, :id, :youngest_age, :oldest_age, :double, :auto_schedule

  def initialize(name, location = "", id=nil)
    @id = id
    @name = name
    @location = location
  end

  def set_activity_parameters(max_bunks, youngest_age,
                              oldest_age, double, auto_schedule)
    @max_bunks = max_bunks
    @youngest_age = youngest_age
    @oldest_age = oldest_age
    @double = (double == 't')
    @auto_schedule = (auto_schedule == 't')
    self
  end

  def for_division?(division)
    # division param is coming from bunk.division which only contains the
    # name of the division. We might need to have the bunk have total access
    # to the division in order for it to work properly
    #division[:age] >= @youngest_age && division[:age] <= @oldest_age
    true
  end

  def double?
    @double
  end

  def ==(other_activity)
    self.name == other_activity.name
  end

  def reached_maximum_bunk_capacity?

  end

  def auto_schedule?
    auto_schedule
  end
end

module ActivityData
  def get_activity(activity_id)
    sql = <<~SQL
        SELECT a.name, a.location, a.id, a.youngest_age, a.oldest_age, a.max_bunks,
               a.double, a.auto_schedule
        FROM activities AS a
        WHERE id = $1
      SQL

    result = query(sql, activity_id)
    activity_data = result.first

    instantiate_activity(activity_data)
  end

  def add_activity(activity)
    name = activity.name
    location = activity.location
    youngest_age = activity.youngest_age
    oldest_age = activity.oldest_age
    max_bunks = activity.max_bunks
    double = activity.double
    auto_schedule = activity.auto_schedule

    sql = "INSERT INTO activities (name, location, youngest_age, oldest_age, max_bunks, double, auto_schedule) VALUES ($1, $2, $3, $4, $5, $6, $7);"
    query(sql, name, location, youngest_age, oldest_age, max_bunks, double, auto_schedule)
  end

  def edit_activity(activity)
    double = activity.double ? "t" : "f"
    auto_schedule = activity.auto_schedule ? "t" : "f"

    sql = <<~SQL
        UPDATE activities
        SET name = $1, location = $2,
            youngest_age = $3,
            oldest_age = $4,
            max_bunks = $5, double = $6, auto_schedule = $7
        WHERE id = $8;
      SQL

    query(sql, activity.name, activity.location, activity.youngest_age,
          activity.oldest_age, activity.max_bunks, double, auto_schedule,
          activity.id)
  end

  def delete_activity(id)
    query("DELETE FROM activities WHERE id = $1", id)
  end
    # Get a list of all of the activites, return an array of activity objects
  # Works
  def all_activities
    sql = <<~SQL
      SELECT a.name, a.location, a.id, a.youngest_age, a.oldest_age, a.max_bunks,
             a.double, a.auto_schedule
      FROM activities AS a
      ORDER BY a.name;
    SQL

    result = query(sql)

    result.map do |tuple|
      instantiate_activity(tuple)
    end
  end

  private

  def instantiate_activity(data)
    activity = Activity.new(data["name"],
                 data["location"],
                 data["id"].to_i)

    activity.set_activity_parameters(data["max_bunks"].to_i,
                                     data["youngest_age"],
                                     data["oldest_age"],
                                     data["double"],
                                     data["auto_schedule"])
  end
end