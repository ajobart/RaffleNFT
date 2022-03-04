pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract ERC721Merkle is ERC721 {
  // Racine de l'arbre de Merkle
  bytes32 immutable public root;
  uint tokenId = 1;

  constructor(string memory name, string memory symbol, bytes32 merkleroot)
  ERC721(name, symbol) {
    root = merkleroot;
  }

  function getPrice() public view returns(uint) {
    // Prix d'un NFT
    uint _price = 0.3 ether;
    return _price;
  }

  // Permet de savoir si un compte est whitelisté ou non
  function isWhiteListed(address account, bytes32[] calldata proof) internal view returns(bool) {
    return _verify(_leaf(account), proof);
  }

  // Fonction pour minté un NFT
  function mintNFT(address account, bytes32[] calldata proof) external payable {
    uint price = getPrice();
    require(isWhiteListed(account, proof), "You are not on the whitelist");
    require(msg.value >= price, "Not enought funds");
    _safeMint(account, tokenId, "");
    tokenId++;
  }

  function _leaf(address account) internal pure returns(bytes32) {
    return keccak256(abi.encodePacked(account));
  }

  // Verifie si une address est bien présente dans la whitelist
  function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
    return MerkleProof.verify(proof, root, leaf);
  }
}
