pragma solidity ^0.4.24;

import "../openzeppelin/contracts/lifecycle/Pausable.sol";

import "./StandardToken.sol";


/**
 * @title Pausable token
 * @dev StandardToken modified with pausable transfers.
 **/
contract PausableToken is StandardToken, Pausable {

  function _transfer(
    address from,
    address to,
    uint256 value
  )
    internal
    whenNotPaused
  {
    super._transfer(from, to, value);
  }

  function _transferFrom(
    address from,
    address to,
    uint256 value,
    address spender
  )
    internal
    whenNotPaused
  {
    super._transferFrom(from, to, value, spender);
  }

  function _approve(
    address spender,
    uint256 value,
    address tokenHolder
  )
    internal
    whenNotPaused
  {
    super._approve(spender, value, tokenHolder);
  }

  function _increaseApproval(
    address spender,
    uint256 addedValue,
    address tokenHolder
  )
    internal
    whenNotPaused
  {
    super._increaseApproval(spender, addedValue, tokenHolder);
  }

  function _decreaseApproval(
    address spender,
    uint256 subtractedValue,
    address tokenHolder
  )
    internal
    whenNotPaused
  {
    super._decreaseApproval(spender, subtractedValue, tokenHolder);
  }
}
