require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });

//deployed address : 0x2326BE6b9A36ce55560370ca4c5F50Cd82c82055

const QUICKNODE_HTTP_URL = process.env.QUICKNODE_HTTP_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    sepolia: {
      url: QUICKNODE_HTTP_URL,
      accounts: [PRIVATE_KEY],
    },
  },
};
