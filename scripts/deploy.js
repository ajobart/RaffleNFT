const hre = require("hardhat");
// La librairie pour construire l'arbre de Merkle
const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');
const tokens = require('./tokens.json');

async function main() {

  // Création de l'arbre de Merkle
  // Tableau des address autorisé à minté
  let tab = [];
  // On va dans le fichier json et pour chaque address on la push dans le tableau
  tokens.map(token => {
    tab.push(token.address);
  });
  // On va hash les address
  const leaves = tab.map(address => keccak256(address));
  // On créer un arbre de Merkle
  const tree = new MerkleTree(leaves, keccak256, { sort: true });
  const root = tree.getHexRoot();

  const Raffle = await hre.ethers.getContractFactory("ERC721Merkle");
  const raffle = await Raffle.deploy("ETHERWISH", "ETW", root);

  await raffle.deployed();

  console.log("Raffle deployed to:", raffle.address);
}

// We recommend this pattern to be able to use async/await everywhere

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
