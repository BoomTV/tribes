pragma solidity ^0.4.24;

import "./base/MintableToken.sol";
import "./registry/HasRegistry.sol";


contract CompliantToken is HasRegistry, MintableToken {
  // Addresses can also be blacklisted, preventing them from sending or receiving
  // TRIBES tokens. This can be used to prevent the use of TRIBES by bad actors in
  // accordance with law enforcement.

  modifier onlyIfNotBlacklisted(address addr) {
    require(
      !registry().hasAttribute(
        addr,
        Attribute.AttributeType.IS_BLACKLISTED
      )
    );
    _;
  }

  modifier onlyIfBlacklisted(address addr) {
    require(
      registry().hasAttribute(
        addr,
        Attribute.AttributeType.IS_BLACKLISTED
      )
    );
    _;
  }

  modifier onlyIfPassedKYC_AML(address addr) {
    require(
      registry().hasAttribute(
        addr,
        Attribute.AttributeType.HAS_PASSED_KYC_AML
      )
    );
    _;
  }

  function _mint(
    address to,
    uint256 value
  )
    internal
    onlyIfPassedKYC_AML(to)
    onlyIfNotBlacklisted(to)
  {
    super._mint(to, value);
  }

  // transfer and transferFrom both call this function, so check blacklist here.
  function _transfer(
    address from,
    address to,
    uint256 value
  )
    internal
    onlyIfNotBlacklisted(from)
    onlyIfNotBlacklisted(to)
    onlyIfPassedKYC_AML(to)
  {
    super._transfer(from, to, value);
  }
}
