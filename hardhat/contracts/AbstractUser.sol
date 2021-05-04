// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

// Modified openzeppelin's ERC721 contract (essentially removal of any tokenURI related functions)
// No longer are these tokens storing URIs, but a user's metadata.

// Making the tokens enumerable for each owner isn't strictly speaking necessary.
// The frontend only needs to authenticate based on username, password pair, and maybe msgSender.

// Write an enumerable version separately

// Password encryption should ideally be unique for each User implementation.
// keccak256 does a basic job of hashing and hence ensuring the safety of passwords.
abstract contract AbstractUser is Context, ERC165, IERC721 {
  using Address for address;

  mapping (uint256 => address) private _owners;
  mapping (address => uint256) private _balances;
  // Note: approvals not only deal with the transfer of tokens, but can be given authority to manage the user's metadata.
  mapping (uint256 => address) private _tokenApprovals;
  mapping (address => mapping (address => bool)) private _operatorApprovals;

  function register(string calldata username, string calldata password) external virtual;

  function authenticate (string calldata username, string calldata password) external virtual returns (bool);

  function balanceOf(address owner) external virtual override view returns (uint256 balance) {
    require(owner != address(0), "ERC721: balance query for the zero address");
    return _balances[owner];
  }

  function ownerOf(uint256 tokenId) public view virtual override returns (address) {
    address owner = _owners[tokenId];
    require(owner != address(0), "ERC721: owner query for nonexistent token");
    return owner;
  }

  function approve(address to, uint256 tokenId) public virtual override {
    address owner = AbstractUser.ownerOf(tokenId);
    require(to != owner, "ERC721: approval to current owner");

    require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
        "ERC721: approve caller is not owner nor approved for all"
    );

    _approve(to, tokenId);
  }

  function getApproved(uint256 tokenId) public view virtual override returns (address) {
    require(_exists(tokenId), "ERC721: approved query for nonexistent token");

    return _tokenApprovals[tokenId];
  }

  function setApprovalForAll(address operator, bool approved) public virtual override {
    require(operator != _msgSender(), "ERC721: approve to caller");

    _operatorApprovals[_msgSender()][operator] = approved;
    emit ApprovalForAll(_msgSender(), operator, approved);
  }

  function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
    return _operatorApprovals[owner][operator];
  }

  // The transfer functions are necessary for inheriting IERC721.
  // That being said, as an implementation of a User model, transfer of the tokens are usually unnecessary.
  function transferFrom(address from, address to, uint256 tokenId) public virtual override {}

  function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {}

  function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) public virtual override {}

  function _exists(uint256 tokenId) internal view virtual returns (bool) {
    return _owners[tokenId] != address(0);
  }

  function _mint(address to, uint256 tokenId) internal virtual {
    require(to != address(0), "ERC721: minting to zero address");
    require(!_exists(tokenId), "ERC721: token already minted");

    _beforeTokenTransfer(address(0), to, tokenId);

    _balances[to] += 1;
    _owners[tokenId] = to;

    emit Transfer(address(0), to, tokenId);
  }

  function _safeMint(address to, uint256 tokenId) internal virtual {
    _safeMint(to, tokenId, "");
  }

  function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
    _mint(to, tokenId);
    require(_checkOnTokenRecieved(address(0), to, tokenId, _data), "ERC721: transfer attempted to non-Reciever.");
  }

  function _burn(uint256 tokenId) internal virtual {
    address owner = AbstractUser.ownerOf(tokenId);

    _beforeTokenTransfer(owner, address(0), tokenId);

    _approve(address(0), tokenId);

    _balances[owner] -= 1;
    delete _owners[tokenId];

    emit Transfer(owner, address(0), tokenId);
  }

  function _transfer(address from, address to, uint256 tokenId) internal virtual {
    require(AbstractUser.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
    require(to != address(0), "ERC721: transfer to the zero address");

    _beforeTokenTransfer(from, to ,tokenId);

    // Clear approvals from previous owner
    _approve(address(0), tokenId);

    _balances[from] -= 1;
    _balances[to] += 1;
    _owners[tokenId] = to;
    
    emit Transfer(from, to, tokenId);
  }

  function _approve(address to, uint256 tokenId) internal virtual {
    _tokenApprovals[tokenId] = to;
    emit Approval(AbstractUser.ownerOf(tokenId), to, tokenId);
  }

  function _checkOnTokenRecieved(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
    if (to.isContract()) { return false; }
    else { return true; }
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
    return interfaceId == type(IERC721).interfaceId
        || super.supportsInterface(interfaceId);
  }

  function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
}