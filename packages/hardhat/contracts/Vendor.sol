pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

  uint256 public constant tokensPerEth = 100;

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 amountOfTokens = msg.value * tokensPerEth;
    require(amountOfTokens > 0, "Need to buy more than zero tokens");
    yourToken.transfer(msg.sender, amountOfTokens);
    
    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
  }
    
  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    (bool sent, ) = msg.sender.call{value: address(this).balance}("");
    require(sent, "Failed to send Ether");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 amount) public {
    require(amount > 0, "need to sell more than zero tokens");
    uint256 allowance = yourToken.allowance(msg.sender, address(this));
    require(allowance >= amount, "Check the token allowance");
    bool sent = yourToken.transferFrom(msg.sender, address(this), amount);
    require(sent, "Failed to send Ether");
    uint256 amountOfEthToReturn = (amount / tokensPerEth);
    (bool success, ) = msg.sender.call{value: amountOfEthToReturn}("");
    require(success, "Failed to send Ether");
    emit SellTokens(msg.sender, amountOfEthToReturn, amount);
  }
}
