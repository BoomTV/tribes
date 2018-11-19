pragma solidity ^0.4.24;

import "../openzeppelin/contracts/ownership/Ownable.sol";


/**
 * @title Address Set.
 * @dev This contract allows to store addresses in a set and
 * owner can run a loop through all elements.
 **/
contract AddressSet is Ownable {
  mapping(address => bool) private _exist;
  address[] private _elements;

  /**
   * @dev Adds a new address to the set.
   * @param addr Address to add.
   * @return True if succeed, otherwise false.
   */
  function add(address addr) onlyOwner public returns (bool) {
    if (contains(addr)) {
      return false;
    }

    _exist[addr] = true;
    _elements.push(addr);
    return true;
  }

  /**
   * @dev Checks whether the set contains a specified address or not.
   * @param addr Address to check.
   * @return True if the address exists in the set, otherwise false.
   */
  function contains(address addr) public view returns (bool) {
    return _exist[addr];
  }

  /**
   * @dev Gets an element at a specified index in the set.
   * @param index Index.
   * @return A relevant address.
   */
  function elementAt(uint256 index) onlyOwner public view returns (address) {
    require(index < _elements.length);

    return _elements[index];
  }

  /**
   * @dev Gets the number of elements in the set.
   * @return The number of elements.
   */
  function getTheNumberOfElements() onlyOwner public view returns (uint256) {
    return _elements.length;
  }
}
