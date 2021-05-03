pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

// Making the tokens enumerable for each owner isn't strictly speaking necessary.
// The frontend only needs to authenticate based on username, password pair and 

// Password encryption should ideally be unique for each User implementation.
// keccak256 does a basic job of hashing and hence ensuring the safety of passwords.
abstract contract AbstractUser is ERC165, IERC721, IERC721Enumerable {
  using Address for address;
  using Strings for uint256;

  mapping (uint256 => address) private _owners;
  mapping (address => uint256) private _balances;
  mapping (uint256 => address) private _tokenApprovals;
  mapping (address => mapping(uint256 => uint256)) private _ownedTokens;
  mapping (uint256 => uint256) private _ownedTokensIndex;
  uint256[] private _allTokens;
  mapping (uint256 => UserMeta) private _tokenMetas;

  function balanceOf(address owner) external virtual override view returns (uint256 balance) {
    return _balances[owner];
  }

  function register(address user, string memory username, string memory password) external virtual {
  }

  function authenticate (string memory username, string memory password) external virtual returns (bool) {
  }

  function _exists(uint256 tokenId) internal view virtual returns (bool) {
    return _owners[tokenId] != address(0);
  }

  function _mint(address to, uint256 tokenId) internal virtual {
    require(to != address(0), "AbstractUser: minting to zero address");
    require(!_exists(tokenId), "AbstractUser: token already minted");

    //_beforeTokenTransfer(address(0), to, tokenId);

    _balances[to] += 1;
    _owners[tokenId] = to;

    emit Transfer(address(0), to, tokenId);
  }

  function _safeMint(address to, uint256 tokenId) internal virtual {
    _safeMint(to, tokenId, "");
  }

  function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
    _mint(to, tokenId);
    require(_checkOnTokenRecieved(address(0), to, tokenId, _data), "AbstractUser: transfer attempted to non-Reciever.");
  }

  function _checkOnTokenRecieved(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
    if (to.isContract()) { return false; }
    else { return true; }
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
    return interfaceId == type(IERC721Enumerable).interfaceId
        || interfaceId == type(IERC721).interfaceId
        || super.supportsInterface(interfaceId);
  }
}