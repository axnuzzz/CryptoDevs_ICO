// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable {
    uint public constant tokenPrice = 0.001 ether;

    uint public constant tokensPerNFT = 10 * 10 ** 18;
    uint public constant maxTotalSupply = 10000 * 10 ** 18;

    ICryptoDevs CryptoDevsNFT;

    mapping(uint => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsContract) ERC20("CryptoDev Token", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    function mint(uint amount) public payable {
        uint _requiredAmount = tokenPrice * amount;
        require(msg.value >= _requiredAmount, "Ether sent is not correct");

        uint256 amountWithDecimals = amount * 10 ** 18;
        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSupply,
            "Exceeds the ax total supply available"
        );

        _mint(msg.sender, amountWithDecimals);
    }

    function claim() public {
        address sender = msg.sender;

        uint balance = CryptoDevsNFT.balanceOf(sender);

        require(balance > 0, "You don't own any CryptoDev NFT");

        uint amount = 0;
        for (uint i = 0; i < balance; i++) {
            uint tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
            if (!tokenIdsClaimed[tokenId]) {
                amount++;
                tokenIdsClaimed[tokenId] = true;
            }
        }

        require(amount > 0, "You have already claimed all the tokens");
        _mint(msg.sender, amount * tokensPerNFT);
    }

    function withdraw() public onlyOwner {
        uint amount = address(this).balance;
        require(amount > 0, "Nothing to withdraw, Current Balance empty");

        address _owner = owner();
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send ether");
    }

    receive() external payable {}

    fallback() external payable {}
}
