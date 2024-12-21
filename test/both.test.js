const net = require("net");
const { expect } = require("chai");
const sinon = require("sinon");
const { Server } = require("socket.io");
const http = require("http");
const ioClient = require("socket.io-client");

describe("both.js", function () {
  let server, ioServer, netServer, socketClient;

  before(function (done) {
    // Start the net server
    netServer = net.createServer();
    netServer.listen(3005, done);

    // Start the socket.io server
    const app = http.createServer();
    ioServer = new Server(app);
    app.listen(3010, () => {
      console.log("Test Socket.IO server listening on port 3010");
    });
  });

  after(function (done) {
    ioServer.close();
    netServer.close(done);
  });

  beforeEach(function (done) {
    socketClient = ioClient("http://localhost:3010");
    socketClient.on("connect", done);
  });

  afterEach(function (done) {
    if (socketClient.connected) {
      socketClient.disconnect();
    }
    done();
  });

  it("should connect to the net server", function (done) {
    const client = net.createConnection({ port: 3005 }, () => {
      expect(client).to.be.an("object");
      client.end(done);
    });
  });

  it("should receive data from net server and forward to mobile", function (done) {
    const client = net.createConnection({ port: 3005 }, () => {
      const testData = JSON.stringify({ deviceId: "2222", message: "Hello" });
      client.write(testData);
    });

    socketClient.on("goToMobile", (data) => {
      expect(data).to.equal("Hello");
      client.end();
      done();
    });
  });

  it("should receive data from mobile and forward to pico1", function (done) {
    const pico1Socket = net.createConnection({ port: 3005 }, () => {
      const testData = JSON.stringify({ deviceId: "1111" });
      pico1Socket.write(testData);
    });

    pico1Socket.on("data", (data) => {
      expect(data.toString()).to.equal("test message");
      pico1Socket.end();
      done();
    });

    socketClient.emit("gotoserver", "test message");
  });
});
