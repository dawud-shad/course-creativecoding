import java.util.HashMap;

Table table;
ArrayList<FocusEvent> events = new ArrayList<>();
HashMap<String, ArrayList<FocusEvent>> eventsByDate = new HashMap<>();

PFont font;

// Current view state
String viewMode = "month"; // "month", "week", "day"
String selectedDay = "";
boolean inTimelineView = false;

// Calendar start date
int currentMonth = 10, currentYear = 2024;

// Days of the week
String[] daysOfWeek = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};

boolean mousePressedHandled = false; // Flag to prevent multiple triggers during a single click


void setup() {
  size(1280, 800);
  font = createFont("Arial", 14, true);
  textFont(font);
  loadData();
  groupEventsByDate();
  //surface.setResizable(true);
}

void draw() {
  background(240);

  if (inTimelineView) {
    displayTimeline();
  } else if (viewMode.equals("month")) {
    displayMonthView();
  } else if (viewMode.equals("day")) {
    displayDayView();
  }
}

// Load CSV data
void loadData() {
  table = loadTable("focus_data.csv", "header");
  for (TableRow row : table.rows()) {
    FocusEvent event = new FocusEvent(row);
    events.add(event);
  }
}

// Group events by date
void groupEventsByDate() {
  for (FocusEvent event : events) {
    eventsByDate.putIfAbsent(event.date, new ArrayList<>());
    eventsByDate.get(event.date).add(event);
  }
}

void displayMonthView() {
  textAlign(CENTER, CENTER);
  textSize(18);
  fill(0);
  text("Month View: " + getMonthName(currentMonth) + " " + currentYear, width / 2, 30);

  float cellWidth = width / 7;
  float cellHeight = (height - 150) / 6;

  // Draw headers
  for (int i = 0; i < daysOfWeek.length; i++) {
    fill(0);
    textSize(14);
    text(daysOfWeek[i], i * cellWidth + cellWidth / 2, 70);
  }

  int startDay = getDayOfWeek(currentYear, currentMonth, 1); // 0 = Monday, ..., 6 = Sunday

  int dayCounter = 1;
  boolean hasMoreDays = true;

  for (int row = 0; row < 6; row++) {
    for (int col = 0; col < 7; col++) {
      float x = col * cellWidth;
      float y = row * cellHeight + 100;

      // Draw cell background and outline
      fill(255);
      rect(x, y, cellWidth, cellHeight);
      stroke(200);
      noFill();
      rect(x, y, cellWidth, cellHeight);

      if (row == 0 && col < startDay || !hasMoreDays) continue;

      String currentDate = String.format("%04d-%02d-%02d", currentYear, currentMonth, dayCounter);

      // Display day number
      fill(0);
      textAlign(LEFT, TOP);
      text(dayCounter, x + 5, y + 5);

      // Display events as rounded rectangles
      if (eventsByDate.containsKey(currentDate)) {
        ArrayList<FocusEvent> dayEvents = eventsByDate.get(currentDate);
        int maxVisibleEvents = 3;
        float rectSpacing = 20;
        float rectHeight = 15;
        float topOffset = 25;

        for (int j = 0; j < min(maxVisibleEvents, dayEvents.size()); j++) {
          float rectX = x + 5;
          float rectY = y + topOffset + j * rectSpacing;
          float rectWidth = cellWidth - 10;

          fill(dayEvents.get(j).getColor());
          noStroke();
          rect(rectX, rectY, rectWidth, rectHeight, 5);
          fill(0);
          textSize(10);
          text(dayEvents.get(j).taskType, rectX + 5, rectY + 2);
        }

        if (dayEvents.size() > maxVisibleEvents) {
          fill(150);
          textSize(12);
          text("+" + (dayEvents.size() - maxVisibleEvents) + " more", x + 5, y + topOffset + maxVisibleEvents * rectSpacing);
        }
      } else {
        textSize(12);
        fill(150);
        text("No data", x + 5, y + 30);
      }

      if (mousePressed && !mousePressedHandled &&
          mouseX > x && mouseX < x + cellWidth &&
          mouseY > y && mouseY < y + cellHeight) {
        selectedDay = currentDate;
        viewMode = "day";
        mousePressedHandled = true;
      }

      dayCounter++;
      if (dayCounter > daysInMonth(currentYear, currentMonth)) {
        hasMoreDays = false;
        break;
      }
    }
  }

  drawMonthNavigationButtons();
}

