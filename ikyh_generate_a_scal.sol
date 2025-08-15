pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/Address.sol";

contract NotifyAPI {
    using SafeERC20 for address;

    // Mapping of APIs to their respective notification channels
    mapping (address => mapping (bytes32 => address[])) public apiNotificationChannels;

    // Mapping of APIs to their notification frequencies
    mapping (address => uint256) public apiNotificationFrequencies;

    // Event emitted when a notification is sent to an API
    event NotificationSent(address indexed api, bytes32 indexed notificationType, address[] recipients);

    // Function to add a notification channel for an API
    function addNotificationChannel(address _api, bytes32 _notificationType, address _channel) public {
        apiNotificationChannels[_api][_notificationType].push(_channel);
    }

    // Function to remove a notification channel for an API
    function removeNotificationChannel(address _api, bytes32 _notificationType, address _channel) public {
        uint256 index = indexOf(apiNotificationChannels[_api][_notificationType], _channel);
        if (index != uint256(-1)) {
            apiNotificationChannels[_api][_notificationType][index] = apiNotificationChannels[_api][_notificationType][apiNotificationChannels[_api][_notificationType].length - 1];
            apiNotificationChannels[_api][_notificationType].pop();
        }
    }

    // Function to set the notification frequency for an API
    function setNotificationFrequency(address _api, uint256 _frequency) public {
        apiNotificationFrequencies[_api] = _frequency;
    }

    // Function to send a notification to an API's notification channels
    function sendNotification(address _api, bytes32 _notificationType, bytes memory _notificationData) public {
        for (uint256 i = 0; i < apiNotificationChannels[_api][_notificationType].length; i++) {
            emit NotificationSent(_api, _notificationType, apiNotificationChannels[_api][_notificationType]);
            // Send the notification data to the channel using an external contract or library
        }
    }

    // Helper function to get the index of an element in an array
    function indexOf(address[] storage _array, address _element) internal view returns (uint256) {
        for (uint256 i = 0; i < _array.length; i++) {
            if (_array[i] == _element) {
                return i;
            }
        }
        return uint256(-1);
    }
}