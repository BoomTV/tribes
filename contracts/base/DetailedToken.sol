pragma solidity ^0.4.24;

import "../openzeppelin/contracts/ownership/Ownable.sol";
import "../openzeppelin/contracts/token/ERC20/ERC20.sol";


/**
 * @title Detailed token
 */
contract DetailedToken is Ownable, ERC20 {
  string private _name;
  string private _symbol;

  event ChangeName(string newName, string newSymbol);

  constructor(string name, string symbol) public {
    _name = name;
    _symbol = symbol;
  }

  function changeName(string name, string symbol) public onlyOwner {
    _name = name;
    _symbol = symbol;
    emit ChangeName(_name, _symbol);
  }

  /**
   * @return the name of the token.
   */
  function name() public view returns(string) {
    return _name;
  }

  /**
   * @return the symbol of the token.
   */
  function symbol() public view returns(string) {
    return _symbol;
  }
}
