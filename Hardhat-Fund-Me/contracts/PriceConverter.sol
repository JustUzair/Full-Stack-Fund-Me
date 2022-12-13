// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) public view returns (uint256) {
        // ABI
        //Address - 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10); // price is returned with total 18 decimal places
    }
    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed)
        internal
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // multiplying 1e18 and 1e18 will give number with 36 decimal places, thus we divide it by 1e18
        return ethAmountInUsd;
    }
}
