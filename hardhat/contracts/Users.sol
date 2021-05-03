pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol";

contract Users is ERC721, ERC721Enumerable {
  using Strings for uint256;

  mapping (uint256 => UserMetaData) private _userMetaData; // Currently userMetaData 
  // mapping (string => uint256) private _usernames;

  // Need to think of a way to ensure username uniqueness...
  struct UserMetaData {
    string username;
    bytes32 password; // Keccak256 hashed
  }

  constructor() public ERC721("Authentication-NFT", "ANFT") {}

  function tokenURI(uint256 tokenId) public view virtual override returns (UserMetaData memory) {
    return userMetaData(tokenId);
  }

  function userMetaData(uint256 tokenId) public view virtual returns (UserMetaData memory) {
    require(_exists(tokenId), "SubscriptionToken: Query for nonexistent token");
    return _userMetaData[tokenId];
  }

  function authenticate(address user, string memory username, string memory password) external view virtual returns (bool) {
    ERC721.ownerOf()
  }

  function _setTokenData(uint256 tokenId, string memory _userData) internal virtual {
    require(_exists(tokenId), "SubscriptionToken: Data set of nonexistent token");
    _userMetaData[tokenId] = _userData;
  }

  function _burn(uint256 tokenId) internal virtual override {
    ERC721._burn(tokenId);

    if(bytes(_userMetaData[tokenId]).length != 0) {
      delete _userMetaData[tokenId];
    }
  }
}