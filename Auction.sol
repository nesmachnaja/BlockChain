// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//CryptoCurrensy LiudBotCoin
contract Auction {

    address payable public seller; // продавец
    address highestBuilder; // юзер, сделавший макс ставку
    uint public highestBid; // текущая макс ставка
    uint endTime; // время, когда закончится аукцион
    mapping(address => uint) chargeback; // возвраты денег

    constructor(
        address payable _seller,
        uint auction_interval // время, кот будет длиться аукцион
    ) public {
        seller = _seller;
        endTime = block.timestamp + auction_interval;
    }

    function isEnded() private returns (bool){
        return block.timestamp > endTime;
    }

    // сделать ставку
    function makeBid() public payable {
        require(block.timestamp < endTime, "Auction is ended");
        require(msg.value > highestBid, "Invalid Bid");

        if (highestBid != 0){
            // предыдущий highestBilder должен получить свои деньги назад
            chargeback[highestBuilder] += highestBid;
        }

        highestBuilder = msg.sender;
        highestBid = msg.value;
    }

    function withDraw() public returns (bool){
        uint amount = chargeback[msg.sender]; // сколько надо вернуть
        if (amount > 0){
            // посылаем деньги обратно
            if(msg.sender.send(amount)){
                // если всё ок, то обнуляем долг
                chargeback[msg.sender] = 0;
                return true;
            }
        }
        return false;
    }

}
