pragma solidity ^0.4.24;

import "./Registry.sol";
import "./Attribute.sol";


// Interface for logic governing write access to a Registry.
contract RegistryAccessManager {
  // Called when admin attempts to write _value for who's _attribute.
  // Returns true if the write is allowed to proceed.
  function confirmWrite(
    address who,
    Attribute.AttributeType attribute,
    address admin
  )
    public returns (bool);
}
