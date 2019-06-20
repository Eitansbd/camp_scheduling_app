require 'pry'

module Defaultable
  def default_lunch(start_time)
    @default_activities[start_time] = lunch_activity
  end
end

class Bunk
  attr_reader :name

  def initialize(name, division = "Hey", gender = "Male")
    @name = name
    @division = division
    @gender = gender
    @default_activities = { 12 => Activity.new("Lunch")}
  end

  def default_activity(start_time)
    @default_activities[start_time]
  end

  def default_activity=(start_time, activity)
    #change the default activity for a bunk
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

  def to_s
    @name
  end
end

class TimeSlot
  attr_reader :time

  def initialize(start_time, end_time)
    @time = [start_time, end_time]
    @available_activities = generate_activities_list
  end

  def generate_activities_list
    available_activities = []
    activities = ACTIVITES.shuffle
    activities.each do |activity|
      available_activities << activity if activity.available?(time)
    end

    available_activities
  end

  def assign_activities
    @bunk_activities = {}
    BUNKS.each do |bunk|
      activity = bunk.default_activity(time.first)
      if activity
        @bunk_activities[bunk.name] = activity
      else
        loop do
          activity = @available_activities.pop
          break if bunk.valid_activity?(activity)
          @available_activities << activity
        end

        @bunk_activities[bunk.name] =
      end
    end
  end

  def to_s
    string = "#{time.first} - #{time.last} \n"
    @bunk_activities.each do |bunk_name, activity|
      string += "#{bunk_name} : #{activity} \n"
    end

    string
  end
end

class DailySchedule
  def initialize(date)
    @date = date
    populate_time_slots
  end

  def populate_time_slots
    @slots = [TimeSlot.new(10, 11), TimeSlot.new(11, 12), TimeSlot.new(12, 1)]
    @slots.each do |time_slot|
      time_slot.assign_activities
    end
  end

  def to_s
    @slots.each do |slot|
      puts slot
    end

    ""
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
                  "").split(",")

ACTIVITES = activity_names.map { |name| Activity.new(name) }
BUNKS = (1..24).to_a.map { |num| Bunk.new("B#{num}") }
todays_schedule = DailySchedule.new("June 16, 2019")
puts todays_schedule


