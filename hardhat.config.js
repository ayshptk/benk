require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.12",
  networks: {
    mumbai: {
      url: "https://matic-mumbai.chainstacklabs.com",
      accounts: [`0x${process.env.PK}`],
    },
  },
};
