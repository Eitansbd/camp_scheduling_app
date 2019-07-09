require 'pry'
require_relative 'schedule_database'

# Class that stores the bunk object keeping track of bunk info and acitivities.
class Bunk
  attr_reader :name, :division, :gender, :id

  def initialize(name, division, gender, id = nil)
    @id = id  # Why is this a attribute?
    @name = name
    @division = division
    @gender = gender
    @activity_history = Hash.new([])
  end
end

class Activity
  attr_reader :name, :location, :max_bunks, :id

  def initialize(name, location = "", id=nil)
    @id = id
    @name = name
    @location = location
  end

  def set_activity_parameters(max_bunks, youngest_division = "Hey", oldest_division = "Daled")
    @max_bunks = max_bunks
    @appropriate_divisions = divisions_between(youngest_division, oldest_division)
    self
  end

  def for_division?(division)
    @appropriate_divisions.include?(division)
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

# Daoly Schedule object are used to create and store the daily camp schedule
class DailySchedule
  attr_reader :bunks, :time_slots, :schedule

  def initialize(day_id, time_slots, activities, bunks, new_schedule=false) # should rename to date_id
    @day_id = day_id
    @time_slots = time_slots #.map{ |slot| slot.last }
    @activities = activities
    @bunks = bunks
    @schedule = Hash.new { |hash, key| hash[key] = {} }
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
    !!@schedule[time_slot_id][bunk]
  end

  def select_activity(bunk, time_slot_id)
    activities = @activities.dup
    remove_activities_bunk_constraints!(activities, bunk)
    remove_activities_time_slot_constraints!(activities, time_slot_id)

    activities.sample
  end

  def remove_activities_bunk_constraints!(activities, bunk)
    activities.reject! do |activity|
      @schedule.any? do |_, slot_schedule|
        slot_schedule[bunk] == activity
      end
    end

    activities.select! do |activity|
      activity.for_division?(bunk.division)
    end
  end


  # def schedule_dependent_activities(activity, bunk, time_slot)
  #   return false if activity.reached_maximum_capacity?


  # end

  def remove_activities_time_slot_constraints!(activities, time_slot_id)
    activities.reject! do |activity|
      @schedule[time_slot_id].values.any? do |schedule_activity|
        schedule_activity.equal?(activity)
      end
    end
  end
end



# created object to store the monthly calendars
class Calendar
  def initialize
    @schedules = []
  end

  def create_schedule(date)
    @todays_schedule = DailySchedule.new(date)
  end
end

#schedule = ScheduleDatabase.new('').get_default_schedule

#test_activity = Activity.new("Hockey").set_activity_parameters(2, 'Hey', 'Aleph')