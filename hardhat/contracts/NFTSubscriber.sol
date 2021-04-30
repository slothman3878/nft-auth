pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract SubscriptionToken is ERC721 {
  using Strings for uint256;

  mapping (uint256 => string) private _userMetaData; // Currently userMetaData 

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    return userMetaData(tokenId);
  }

  function userMetaData(uint256 tokenId) public view virtual returns (string memory) {
    require(_exists(tokenId), "SubscriptionToken: Query for nonexistent token");
    return _userMetaData[tokenId];
  }

  function _setTokenData(uint256 tokenId, string memory _userData) internal virtual {
    require(_exists(tokenId), "SubscriptionToken: Data set of nonexistent token");
    _userMetaData[tokenId] = _userData;
  }

  function _burn(uint256 tokenId) internal virtual override {
    super._burn(tokenId);

    if(bytes(_userMetaData[tokenId]).length != 0) {
      delete _userMetaData[tokenId];
    }
  }
}