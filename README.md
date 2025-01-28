# Alarm Clock

## Overview
This project focuses on designing, implementing, and simulating an ** Alarm Clock** using Digital Logic. The Babylonian Clock displays a 24-hour time format using two seven-segment displays for hours and minutes.

---

## Pins Table

The **ConventionalAlarmClock** module should include the following ports:

| **Port Direction** | **Port Name**      | **Active** | **Port Width (bits)** | **Description** |
|--------------------|-------------------|------------|----------------------|----------------|
| **INPUT**         | `CLK`              | Rising     | 1                    | Clock input used for the alarm clock |
| **INPUT**         | `CLR`              | High       | 1                    | Resets the alarm clock |
| **INPUT**         | `SETUP_TIME`       | High       | 1                    | Allows the user to set the time using `MIN_ADV` and `HR_ADV` |
| **INPUT**         | `SETUP_ALARM`      | High       | 1                    | Allows the user to set the alarm using `MIN_ADV` and `HR_ADV` |
| **INPUT**         | `MIN_ADV`          | High       | 1                    | Increments the minute signal when `SETUP` signals are active |
| **INPUT**         | `HR_ADV`           | High       | 1                    | Increments the hour signal when `SETUP` signals are active |
| **INPUT**         | `ALARM_EN`         | Low        | 1                    | Enables the buzzer when the alarm time is reached |
| **OUTPUT**        | `SECONDS`          | -          | 6                    | The current seconds the alarm clock has stored |
| **OUTPUT**        | `MINUTES`          | -          | 6                    | The current minutes the alarm clock has stored |
| **OUTPUT**        | `HOURS`            | -          | 5                    | The current hours the alarm clock has stored |
| **OUTPUT**        | `ALARM_MINUTES`    | -          | 6                    | The minute that the alarm clock is set to `BUZZ` at |
| **OUTPUT**        | `ALARM_HOURS`      | -          | 5                    | The hour that the alarm clock is set to `BUZZ` at |
| **OUTPUT**        | `BUZZ`             | High       | 1                    | Signal to buzz an external alarm when the alarm time is reached |
| **OUTPUT**        | `SEG_SECONDS`      | -          | 14                   | Seven-segment signal for the seconds the alarm clock has displayed |
| **OUTPUT**        | `SEG_MINUTES`      | -          | 14                   | Seven-segment signal for the minutes the alarm clock has displayed |
| **OUTPUT**        | `SEG_HOURS`        | -          | 14                   | Seven-segment signal for the hours the alarm clock has displayed |

---

## Provided Components
Below is a summary of the components provided in this lab. For detailed information, refer to the [Provided Components Documentation](https://cse140l.github.io/fa24-labs/docs/lab1/part1/provided_components.html).
---

## Task Breakdown

### 1. Clock Implementation
- Instantiate the **BabylonianClock** module for timekeeping.
- Implement **increment logic** for `MIN_ADV` and `HR_ADV`.

### 2. Alarm Functionality
- Compare current time (`HOURS`, `MINUTES`) with `ALARM_HOURS` and `ALARM_MINUTES`.
- Activate `BUZZ` output when the alarm is reached.

### 3. Display Output
- Use **SevenSegmentDecoder** for `SEG_SECONDS`, `SEG_MINUTES`, and `SEG_HOURS`.

---
