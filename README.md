# Alarm Clock

## Overview
This project involves designing, implementing, and simulating a **Conventional Alarm Clock** using Verilog. The design includes timekeeping, an alarm system, and seven-segment display integration.

---

## Module Specifications

### ConventionalAlarmClock Module

#### **Ports Table**
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

---d
### ConventionalAlarmClock Module

### **BabylonianClock**
This embedded module serves as the primary clock component that keeps track of time.

| **Port Direction** | **Port Name** | **Active** | **Port Width (bits)** | **Description** |
|--------------------|--------------|------------|----------------------|----------------|
| **INPUT**         | `CLK`         | Rising     | 1                    | Clock input used for the alarm clock |
| **INPUT**         | `CLR`         | High       | 1                    | Resets the alarm clock |
| **INPUT**         | `SETUP`       | High       | 1                    | Allows the user to set the time using `MIN_ADV` and `HR_ADV` |
| **INPUT**         | `MIN_ADV`     | High       | 1                    | Increments the minute signal when `SETUP` signals are active |
| **INPUT**         | `HR_ADV`      | High       | 1                    | Increments the hour signal when `SETUP` signals are active |
| **OUTPUT**        | `SECONDS`     | -          | 6                    | The current seconds the alarm clock has stored |
| **OUTPUT**        | `MINUTES`     | -          | 6                    | The current minutes the alarm clock has stored |
| **OUTPUT**        | `HOURS`       | -          | 5                    | The current hours the alarm clock has stored |

---

### **BabylonianAlarm**
This embedded module manages the alarm functionality for the clock.

| **Port Direction** | **Port Name** | **Active** | **Port Width (bits)** | **Description** |
|--------------------|--------------|------------|----------------------|----------------|
| **INPUT**         | `CLR`         | High       | 1                    | Resets the alarm clock |
| **INPUT**         | `SETUP`       | High       | 1                    | Allows the user to set the time using `MIN_ADV` and `HR_ADV` |
| **INPUT**         | `MIN_ADV`     | High       | 1                    | Increments the minute signal when `SETUP` signals are active |
| **INPUT**         | `HR_ADV`      | High       | 1                    | Increments the hour signal when `SETUP` signals are active |
| **OUTPUT**        | `MINUTES`     | -          | 6                    | The current minutes the alarm clock has stored |
| **OUTPUT**        | `HOURS`       | -          | 5                    | The current hours the alarm clock has stored |

---

### **SevenSegmentDecoder**
This embedded module is responsible for decoding binary time values into seven-segment display signals.

| **Port Direction** | **Port Name** | **Active** | **Port Width (bits)** | **Description** |
|--------------------|--------------|------------|----------------------|----------------|
| **INPUT**         | `DATA_IN`     | -          | 7                    | 7-bit unsigned integer number to get decoded into 2 digits |
| **OUTPUT**        | `DATA_OUT`    | -          | 14                   | Output of the decoder (do not include actual displays in your circuit) |
