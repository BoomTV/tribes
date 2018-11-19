pragma solidity ^0.4.24;

import "../base/StandardToken.sol";
import "./DelegateInterface.sol";


// See DelegateInterface.sol for more on the delegation system.
contract CanDelegateToken is StandardToken {
  // If this contract needs to be upgraded, the new contract will be stored
  // in '_delegate' and any StandardToken calls to this contract will be delegated to that one.
  DelegateInterface private _delegate;

  event DelegateToNewContract(address indexed newContract);

  // Can undelegate by passing in _newContract = address(0)
  function delegateToNewContract(
    DelegateInterface newContract
  )
    public
    onlyOwner
  {
    _delegate = newContract;
    emit DelegateToNewContract(_delegate);
  }

  function delegate() public view returns (DelegateInterface) {
    return _delegate;
  }

  // If a delegate has been designated, all ERC20 calls are forwarded to it
  function _transfer(address from, address to, uint256 value) internal {
    if (!_hasDelegate()) {
      super._transfer(from, to, value);
    } else {
      require(_delegate.delegateTransfer(to, value, from));
    }
  }

  function _transferFrom(
    address from,
    address to,
    uint256 value,
    address spender
  )
    internal
  {
    if (!_hasDelegate()) {
      super._transferFrom(from, to, value, spender);
    } else {
      require(_delegate.delegateTransferFrom(from, to, value, spender));
    }
  }

  function totalSupply() public view returns (uint256) {
    if (!_hasDelegate()) {
      return super.totalSupply();
    } else {
      return _delegate.delegateTotalSupply();
    }
  }

  function balanceOf(address who) public view returns (uint256) {
    if (!_hasDelegate()) {
      return super.balanceOf(who);
    } else {
      return _delegate.delegateBalanceOf(who);
    }
  }

  function getTheNumberOfHolders() public view returns (uint256) {
    if (!_hasDelegate()) {
      return super.getTheNumberOfHolders();
    } else {
      return _delegate.delegateGetTheNumberOfHolders();
    }
  }

  function getHolder(uint256 index) public view returns (address) {
    if (!_hasDelegate()) {
      return super.getHolder(index);
    } else {
      return _delegate.delegateGetHolder(index);
    }
  }

  function _approve(
    address spender,
    uint256 value,
    address tokenHolder
  )
    internal
  {
    if (!_hasDelegate()) {
      super._approve(spender, value, tokenHolder);
    } else {
      require(_delegate.delegateApprove(spender, value, tokenHolder));
    }
  }

  function allowance(
    address owner,
    address spender
  )
    public
    view
    returns (uint256)
  {
    if (!_hasDelegate()) {
      return super.allowance(owner, spender);
    } else {
      return _delegate.delegateAllowance(owner, spender);
    }
  }

  function _increaseApproval(
    address spender,
    uint256 addedValue,
    address tokenHolder
  )
    internal
  {
    if (!_hasDelegate()) {
      super._increaseApproval(spender, addedValue, tokenHolder);
    } else {
      require(
        _delegate.delegateIncreaseApproval(spender, addedValue, tokenHolder)
      );
    }
  }

  function _decreaseApproval(
    address spender,
    uint256 subtractedValue,
    address tokenHolder
  )
    internal
  {
    if (!_hasDelegate()) {
      super._decreaseApproval(spender, subtractedValue, tokenHolder);
    } else {
      require(
        _delegate.delegateDecreaseApproval(
          spender,
          subtractedValue,
          tokenHolder)
      );
    }
  }

  function _hasDelegate() internal view returns (bool) {
    return !(_delegate == address(0));
  }
}
