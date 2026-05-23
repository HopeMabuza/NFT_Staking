const {ethers} = require("hardhat");

async function main(){
    const [user1, user2] = await ethers.getSigners();
    const user1Address = await user1.getAddress();

    const Token = await ethers.getContractFactory("MyToken");
    const token = await Token.deploy(user1Address);
    await token.waitForDeployment();

    const tokenAddress = await token.getAddress();
    console.log("Token address: ", tokenAddress);

}
main().catch(console.error)