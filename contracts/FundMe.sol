// SPDX-License-Identifier: MIT

// solidity version less than 0.8, use safemath

pragma solidity ^0.6.6;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    mapping(address => uint256) public addressToAmountFunded;
    address public owner;
    AggregatorV3Interface public price;

    constructor(address _priceFeed) public {
        price = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }

    function fund() public payable {
        uint256 minimumUSD = 50 * 10**18;
        require(
            getConversionPrice(msg.value) >= minimumUSD,
            "You need to send more ethereum"
        );

        addressToAmountFunded[msg.sender] += msg.value;
    }

    function getVersion() public view returns (uint256) {
        return price.version();
    }

    function getPrice() public view returns (uint256) {
        // because the function is returning the 5 value, we can also return 5 value

        // ignoring tuple value

        (, int256 answer, , , ) = price.latestRoundData();

        return uint256(answer * 10000000000);
    }

    function getDecimal() public view returns (uint8) {
        AggregatorV3Interface price = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        return price.decimals();
    }

    function getConversionPrice(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function withdraw() public payable onlyOwner {
        require(msg.sender == owner);
        msg.sender.transfer(address(this).balance);
    }

    function getEnteranceFee() public view returns (uint256) {
        // minimum USD
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUSD * precision) / price;
    }
}
