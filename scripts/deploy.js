const { ethers } = require("hardhat");

module.exports = async function main() {
  const Knowlytes = await ethers.getContractFactory("Knowlytes");
  const knowlytes = await Knowlytes.deploy();
  await knowlytes.deployed();
  console.log(knowlytes.address);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

