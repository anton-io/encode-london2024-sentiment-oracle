// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NewsSentimentOracle {
    // Structure to store sentiment values for each day.
    struct DailySentiment {
        uint16 year;
        uint8 month;
        uint8 day;
        uint32 positiveCount;
        uint32 neutralCount;
        uint32 negativeCount;
    }

    // Mapping from date (as a unique identifier) to DailySentiment.
    mapping(bytes32 => DailySentiment) public sentimentData;

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
    function updateSentiment(
        uint16 year,
        uint8 month,
        uint8 day,
        uint32 positive,
        uint32 neutral,
        uint32 negative
    ) public onlyOwner {
        // Generate a unique key for the date.
        bytes32 dateKey = generateDateKey(year, month, day);

        // Update or create new sentiment data.
        sentimentData[dateKey] = DailySentiment(year, month, day, positive, neutral, negative);

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
    function getSentiment(uint16 year, uint8 month, uint8 day) public view returns (DailySentiment memory) {
        bytes32 dateKey = generateDateKey(year, month, day);
        return sentimentData[dateKey];
    }
}
