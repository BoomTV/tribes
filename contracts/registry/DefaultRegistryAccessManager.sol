pragma solidity ^0.4.24;

import "../openzeppelin/contracts/math/SafeMath.sol";

import "./Registry.sol";
import "./RegistryAccessManager.sol";


contract DefaultRegistryAccessManager is RegistryAccessManager {
  function confirmWrite(
    address /*who*/,
    Attribute.AttributeType attribute,
    address operator
  )
    public
    returns (bool)
  {
    Registry client = Registry(msg.sender);
    if (operator == client.owner()) {
      return true;
    } else if (client.hasAttribute(operator, Attribute.AttributeType.ROLE_MANAGER)) {
      return (attribute == Attribute.AttributeType.ROLE_OPERATOR);
    } else if (client.hasAttribute(operator, Attribute.AttributeType.ROLE_OPERATOR)) {
      return (attribute != Attribute.AttributeType.ROLE_OPERATOR &&
              attribute != Attribute.AttributeType.ROLE_MANAGER);
    }
  }
}
