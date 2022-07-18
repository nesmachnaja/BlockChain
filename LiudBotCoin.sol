// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//CryptoCurrensy LiudBotCoin
contract LiudBotCoin{

    address owner; // владелец крипты
    mapping(address => uint) public balances; // балансы всех пользователей
    uint fee = 1;

    constructor() {
        owner = msg.sender; // запоминаем пользователя, кот создал контракт и считаем его владельцем
    }

    // создать монету и отправить получателю
    // receiver - получатель
    // amount - кол-во монет, кот он получит
    function createCoin(address reciever, uint amount) public {
        require(msg.sender == owner, "Only owner can create coins"); // проверим, кто пытается создать монету
        balances[reciever] += amount;
    }

    function sendCoin(address reciever, uint amount) public {
        // проверим, что у отправителя достаточно денег
        require(balances[msg.sender] >= amount, "Insufficient balance!");
        require(reciever != msg.sender, "You cannot send coins to yourself");

        balances[msg.sender] -= amount + fee;
        balances[owner] += fee;
        balances[reciever] += amount;
    }
}