// Utility to display a tooltip
void displayTooltip(FocusEvent event, float x, float y) {
  fill(50, 50, 255, 200);
  rect(x - 70, y - 50, 140, 60, 10);
  fill(255);
  textSize(10);
  text("Task: " + event.taskType, x, y - 35);
  text("Duration: " + event.focusDuration + " mins", x, y - 20);
  text("Distraction: " + event.distraction, x, y - 5);
}

// Display day view
void displayDayView() {
  fill(0);
  textSize(18);
  text("Day View: " + selectedDay, width / 2, 30);
  displayTimeline();
  drawBackButton();
}

// Display daily timeline
void displayTimeline() {
  fill(0);
  textSize(16);
  textAlign(CENTER, TOP);
  text("Timeline for " + selectedDay, width / 2, 10);

  ArrayList<FocusEvent> dayEvents = eventsByDate.getOrDefault(selectedDay, new ArrayList<>());
  float startX = 100, endX = width - 100, centerY = height / 2;

  stroke(0);
  strokeWeight(2);
  line(startX, centerY, endX, centerY);

  textSize(12);
  for (int hour = 0; hour <= 24; hour++) {
    float x = map(hour, 0, 24, startX, endX);
    line(x, centerY - 5, x, centerY + 5);
    fill(0);
    text(hour + ":00", x, centerY + 10);
  }

  for (FocusEvent event : dayEvents) {
    float timeX = map(event.getHour() + event.getMinute() / 60.0, 0, 24, startX, endX);

    float circleX = timeX + 50;
    float circleY = centerY + 50;

    stroke(0);
    line(timeX, centerY, circleX, circleY);

    fill(event.getColor());
    ellipse(circleX, circleY, 40, 40);
    noStroke();

    if (dist(mouseX, mouseY, circleX, circleY) < 20) {
      displayTooltip(event, circleX, circleY - 50);
    }
  }
}

void drawBackButton() {
  fill(255, 100, 100);
  rect(10, 10, 80, 30, 5);
  fill(255);
  textSize(12);
  textAlign(CENTER, CENTER);
  text("Back", 50, 25);

  if (mousePressed && mouseX > 10 && mouseX < 90 && mouseY > 10 && mouseY < 40) {
    viewMode = "month";
    inTimelineView = false;
    selectedDay = "";
  }
}


void drawMonthNavigationButtons() {
  String[] labels = {"Previous", "Next"};
  textSize(14);
  for (int i = 0; i < 2; i++) {
    float x = 150 + i * 100;
    float y = 10;
    fill(200);
    rect(x, y, 80, 30, 5);
    fill(0);
    textAlign(CENTER, CENTER);
    text(labels[i], x + 40, y + 15);

    // Only navigate if the button is clicked and the action hasn't been handled yet
    if (mousePressed && !mousePressedHandled &&
        mouseX > x && mouseX < x + 80 && mouseY > y && mouseY < y + 30) {
      if (labels[i].equals("Previous")) navigateMonth(-1);
      else navigateMonth(1);
      mousePressedHandled = true; // Mark action as handled
    }
  }
}

void mouseReleased() {
  mousePressedHandled = false;
}

void navigateMonth(int direction) {
  currentMonth += direction;
  if (currentMonth > 12) {
    currentMonth = 1;
    currentYear++;
  } else if (currentMonth < 1) {
    currentMonth = 12;
    currentYear--;
  }
}

// Get the name of the month from its number
String getMonthName(int month) {
  String[] monthNames = {
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  };
  return monthNames[month - 1];
}

// Get the number of days in a given month, acco0unting for leap years
int daysInMonth(int year, int month) {
  if (month == 2) {
    return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28;
  }
  return (month == 4 || month == 6 || month == 9 || month == 11) ? 30 : 31;
}

int getDayOfWeek(int y, int m, int day) {
  if (m < 3) {
    m += 12;
    y -= 1;
  }
  int k = y % 100;
  int j = y / 100;
  int dayOfWeek = (day + (13 * (m + 1)) / 5 + k + (k / 4) + (j / 4) - 2 * j) % 7;
  if (dayOfWeek < 0) {
    dayOfWeek += 7; // Ensure positive index
  }
  return (dayOfWeek + 6) % 7 - 1; // Shift Sunday = 0 to Monday = 1
}
