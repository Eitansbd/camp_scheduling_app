The Camp Scheduling Management System is a smart scheduler for summer camps. Visit the [projects page](https://eitan-bar-david.herokuapp.com/projects) on my website for a short video demo of how the system works or check out the system live by clicking [here](https://camp-schedule-management.herokuapp.com/)

##### SETUP
To set up the system the user enter first enters in data for the camp calendar dates, schedule time slots, activities, and bunks. Then the user creates a "defualt schedule" that will serve as the base for scheduling activities for each camp day. In most camps there's some sort of standard schedule that is always followed - certain age groups will always have meals at the same time, swim at the same time, etc - so creating a default schedule allows for this template to be followed everyyday.

##### Calendar
From the calendar page, the user has a view of all the days in the summer session and can see which dates have already been scheduled and which still need to be scheduled. Clicking on a day that is scheduled will bring the user to the schedule for thay day, with option to edit or reset the schedule. Clicking on a day that is not schedule will bring the user to a page for creating that days schedule with the default schedule loaded.

#### Daily Schedule
There are two important features to this page. The first is on the left hand side is a box with all the activities in the system. Activities that are default schedule by the system are checked and activites that are default not schedule by the system are unchecked. However, on a given day, it's possible that schedules that are usually scheduled by the system should not be scheduled, such as if the employee that runs the activity is on a day off. Unchecking the box for that schedule will prevent the system from scheduling that activity for the current day only.

The second important feature is for the ability for the user to manually schedule certain activities. If a certain bunk need to have a specific activity, the user can manually schedule that activity before the system schedules the rest of the activities.

When the user is ready, they click "autocomplete schedule" and they are brought to a page with the remaining activities filled in. At this point again, if the user doesn't like some of the activities scheduled, they are able to make manual changes before the schedule is saved to the database.