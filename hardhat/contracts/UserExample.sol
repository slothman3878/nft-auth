// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AbstractUser.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract User is AbstractUser {
  using Counters for Counters.Counter;
  using Strings for uint256;

  Counters.Counter private _counter; // Token Index counter. Equals to the number of tokens in total.
  mapping (uint256 => TokenMeta) private _tokenMetas;
  mapping (string => uint256) private _username2tokenId;

  struct TokenMeta{
    string username;
    string profile;
  }

  constructor () {
    _counter.increment();
  }

  function name() external view virtual returns (string memory) { return "User Example"; }

  function register(string calldata username) external virtual {
    require(!_exists(username), "User: username already exists");
    uint256 index = _counter.current();
    _safeMint(_msgSender(), index);
    // Start with empty profile
    _username2tokenId[username] = index;
    _setTokenMeta(index, TokenMeta(username,""));
    _counter.increment();
  }

  function authenticate(string memory username) public view virtual returns (bool) {
    require(_exists(username), "User: authenticate nonexistent user");
    return AbstractUser._isApprovedOrOwner(_msgSender(), _username2tokenId[username]);
  }

  function setProfile(string calldata username, string calldata profile) external virtual {
    require(authenticate(username), "User: set profile of unauthenticated user");
    _tokenMetas[_username2tokenId[username]].profile = profile;
  }

  function deleteAccount(string calldata username) external virtual {
    require(authenticate(username), "User: delete unauthenticated user");
    _burn(_username2tokenId[username]);
  }

  function tokenMeta(uint256 tokenId) public view virtual returns (TokenMeta memory) {
    require(_exists(tokenId), "User: URI query for nonexistent token");
    return _tokenMetas[tokenId];
  }

  function _setTokenMeta(uint256 tokenId, TokenMeta memory meta) internal virtual {
    require(_exists(tokenId), "User: Meta set for nonexistent user");
    _tokenMetas[tokenId] = meta;
  }

  function _exists(string memory username) internal view virtual returns (bool) {
    return _exists(_username2tokenId[username]);
  }
}