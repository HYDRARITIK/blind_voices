const net = require("net");
const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const cors = require("cors");
const fs = require("fs");
const config = require("./config"); // Import configuration

const app = express();
const server = net.createServer();
const io_server = http.createServer(app);
const io = new Server(io_server, {
  cors: {
    // origin: "http://localhost:3000",
    // methods: ["GET", "POST"],
  },
});

app.use(cors());

let pico1Socket = null;  // Haptic device socket
let androidSocket = null;  // Android device socket

// Handle new TCP connections
server.on("connection", (socket) => {
  socket.on("data", (data) => {
    const dataString = data.toString();
    const dataObj = JSON.parse(dataString);

    console.log("Device ID:", dataObj.deviceId);
    console.log("Message:", dataObj.message || "No message");

    logDataToFile(dataObj);

    switch (dataObj.deviceId) {
      case config.devices.hapticDeviceId:
        console.log("Connected to haptic device");
        pico1Socket = socket;
        break;
      case config.devices.keyboardDeviceId:
        console.log("Connected to keyboard");
        sendDataToMobile(dataObj.message);
        break;
      default:
        console.log("Unknown device ID");
    }
  });

  socket.on("end", () => {
    console.log("Client disconnected");
  });
});

// Handle server errors
server.on("error", (err) => {
  console.error("Server error:", err);
});

// Function to send data to mobile client
function sendDataToMobile(data) {
  if (androidSocket) {
    console.log("Sending data to mobile client");
    androidSocket.emit("goToMobile", data);
  } else {
    console.log("Android socket is null");
  }
}

// Handle new WebSocket connections
io.on("connection", (socket) => {
  androidSocket = socket;
  console.log(`Mobile user connected: ${socket.id}`);

  socket.on("gotoserver", (data) => {
    console.log("Data received from mobile:", data);
    sendDataToPico1(data);
  });

  socket.on("disconnect", () => {
    console.log("Mobile user disconnected");
  });

  socket.on("error", (err) => {
    console.error("Socket error:", err);
  });
});

// Function to send data to pico1 device
function sendDataToPico1(data) {
  if (pico1Socket) {
    pico1Socket.write(data);
  } else {
    console.log("Pico1 socket is null");
  }
}

// Function to log data to a file
function logDataToFile(data) {
  const logEntry = `${new Date().toISOString()} - Device ID: ${data.deviceId}, Message: ${data.message}\n`;
  fs.appendFile("data_log.txt", logEntry, (err) => {
    if (err) {
      console.error("Failed to write to log file:", err);
    }
  });
}

// Start the socket.io server
io_server.listen(config.ports.socketIoPort, () => {
  console.log(`Socket.IO server listening on port ${config.ports.socketIoPort}`);
});

// Start the net socket server
server.listen(config.ports.netSocketPort, () => {
  console.log(`Net socket server listening on port ${config.ports.netSocketPort}`);
});
