#daily_schedule.rb

class DailySchedule
  attr_reader :bunks, :time_slots, :schedule, :day_id

  def initialize(day_id, time_slots, activities, bunks, new_schedule=false) # should rename to date_id
    @day_id = day_id
    @time_slots = time_slots #.map{ |slot| slot.last }
    @activities = activities
    @bunks = bunks
    @schedule = {}
    @time_slots.each do |time_slot_id, _|
      @schedule[time_slot_id] = {}
    end
  end

  def schedule_all_activities
    @bunks.each do |bunk|
      @time_slots.each do |time_slot_id,_|
        next if bunk_has_activity_scheduled?(bunk, time_slot_id)

        activity_to_schedule = select_activity(bunk, time_slot_id)

        add_to_schedule(time_slot_id, bunk, activity_to_schedule)

        # schedule_dependent_activities(time_slot, bunk, activity_to_schedule)
      end
    end
  end

  def add_to_schedule(time_slot_id, bunk, activity_to_schedule)
    @schedule[time_slot_id][bunk] = activity_to_schedule
  end

  def display_schedule
    string = ""
    @schedule.each do |time_slot, slot_schedule|
      string << (time_slot.keys.first + "\n")
      slot_schedule.each do |bunk, activity|
        string << (bunk.name + " : " + activity.name + "\n")
      end
    end
    string
  end

  private

  def bunk_has_activity_scheduled?(bunk, time_slot_id)
    !!@schedule[time_slot_id] && !!@schedule[time_slot_id][bunk]
  end

  def select_activity(bunk, time_slot_id)
    activities = @activities.dup
    remove_activities_bunk_constraints!(activities, bunk)
    remove_activities_time_slot_constraints!(time_slot_id, activities, bunk)

    activities.sample
  end

  def remove_activities_bunk_constraints!(activities, bunk)
    # rejects actvities that the bunk already has that day
    activities.reject! do |activity|
      @schedule.any? do |_, slot_schedule|
        slot_schedule[bunk] == activity
      end
    end

    # rejects activities that aren't for this bunks division
    activities.select! do |activity|
      activity.for_division?(bunk.division)
    end
  end


  def schedule_dependent_activities(activity, bunk, time_slot)
    return nil if activity.reached_maximum_capacity?

  end

  def remove_activities_time_slot_constraints!(time_slot_id, activities, bunk)

    # rejects activities that are already scheduled
    activities.reject! do |activity|
      @schedule[time_slot_id].values.any? do |schedule_activity|
        schedule_activity.equal?(activity)
      end
    end

    # rejects activities that require multiple slots and can't be filled

    next_time_slot_id = next_time_slot_id(time_slot_id)

    activities.reject! do |activity|
      activity.double? &&
      (last_activity?(time_slot_id) ||
      bunk_has_activity_scheduled?(bunk, next_time_slot_id))
    end
  end

  def last_activity?(time_slot_id)
    next_time_slot_id = next_time_slot_id(time_slot_id)
    @schedule[next_time_slot_id] == nil
  end

  def next_time_slot_id(time_slot_id)
    time_slot_ids = @schedule.keys
    next_time_slot_index = time_slot_ids.index(time_slot_id) + 1
    time_slot_ids[next_time_slot_index]
  end
end

module DailyScheduleData
    # Add an entry to the schedule table, used to build a dailly schedule - don't
    # think this is being used, it should be deleted
  # def add_entry_to_schedule(bunk, activity, time_slot, calendar_date)
  #   sql = "INSERT INTO schedule (bunk_id, activity_id, time_slot_id, day_id) VALUES ($1, $2, $3, $4);"
  #   query(sql, bunk, activity, time_slot, calendar_date)
  # end
  
    # Remove a schedule entry
  def remove_entry_from_schedule(bunk, time_slot, date)
    sql = "DELETE FROM schedule WHERE bunk_id = $1 AND time_slot_id = $2 AND day_id = $3;"
    query(sql, bunk, time_slot, date)
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

  def add_default_schedule(default_schedule)

    database_inputs = []

    default_schedule.schedule.each do |time_slot_id, bunks|
      bunks.each do |bunk, activity|
        database_inputs << [bunk.id, activity.id, time_slot_id]
      end
    end

    sql = "INSERT INTO default_schedule (bunk_id, activity_id, time_slot_id) VALUES "
    sql_values = database_inputs.map.with_index do |input_cell, index|
      count = index * 3
      "($#{count + 1}, $#{count + 2}, $#{count + 3})"
    end

    sql = sql + sql_values.join(", ")

    @db.exec_params(sql, database_inputs.flatten)
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
  
  def delete_previous_daily_schedule(day_id)
    query("DELETE FROM schedule WHERE day_id = $1;", day_id)
  end

  def delete_previous_default_schedule
    query("DELETE FROM default_schedule;")
  end
end
