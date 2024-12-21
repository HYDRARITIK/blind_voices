import unittest
from unittest.mock import patch, MagicMock
import pico1

class TestPico1(unittest.TestCase):

    @patch('pico1.network.WLAN')
    def test_connect_to_wifi(self, mock_wlan):
        mock_sta_if = MagicMock()
        mock_sta_if.isconnected.return_value = True
        mock_wlan.return_value = mock_sta_if

        pico1.connect_to_wifi("SSID", "PASSWORD")
        mock_sta_if.active.assert_called_once_with(True)
        mock_sta_if.connect.assert_called_once_with("SSID", "PASSWORD")

    @patch('pico1.socket.socket')
    def test_create_socket_connection_success(self, mock_socket):
        mock_s = MagicMock()
        mock_socket.return_value = mock_s
        
        s = pico1.create_socket_connection("127.0.0.1", 8080)
        self.assertEqual(s, mock_s)
        mock_s.connect.assert_called_once_with(("127.0.0.1", 8080))

    @patch('pico1.socket.socket')
    def test_create_socket_connection_failure(self, mock_socket):
        mock_socket.side_effect = Exception("Connection failed")
        
        s = pico1.create_socket_connection("127.0.0.1", 8080)
        self.assertIsNone(s)

    @patch('pico1.socket.socket')
    def test_send_data_to_server_success(self, mock_socket):
        mock_s = MagicMock()
        mock_socket.return_value = mock_s
        mock_s.recv.return_value = b"response"

        response = pico1.send_data_to_server(mock_s, "data")
        self.assertEqual(response, "response")
        mock_s.send.assert_called_once_with(b"data")

    @patch('pico1.socket.socket')
    def test_send_data_to_server_failure(self, mock_socket):
        mock_s = MagicMock()
        mock_socket.return_value = mock_s
        mock_s.send.side_effect = Exception("Send failed")

        response = pico1.send_data_to_server(mock_s, "data")
        self.assertIsNone(response)

if __name__ == '__main__':
    unittest.main()
