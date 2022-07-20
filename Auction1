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

    function withDraw(address payable sender) public returns (bool){
        require(sender == msg.sender, "Invalid address");

        uint amount = chargeback[sender]; // сколько надо вернуть
        //msg.sender.payable = true;
        if (amount > 0){
            // посылаем деньги обратно
            if(sender.send(amount)){
                // если всё ок, то обнуляем долг
                chargeback[sender] = 0;
                return true;
            }
        }
        return false;
    }

    function finalizeAuction() public{
        require(block.timestamp >= endTime, "Auction hasn't ended yet");
        require(seller == msg.sender, "Only seller can finalize");

        seller.transfer(highestBid);
    }
}
