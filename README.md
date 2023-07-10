# blind_voices

# Blind Stick Project

The Blind Stick project is an innovative communication system that enables real-time interaction between visually 
impaired and sighted individuals. This repository contains the source code, documentation, and resources related to the project.

## Features

- Seamless voice and text communication between blind and sighted users.
- Conversion of voice inputs to Braille for efficient communication.
- Integration of a haptic vibrator for tactile feedback.
- Cutting-edge text-to-speech functionality for effortless messaging.

## Technologies Used

- Android: Development of the mobile app interface.
- Microcontrollers: Utilized to handle data transmission and processing.
- Socket.io Server: Real-time communication between the mobile app and microcontrollers.
- Net Socket Server: Communication channel for data exchange among microcontrollers.
- [List any additional technologies or libraries used in the project.]

## Setup Instructions

Setup Instructions
Clone the repository:


1)git clone https://github.com/your-username/blind-stick-project.git
2)Install dependencies for the Socket.io server:
cd blind-stick-project
npm install

3)Configure server settings:

Open both.js in a text editor and modify any necessary configurations (e.g., port numbers, network settings).
Run the Socket.io server:
node both.js

4)Set up the Microcontrollers:

Connect and flash the Micropython firmware on the microcontrollers.
Copy and paste the contents of pico1.py and pico2.py into the respective microcontrollers.
Adjust any necessary configurations (e.g., network settings) within the Micropython files.
Launch the Android app (guhi.dart) on an emulator or device to establish the connection with the server.

5)###Ensure that the server, microcontrollers, and the app are running on the same network for proper communication.

Please customize the instructions based on your specific project and microcontroller setup.


## Contributing

Contributions to the Blind Stick project are welcome! If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature/bug fix.
3. Make your changes and commit them.
4. Push your changes to your forked repository.
5. Submit a pull request to the main repository.




