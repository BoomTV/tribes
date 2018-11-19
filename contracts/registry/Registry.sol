pragma solidity ^0.4.24;

import "../ownership/ClaimableEx.sol";
import "../utils/BitManipulation.sol";
import "./Attribute.sol";
import "./DefaultRegistryAccessManager.sol";
import "./RegistryAccessManager.sol";


contract Registry is ClaimableEx {
  using BitManipulation for uint256;

  struct AttributeData {
    uint256 value;
  }

  // Stores arbitrary attributes for users. An example use case is an ERC20
  // token that requires its users to go through a KYC/AML check - in this case
  // a validator can set an account's "hasPassedKYC/AML" attribute to 1 to indicate
  // that account can use the token. This mapping stores that value (1, in the
  // example) as well as which validator last set the value and at what time,
  // so that e.g. the check can be renewed at appropriate intervals.
  mapping(address => AttributeData) private _attributes;

  // The logic governing who is allowed to set what attributes is abstracted as
  // this _accessManager, so that it may be replaced by the owner as needed.
  RegistryAccessManager private _accessManager;

  event SetAttribute(
    address indexed who,
    Attribute.AttributeType attribute,
    bool enable,
    string notes,
    address indexed adminAddr
  );

  event SetManager(
    address indexed oldManager,
    address indexed newManager
  );

  constructor() public {
    _accessManager = new DefaultRegistryAccessManager();
  }

  // Writes are allowed only if the _accessManager approves
  function setAttribute(
    address who,
    Attribute.AttributeType attribute,
    string notes
  )
    public
  {
    bool canWrite = _accessManager.confirmWrite(
      who,
      attribute,
      msg.sender
    );
    require(canWrite);

    // Get value of previous attribute before setting new attribute
    uint256 tempVal = _attributes[who].value;

    _attributes[who] = AttributeData(
      tempVal._setBit(Attribute.toUint256(attribute))
    );

    emit SetAttribute(who, attribute, true, notes, msg.sender);
  }

  function clearAttribute(
    address who,
    Attribute.AttributeType attribute,
    string notes
  )
    public
  {
    bool canWrite = _accessManager.confirmWrite(
      who,
      attribute,
      msg.sender
    );
    require(canWrite);

    // Get value of previous attribute before setting new attribute
    uint256 tempVal = _attributes[who].value;

    _attributes[who] = AttributeData(
      tempVal._clearBit(Attribute.toUint256(attribute))
    );

    emit SetAttribute(who, attribute, false, notes, msg.sender);
  }

  // Returns true if the uint256 value stored for this attribute is non-zero
  function hasAttribute(
    address who,
    Attribute.AttributeType attribute
  )
    public
    view
    returns (bool)
  {
    return _attributes[who].value._checkBit(Attribute.toUint256(attribute));
  }

  // Returns the exact value of the attribute, as well as its metadata
  function getAttributes(
    address who
  )
    public
    view
    returns (uint256)
  {
    AttributeData memory data = _attributes[who];
    return data.value;
  }

  function setManager(RegistryAccessManager accessManager) public onlyOwner {
    emit SetManager(_accessManager, accessManager);
    _accessManager = accessManager;
  }

  function accessManager() public view returns (RegistryAccessManager) {
    return _accessManager;
  }
}
