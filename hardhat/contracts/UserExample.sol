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
  mapping (string => bytes32) private _authPair; // username, password pair
  mapping (string => uint256) private _username2tokenId;

  struct TokenMeta{
    string username;
    string profile;
  }

  function register(string calldata username, string calldata password) external virtual override {
    require(!_exists(username), "User: username already exists");
    uint256 index = _counter.current();
    _safeMint(_msgSender(), index);
    // Start with empty profile
    _username2tokenId[username] = index;
    _setTokenMeta(index, TokenMeta(username,""));
    _authPair[username] == keccak256(abi.encode(password));
    _counter.increment();
  }

  function authenticate(string memory username, string memory password) public view virtual override returns (bool) {
    require(_exists(username), "User: authenticate nonexistent user");
    return keccak256(abi.encode(password)) == _authPair[username];
  }

  function deleteAccount(string calldata username, string calldata password) external virtual {
    require(_exists(username), "User: delete nonexistent user");
    require(authenticate(username,password), "User: delete unauthenticated user");
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
    return _authPair[username] != "";
  }
}