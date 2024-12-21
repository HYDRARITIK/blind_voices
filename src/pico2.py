import network
import usocket as socket
import time
import json
import config  # Import configuration

def connect_to_wifi(ssid, password):
    """Connect to WiFi using provided SSID and password."""
    sta_if = network.WLAN(network.STA_IF)
    sta_if.active(True)
    sta_if.connect(ssid, password)
    while not sta_if.isconnected():
        pass
    print("Connected to WiFi")

def create_socket_connection(host, port):
    """Create and return a socket connection to the server."""
    try:
        s = socket.socket()
        s.connect((host, port))
        return s
    except Exception as e:
        print(f"Failed to connect to server: {e}")
        return None

def send_data_to_server(socket, data):
    """Send data to the server and receive the response."""
    try:
        socket.send(data.encode())
        print("Data sent to mobile:", data)
        time.sleep(5)
    except Exception as e:
        print(f"Failed to send data: {e}")
    finally:
        socket.close()

def main():
    connect_to_wifi(config.SSID, config.PASSWORD)
    msg = json.dumps({"message": config.MESSAGE, "deviceId": config.DEVICE_ID})

    while True:
        s = create_socket_connection(config.SERVER_HOST, config.SERVER_PORT)
        if s:
            send_data_to_server(s, msg)
        time.sleep(0.2)

if __name__ == "__main__":
    main()