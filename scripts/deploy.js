async function main() {
  // We get the contract to deploy
  const Benk = await ethers.getContractFactory("Benk");
  const benk = await Benk.deploy();

  console.log("Benk deployed to:", benk.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
