pragma solidity ^0.4.24;

import "../base/StandardToken.sol";
import "./DelegateInterface.sol";


// Treats all delegate functions exactly like the corresponding normal functions,
// e.g. delegateTransfer is just like transfer. See DelegateInterface.sol for more on
// the delegation system.
contract DelegateToken is DelegateInterface, StandardToken {
  address private _delegatedFrom;

  event DelegatedFromSet(address addr);

  // Only calls from appointed address will be processed
  modifier onlyMandator() {
    require(msg.sender == _delegatedFrom);
    _;
  }

  function setDelegatedFrom(address addr) public onlyOwner {
    _delegatedFrom = addr;
    emit DelegatedFromSet(addr);
  }

  function delegatedFrom() public view returns (address) {
    return _delegatedFrom;
  }

  // each function delegateX is simply forwarded to function X
  function delegateTotalSupply(
  )
    public
    onlyMandator
    view
    returns (uint256)
  {
    return totalSupply();
  }

  function delegateBalanceOf(
    address who
  )
    public
    onlyMandator
    view
    returns (uint256)
  {
    return balanceOf(who);
  }

  function delegateTransfer(
    address to,
    uint256 value,
    address origSender
  )
    public
    onlyMandator
    returns (bool)
  {
    _transfer(origSender, to, value);
    return true;
  }

  function delegateAllowance(
    address owner,
    address spender
  )
    public
    onlyMandator
    view
    returns (uint256)
  {
    return allowance(owner, spender);
  }

  function delegateTransferFrom(
    address from,
    address to,
    uint256 value,
    address origSender
  )
    public
    onlyMandator
    returns (bool)
  {
    _transferFrom(from, to, value, origSender);
    return true;
  }

  function delegateApprove(
    address spender,
    uint256 value,
    address origSender
  )
    public
    onlyMandator
    returns (bool)
  {
    _approve(spender, value, origSender);
    return true;
  }

  function delegateIncreaseApproval(
    address spender,
    uint256 addedValue,
    address origSender
  )
    public
    onlyMandator
    returns (bool)
  {
    _increaseApproval(spender, addedValue, origSender);
    return true;
  }

  function delegateDecreaseApproval(
    address spender,
    uint256 subtractedValue,
    address origSender
  )
    public
    onlyMandator
    returns (bool)
  {
    _decreaseApproval(spender, subtractedValue, origSender);
    return true;
  }

  function delegateGetTheNumberOfHolders() public view returns (uint256) {
    return getTheNumberOfHolders();
  }

  function delegateGetHolder(uint256 index) public view returns (address) {
    return getHolder(index);
  }
}
