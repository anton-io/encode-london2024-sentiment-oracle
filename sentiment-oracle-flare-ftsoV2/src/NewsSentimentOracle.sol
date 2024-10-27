// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Add dependency to read value of BTC at the time of the update.
import {TestFtsoV2Interface} from "@flarenetwork/flare-periphery-contracts/coston2/TestFtsoV2Interface.sol";

contract NewsSentimentOracle {
    // Structure to store sentiment values for each day, as well as sample of BTC Price.
    struct DailySentiment {
        uint16 year;
        uint8 month;
        uint8 day;
        uint32 positiveCount;
        uint32 neutralCount;
        uint32 negativeCount;
        uint64 timeStamp;
        string btcValue;
    }

    // Test contract used for real-world data feed FTSOv2.
    TestFtsoV2Interface internal ftsoV2;
    bytes21 internal Btc2Usd = bytes21(0x014254432f55534400000000000000000000000000);

    // Mapping from date (as a unique identifier) to DailySentiment.
    mapping(bytes32 => DailySentiment) internal sentimentData;

    // Owner of the contract.
    address public owner;

    // Event to log updates
    event SentimentUpdated(uint16 year, uint8 month, uint8 day, uint32 positive, uint32 neutral, uint32 negative);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Modifier to restrict function access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    /**
     * @dev Constructor sets the original owner of the contract
     */
    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);

        ftsoV2 = TestFtsoV2Interface(0x3d893C53D9e8056135C26C8c638B76C8b60Df726); // FtsoV2
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner
     * @param newOwner The address to transfer ownership to
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Generate a unique key for each day based on year, month, and day
     */
    function generateDateKey(uint16 year, uint8 month, uint8 day) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(year, month, day));
    }

    /**
     * @dev Updates sentiment counts for a specific day (only owner can call)
     * @param year Year of the sentiment data
     * @param month Month of the sentiment data
     * @param day Day of the sentiment data
     * @param positive Positive news count
     * @param neutral Neutral news count
     * @param negative Negative news count
     */
    function updateNewsSentiment(
        uint16 year,
        uint8 month,
        uint8 day,
        uint32 positive,
        uint32 neutral,
        uint32 negative
    ) public onlyOwner {
        // Generate a unique key for the date.
        bytes32 dateKey = generateDateKey(year, month, day);

          (uint256 feedValue, int8 decimals, uint64 timestamp) = ftsoV2.getFeedById(Btc2Usd);

        // Update or create new sentiment data.
        sentimentData[dateKey] = DailySentiment(
            year, month, day, positive, neutral, negative, timestamp,
            uintToStringWithDecimals(feedValue, uint8(decimals))
        );

        // Emit event to log the update.
        emit SentimentUpdated(year, month, day, positive, neutral, negative);
    }

    /**
     * @dev Retrieve sentiment data for a specific day
     * @param year Year of the sentiment data
     * @param month Month of the sentiment data
     * @param day Day of the sentiment data
     * @return The DailySentiment struct with positive, neutral, and negative counts
     */
    function getNewsSentiment(uint16 year, uint8 month, uint8 day) public view returns (DailySentiment memory) {
        bytes32 dateKey = generateDateKey(year, month, day);
        return sentimentData[dateKey];
    }

    /**
     * @dev Converts a `uint256` number with specified decimals into a string with fractional representation.
     * E.g., if the number is `123456789` with `8` decimals, the result will be "1.23456789".
     * @param value The `uint256` number to convert.
     * @param decimals Number of decimals in the representation.
     * @return string The number in string format with fractional representation.
     */
    function uintToStringWithDecimals(uint256 value, uint8 decimals) internal pure returns (string memory) {
        // Handle the case when there are no decimals (just convert directly to string)
        if (decimals == 0) {
            return uintToString(value);
        }

        // Split the integer and fractional parts
        uint256 integerPart = value / (10 ** decimals);
        uint256 fractionalPart = value % (10 ** decimals);

        // Convert both integer and fractional parts to strings
        string memory integerPartStr = uintToString(integerPart);
        string memory fractionalPartStr = uintToString(fractionalPart);

        // Pad the fractional part with leading zeros if necessary
        while (bytes(fractionalPartStr).length < decimals) {
            fractionalPartStr = string(abi.encodePacked("0", fractionalPartStr));
        }

        // Combine integer and fractional parts with a dot in between
        return string(abi.encodePacked(integerPartStr, ".", fractionalPartStr));
    }

    /**
     * @dev Converts a `uint256` to a `string`.
     * @param value The `uint256` number to convert.
     * @return string The number in string format.
     */
    function uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
