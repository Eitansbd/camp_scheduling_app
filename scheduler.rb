require 'pry'

require_relative 'schedule_database'

class Bunk
  attr_reader :name, :todays_schedule, :division, :gender

  def initialize(name, division = "Hey", gender = "M")
    @name = name
    @division = division
    @gender = gender
    @default_activities = { 7  => Activity.new("Shacharit"),
                            12 => Activity.new("Lunch"),
                            10 => Activity.new("Shiur") }
    @todays_schedule = {}
  end

  def default_activity(start_time)
    @default_activities[start_time]
  end

  def default_activity=(start_time, activity)
    #change the default activity for a bunk
  end

  def valid_activity?(activity)
    # determine if an activity is valid, based on
    !@todays_schedule.include?(activity)
  end

  def add_to_schedule(time, activity)
    @todays_schedule[time] = activity
  end

  def activity_at(time_slot)
    @todays_schedule[time_slot]
  end

  def schedule_default_activities
    @default_activities.each do |time, activity|
      self.add_to_schedule(time, activity)
    end
  end

  def has_activity_scheduled?(time_slot)
    !!activity_at(time_slot)
  end

  def display_schedule
    printing_schedule_format = @todays_schedule.map do |time, activity|
      (activity ? activity.name : "").rjust(12)
    end.join(", ")
    puts "#{name.rjust(3)}: #{printing_schedule_format}"
  end
end

class Activity
  attr_reader :name

  def initialize(name, location = "", youngest_division = "Hey",
                 oldest_division = "Daled",  max_bunks = 1)
    @name = name
    @appropriate_divisions = divisions_between(youngest_division, oldest_division)
    @location = location
  end

  def for_division?(division)
    @appropriate_divisions.include?(division)
  end

  def to_s
    @name
  end

  def ==(other_activity)
    self.name == other_activity.name
  end

  private

  def divisions_between(youngest_division, oldest_division)
    divisions = ["Hey", "Alpeh", "Bet", "Gimmel", "Daled"]
    youngest_index = divisions.index(youngest_division)
    oldest_index = divisions.index(oldest_division)
    divisions[youngest_index..oldest_index]
  end
end

class DailySchedule

  def initialize(date)
    @date = date
    @time_slots = TIME_SLOTS
    @activities = ACTIVITES
    @bunks = BUNKS
    create_empty_schedule_for_bunks
    schedule_all_activities
  end

  def create_empty_schedule_for_bunks
    @bunks.each do |bunk|
      @time_slots.each do |time_slot|
        bunk.add_to_schedule(time_slot, nil)
      end
    end
  end

  def schedule_all_activities
    insert_all_default_activities
    @bunks.each do |bunk|
      @time_slots.each do |time_slot|
        next if bunk.has_activity_scheduled?(time_slot)
        activity_to_schedule = select_activity(bunk, time_slot)

        bunk.add_to_schedule(time_slot, activity_to_schedule)

        # Schedule similiar bunks based on the assignment
      end
    end
  end

  def select_activity(bunk, time_slot)
    activities = @activities.dup
    remove_activities_bunk_constraints!(activities, bunk)
    remove_activities_time_slot_constraints!(activities, time_slot)

    activities.sample
  end

  def remove_activities_bunk_constraints!(activities, bunk)
    activities.reject! do |activity|
      bunk.todays_schedule.values.include? activity
    end

    activities.select! do |activity|
      activity.for_division?(bunk.division)
    end

  end

  def remove_activities_time_slot_constraints!(activities, time_slot)
    activities.reject! do |activity|
      @bunks.map { |b| b.activity_at(time_slot) }.any? do |scheduled_activity|
        scheduled_activity.equal? (activity)
        # Allows for basketballs at different locations to be scheduled simultaneosly
      end
    end
  end

  def insert_all_default_activities
    @bunks.each do |bunk|
      bunk.schedule_default_activities
    end
  end

  def display_schedule
    puts "  " + @time_slots.map { |slot| slot.to_s.rjust(14) }.join
    @bunks.each do |bunk|
      bunk.display_schedule
    end
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

 # List of activity names
       # ("Lake Toys,Drama,Basketball,Art,Music,Softball,Tennis," +
       #  "Taboon,Chavaya,Hockey,Hockey,Hockey,Hockey,Biking,Volleyball," +
       #  "a1, a2, a3, a4, a5, a6").split(",")

# ACTIVITES = all_activities.map { |name| Activity.new(name) }  # Calls the 'all_activities' method from the API
# BUNKS = all_bunks.to_a.map { |name| Bunk.new(name) } # Calls the bunks_names method from the API
# TIME_SLOTS = all_time_slots # Calls the all_time_slots method from API
#
# todays_schedule = DailySchedule.new("June 16, 2019")
# todays_schedule.display_schedule

db = ScheduleDatabase.new(nil)
#db.add_bunk(Bunk.new("b2"))
p db.all_bunks
