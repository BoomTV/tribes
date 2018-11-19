pragma solidity ^0.4.24;

import "./Registry.sol";


// Superclass for contracts that have a registry that can be set by their owners
contract HasRegistry is Ownable {
  Registry private _registry;

  event SetRegistry(address indexed registry);

  function setRegistry(Registry registry) public onlyOwner {
    _registry = registry;
    emit SetRegistry(_registry);
  }

  function registry() public view returns (Registry) {
    return _registry;
  }
}
