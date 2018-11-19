pragma solidity ^0.4.24;

import '../base/DetailedToken.sol';
import '../base/PausableToken.sol';
import '../delegate/CanDelegateToken.sol';
import '../delegate/DelegateToken.sol';
import '../CompliantToken.sol';
import '../TokenWithFees.sol';


/**
 * @title TRIBESTokenMock token.
 * @dev TRIBESTokenMock is a ERC20 token that:
 *  - caps total number at 4 million tokens.
 *  - mints new tokens when purchased.
 *  - can pause and unpause token transfer (and authorization) actions.
 *  - token holders can be distributed profit from the system manager.
 *  - can change token name and symbol as needed.
 *  - can delegate to a new contract.
 *  - transferring tokens with fees are sent to the system wallet.
 *  - attempts to check KYC/AML and Blacklist using Registry.
 *  - attempts to reject ERC20 token transfers to itself and allows token transfer out.
 *  - attempts to reject ether sent and allows any ether held to be transferred out.
 *  - allows the new owner to accept the ownership transfer, the owner can cancel the transfer if needed.
 **/
contract TRIBESTokenMock is DetailedToken, CanDelegateToken, DelegateToken, TokenWithFees, CompliantToken, PausableToken {
  uint8 public constant decimals = 18;
  uint256 public constant TOTAL_TOKENS = 4 * (10**6) * (10 ** uint256(decimals));

  /**
   * @param name Name of this token.
   * @param symbol Symbol of this token.
   */
  constructor(
    string name,
    string symbol,
    address wallet,
    uint256 prevTotalSupply
  )
    public
    DetailedToken(name, symbol)
    TokenWithFees(wallet)
  {
    _setTotalSupply(prevTotalSupply);
  }

  function mint(
    address to,
    uint256 amount
  )
    public
    onlyOwner
    canMint
    returns (bool)
  {
    require(totalSupply().add(amount) <= TOTAL_TOKENS);
    return super.mint(to, amount);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a new owner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    // do not allow self ownership
    require(newOwner != address(this));
    super.transferOwnership(newOwner);
  }
}
