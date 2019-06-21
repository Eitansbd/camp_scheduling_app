require 'pry'

module Defaultable
  def default_lunch(start_time)
    @default_activities[start_time] = lunch_activity
  end
end

class Bunk
  attr_reader :name, :todays_schedule, :division

  def initialize(name, division = "Hey", gender = "Male")
    @name = name
    @division = division
    @gender = gender
    @default_activities = { 12 => Activity.new("Lunch"),
                            10 => Activity.new("Shiur"),
                            18 => Activity.new("Dinner")
    }
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

  def add_activity(activity)
    @todays_schedule << activity
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

  def display_schedule
    printing_schedule_format = @todays_schedule.map do |time, activity|
      time.to_s + " : " + (activity ? activity.name : "")
    end.join(", ")
    puts "#{name}: #{printing_schedule_format}"
  end
end

class Activity
  attr_reader :name

  def initialize(name, appropriate_divisions = "Hey")
    @name = name
    @appropriate_divisions = appropriate_divisions
  end

  def for_division?(division)
    @appropriate_divisions.include?(division)
  end

  def to_s
    @name
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
      @bunks.map { |b| b.activity_at(time_slot) }.include? activity
    end
  end

  def insert_all_default_activities
    @bunks.each do |bunk|
      bunk.schedule_default_activities
    end
  end

  def display_schedule
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

activity_names = ("Lake Toys,Drama,Basketball,Art,Music,Softball,Tennis," +
                  "Taboon,Chavaya Yisraelit,Hockey,Biking,Volleyball" +
                  "a1, a2, a3, a4, a5, a6").split(",")

ACTIVITES = activity_names.map { |name| Activity.new(name) }
BUNKS = (1..10).to_a.map { |num| Bunk.new("B#{num}") }
TIME_SLOTS = (7..17).to_a
todays_schedule = DailySchedule.new("June 16, 2019")
todays_schedule.display_schedule
