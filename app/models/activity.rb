class Activity
  attr_reader :name, :location, :max_bunks, :id, :youngest_division, :oldest_division, :double

  def initialize(name, location = "", id=nil)
    @id = id
    @name = name
    @location = location
  end

  def set_activity_parameters(max_bunks, youngest_division = "Hey",
                              oldest_division = "Daled", double = "false")
    @max_bunks = max_bunks
    @youngest_division = youngest_division
    @oldest_division = oldest_division
    @appropriate_divisions = divisions_between(youngest_division, oldest_division)
    @double = (double == 't')
    self
  end

  def for_division?(division)
    @appropriate_divisions.include?(division)
  end

  def double?
    @double
  end

  def ==(other_activity)
    self.name == other_activity.name
  end

  def reached_maximum_bunk_capacity?

  end

  private

  def divisions_between(youngest_division, oldest_division)
    divisions = ["Hey", "Aleph", "Bet", "Gimmel", "Daled"] # This should really be taken from database
    youngest_index = divisions.index(youngest_division)
    oldest_index = divisions.index(oldest_division)
    divisions[youngest_index..oldest_index]
  end
end

module ActivityData
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
    activity_data = result.first

    instantiate_activity(activity_data)
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

  def delete_activity(id)
    query("DELETE FROM activities WHERE id = $1", id)
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
      instantiate_activity(tuple)
    end
  end

  private

  def instantiate_activity(data)
    activity = Activity.new(data["name"],
                 data["location"],
                 data["id"].to_i)

    activity.set_activity_parameters(data["max_bunks"].to_i,
                                     data["youngest_division_name"],
                                     data["oldest_division_name"],
                                     data["double"])
  end
end