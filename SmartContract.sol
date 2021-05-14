pragma solidity ^0.5.0;

contract HearthstoneUser {
    address private addressUser;
    string private nameUser;
    uint private gold;
    uint private dust;
    uint private numberCards;
    
    struct card {
        string nameCard;
        string descriptionCard;
        string typeCard;
        uint manaCostCard;
        uint dustValue;
        uint numberCount;
    }
    
    mapping (uint => card) colectionCard;
    
    uint internal randomNumber;
    
    
    constructor(string memory _nameUser, uint _gold, uint _dust) public {
        nameUser = _nameUser;
        gold = _gold;
        dust = _dust;
        numberCards = 0;
        addressUser = msg.sender;
    }
    
    /*
    function setNameUser (string memory _nameUser) public {
        nameUser = _nameUser;
    }
    
    function setGold (uint _gold) public {
        gold = _gold;
    }
    
    function setDust (uint _dust) public {
        dust = _dust;
    }
    */
    
    modifier hasGoldEnough() {
        require(gold >= 100, "You don't have enough gold ):");
        _;
    }
    
    /*
    function getNameUser() public view returns (string memory) {
        return nameUser;
    }
    */
    
    function getGold() public view returns (uint) {
        return gold;
    }
    
    function getDust() public view returns (uint) {
        return dust;
    }
    
    function createCard(string memory nameCard, string memory descriptionCard, string memory typeCard, uint manaCostCard, uint dustValue, uint numberCount) public {
        colectionCard[numberCards].nameCard = nameCard;
        colectionCard[numberCards].descriptionCard = descriptionCard;
        colectionCard[numberCards].typeCard = typeCard;
        colectionCard[numberCards].manaCostCard = manaCostCard;
        colectionCard[numberCards].dustValue = dustValue;
        colectionCard[numberCards].numberCount = numberCount;
        
        numberCards += 1;
    }
    
    function getCardInfo(uint cardAdd) public view returns (string memory, string memory, string memory, uint, uint, uint) {
        return (colectionCard[cardAdd].nameCard, colectionCard[cardAdd].descriptionCard, colectionCard[cardAdd].typeCard, colectionCard[cardAdd].manaCostCard, colectionCard[cardAdd].dustValue, colectionCard[cardAdd].numberCount);
    }
    
    function getNumberCards() public view returns (uint) {
        return numberCards;
    }
    
    function randomNumberMod(uint mod) internal {
        randomNumber = uint(keccak256(abi.encodePacked(
            now, 
            block.difficulty, 
            msg.sender)
        )) % mod;
    }
    
    function makeQuest() public {
        randomNumberMod(15);
        gold += randomNumber * 10;
    }
    
    function disenchantCard(uint cardAdd) public {
        /// trebuie sa scad numberCount cu 1
        require(colectionCard[cardAdd].numberCount > 0, "You don't own this card ):"); 
        colectionCard[cardAdd].numberCount -= 1;
        dust += colectionCard[cardAdd].dustValue;
    }
    
    function openPack() public hasGoldEnough {
        uint cardAdressesLength = numberCards;
        require(cardAdressesLength > 0, "You don't have any cards ):");
        
        gold -= 100;
        
        for(uint i = 0; i < 5; ++i) {
            randomNumberMod(cardAdressesLength);
            uint cardIndex = randomNumber;
            colectionCard[cardIndex].numberCount += 1;
        }
    }
}