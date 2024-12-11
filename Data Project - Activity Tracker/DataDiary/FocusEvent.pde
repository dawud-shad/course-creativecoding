class FocusEvent {
  String date, taskType, distraction;
  int focusLevel, focusDuration, hour, minute;

  FocusEvent(TableRow row) {
    this.date = row.getString("Date");
    this.taskType = row.getString("Task Type");
    this.focusLevel = row.getInt("Focus Level");
    this.focusDuration = row.getInt("Focus Duration (minutes)");
    this.distraction = row.getString("Distraction");

    String[] timeParts = row.getString("Time").split(":");
    this.hour = int(timeParts[0]);
    this.minute = int(timeParts[1]);
  }

  int getHour() {
    return hour;
  }
  int getMinute() {
    return minute;
  }

  // Get the color representation for a focus event based on its focus level
  int getColor() {
    if (focusLevel >= 8) {
      return color(50, 200, 50); // Green for high focus
    } else if (focusLevel >= 5) {
      return color(250, 200, 50); // Yellow for medium focus
    } else {
      return color(250, 50, 50); // Red for low focus
    }
  }
}
