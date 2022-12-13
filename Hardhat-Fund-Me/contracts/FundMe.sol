// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "./PriceConverter.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5 * 1e18; // rounding to 18 decimal places
    address[] private s_funders; // array of addresses of funders;
    mapping(address => uint256) private s_addressToAmountFunded;
    address private immutable i_owner;

    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        // Set Minimum fund amount in USD
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Didn't send enough ETH!!"
        ); // 1e18 = 1*10**18 == 1000000000000000000 == 1 ETH
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
          
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0); // new array filled with 0s
        //3 ways to withdraw funds

        // transfer
        /*
        payable(msg.sender.transfer(address(this).balance));
        */

        //send
        /*
        bool sendSuccess = payable(msg.sender.send(address(this).balance)); // send
        require(sendSuccess, "Withdraw failed!!");
        */
        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not the owner!!");
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function getOwner() public view returns (address){
        return i_owner;
    }
    function getFunder(uint256 index ) public view returns (address){
        return s_funders[index];
    }
    function getAddressToAmountFunded(address funder) public view returns (uint256){
        return s_addressToAmountFunded[funder];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface){
        return s_priceFeed;
    }
}

//Pending : 5:55:44
