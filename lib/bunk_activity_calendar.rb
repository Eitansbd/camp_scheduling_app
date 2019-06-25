require 'pry'
require_relative 'schedule_database'
class Bunk
  attr_reader :name, :todays_schedule, :division, :gender

  def initialize(name, division = "Hey", gender = "Male", id = nil)
    @id = id  # Why is this a attribute?
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

  def add_to_schedule(time_slot, activity)
    @todays_schedule[time_slot] = activity
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

    "#{name.rjust(3)}: #{printing_schedule_format}"
  end
end

class Activity
  attr_reader :name, :location, :youngest_division, :oldest_division, :max_bunks

  def initialize(name, location = "", youngest_division = "Hey",
                 oldest_division = "Daled",  max_bunks = 1)
    @name = name
    @appropriate_divisions = divisions_between(youngest_division, oldest_division)
    @location = location
    @oldest_division = oldest_division
    @youngest_division = youngest_division
    @max_bunks = max_bunks
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

class DailySchedule
  attr_reader :bunks

  def initialize(date, time_slots = TIME_SLOTS, activities = ACTIVITES, bunks = BUNKS)
    @date = date
    @time_slots = time_slots.map{|slot| slot.first}
    @activities = activities
    @bunks = bunks
    create_empty_schedule_for_bunks
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

        #schedule_dependent_activities(activity_to_schedule, bunk, time_slot)
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

  # def schedule_dependent_activities(activity, bunk, time_slot)
  #   return false if activity.reached_maximum_capacity?


  # end

  def remove_activities_time_slot_constraints!(activities, time_slot)
    activities.reject! do |activity|
      @bunks.any? { |bunk| bunk.activity_at(time_slot).equal? (activity) }
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
    @todays_schedule = DailySchedule.new(date)
  end
end

activity_names = ("Lake Toys,Drama,Basketball,Art,Music,Softball,Tennis," +
                  "Taboon,Chavaya,Hockey,Hockey,Hockey,Hockey,Biking,Volleyball," +
                  "a1, a2, a3, a4, a5, a6").split(",")

ACTIVITES = activity_names.map { |name| Activity.new(name) }
BUNKS = (1..10).to_a.map { |num| Bunk.new("B#{num}") }
TIME_SLOTS = (7..12).to_a + (1..6).to_a
