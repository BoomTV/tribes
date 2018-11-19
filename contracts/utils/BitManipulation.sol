pragma solidity ^0.4.24;

library BitManipulation {
  uint256 constant internal _ONE = uint256(1);

  function _setBit(uint256 num, uint256 pos) internal pure returns (uint256) {
    return num | (_ONE << pos);
  }

  function _clearBit(uint256 num, uint256 pos) internal pure returns (uint256) {
    return num & ~(_ONE << pos);
  }

  function _toggleBit(uint256 num, uint256 pos) internal pure returns (uint256) {
    return num ^ (_ONE << pos);
  }

  function _checkBit(uint256 num, uint256 pos) internal pure returns (bool) {
    return (num >> pos & _ONE == _ONE);
  }
}
