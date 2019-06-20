

class Bunk
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def has_default_activity?(time_slot)
    default_activities
    # check the time_slot if it's a default time slot
    #   if yes -- returns the activity for that time slot
    #   if no --
  end

  def default_activity(time_slot)

  end
end

class Activity
  def initialize(name)
    @name = name
  end

  def available?(time)
    true
    # returns true if the activity can be schedule during this
    # time slot.
  end
end

ACTIVITES = [Activity.new("lake"),
             Activity.new("Basketball"),
             Activity.new("Lunch"),
             Activity.new("Dinner")].shuffle
BUNKS = [Bunk.new("B1"), Bunk.new("B2"), Bunk.new("B3"), Bunk.new("B4")]
class TimeSlot
  attr_reader :time

  def initialize(start_time, end_time)
    @time = [start_time, end_time]
    @available_activities = generate_activities_list
  end

  def generate_activities_list
    available_activities = []
    ACTIVITES.each do |activity|
      available_activities << activity if activity.available?(time)
    end

    available_activities
  end

  def assign_activities
    @bunk_activities = {}
    BUNKS.each do |bunk|
      activity = bunk.default_activity(time)
      if activity
        @bunk_activities[bunk.name] = activity
      else
        @bunk_activities[bunk.name] = @available_activities.pop
      end
    end
  end
end

class DailySchedule
  def initialize(date)
    @date = date
    populate_time_slots
  end

  def populate_time_slots
    slots = [TimeSlot.new(10, 11), TimeSlot.new(11, 12), TimeSlot.new(1, 2)]
    slots.each do |time_slot|
      time_slot.assign_activities
    end

    p slots
  end
end


class Calendar
  def initialize
    @schedules = []
  end

  def create_schedule(date)
    todays_schedule = DailySchedule.new(date)
  end
end

DailySchedule.new("June 16, 2019")


