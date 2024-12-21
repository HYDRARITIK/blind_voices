# blind_voices

# Blind Voice Project

The Blind Voice project is an innovative communication system that enables real-time interaction between visually 
impaired and sighted individuals. .

## Features

- Seamless voice and text communication between blind and sighted users.
- Conversion of voice inputs to Braille for efficient communication.
- Integration of a haptic vibrator for tactile feedback.

## Technologies Used

- Android (dart): Development of the mobile app interface.
- Microcontrollers(rPi): Utilized to handle data transmission and processing.
- Socket.io Server: Real-time communication between the mobile app and microcontrollers.
- Net Socket Server: Communication channel for data exchange among microcontrollers.
  

3)Configure server settings:

modify necessary configurations in config files.
Run the Socket.io server:
  node both.js

4)Set up the Microcontrollers:

Connect and flash the Micropython firmware on the microcontrollers.
Copy and paste the contents of pico1.py and pico2.py into the respective microcontrollers.
Adjust any necessary configurations (e.g., network settings) within the config files.

5)Launch the Android app (guhi.dart) on an emulator or device to establish the connection with the server.

6)Ensure that the server, microcontrollers, and the app are running on the same network to avoid ip different problem.

## Testing

All unit test are in test folder, install all the required libraries mention at top of each test file before running each test:


