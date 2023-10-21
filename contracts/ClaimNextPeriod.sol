pragma solidity ^0.8.0;

contract ClaimNextPeriod{
	uint256 public constant ID_TICKET = 0;
    uint256 public num = 1;
	uint256 public startTime; // 1697414400
    uint256 public endTime; // 1704067200
    uint256 public period; // 86400
// lastClaimedTime[msg.sender] = 1697854497
// getCurrentEpoch() = 5，getCurrentEpoch() * period + startTime : 1697846400 < lastClaimedTime[msg.sender]
// getCurrentEpoch() = 6，getCurrentEpoch() * period + startTime : 1697932800 > lastClaimedTime[msg.sender]

    mapping(address => uint256) public lastClaimedTime;

    modifier checkTime() {
        require(block.timestamp >= startTime, "not started yet");
        require(block.timestamp <= endTime, "already end");
        _;
    }

    modifier checkClaim() {
        require(!isClaimed(msg.sender), "claimed!");
        _;
        lastClaimedTime[msg.sender] = block.timestamp;
    }

    constructor(uint256 _period, uint256 _startTime, uint256 _endTime, string memory _uri) ERC1155("") {
        _setURI(ID_TICKET, _uri); // ERC1155 _setURI function
        startTime = _startTime;
        period = _period;
        endTime = _endTime;
    }

    function getCurrentEpoch() public view returns (uint256 currentEpoch) {
        currentEpoch = (Math.max(startTime, block.timestamp) - (startTime)) / (period);
    }
    // If the start time was 0 am on Oct1, I claimed at 11:59 pm on Oct1, I was available to claim the next token at 0 am on Oct2!
    function isClaimed(address _to) public view returns (bool) {
        uint256 currentEpoch = getCurrentEpoch();
        uint256 lastStartTime = currentEpoch * period + startTime;
        return lastClaimedTime[_to] >= lastStartTime;
    }

    function mint() external checkTime checkClaim {
        _mint(msg.sender, ID_TICKET, num, ""); // ERC1155 _mint function
        emit Mint(msg.sender, ID_TICKET, 1);
    }
}
