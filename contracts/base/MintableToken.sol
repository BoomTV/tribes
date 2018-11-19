pragma solidity ^0.4.24;

import "./StandardToken.sol";


/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 **/
contract MintableToken is StandardToken {
  event Mint(address indexed to, uint256 value);
  event MintFinished();

  bool private _mintingFinished = false;

  modifier canMint() {
    require(!_mintingFinished);
    _;
  }

  modifier hasMintPermission() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param to The address that will receive the minted tokens.
   * @param value The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(
    address to,
    uint256 value
  )
    public
    hasMintPermission
    canMint
    returns (bool)
  {
    _mint(to, value);

    emit Mint(to, value);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() public onlyOwner canMint returns (bool) {
    _mintingFinished = true;
    emit MintFinished();
    return true;
  }

  function mintingFinished() public view returns (bool) {
    return _mintingFinished;
  }
}
