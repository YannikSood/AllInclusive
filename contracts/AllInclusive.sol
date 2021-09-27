pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/**
 * @title This contract will allow approved addresses to buy a "ticket".
 * The proceeds from ticket sales will be added to a vault, and will be used to cover lodging & other ameneties for the people who hold a ticket.
 * A cool way for me and my friends to set up our NYE Miami trip using ethereum :)
 * 
 */
contract AllInclusive is ERC721, Ownable {
    
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath8 for uint8;
    
    address[] guestList;
    address[] rsvpList;
    
    bool public rsvpOpen = true;
    bool public upgradesAvailable = true;
    uint256 public ticketPrice = 0.2 ether;
    uint256 public upgradePrice = 0.1 ether;
    uint numTix = 0;
    
    mapping(address => uint8) public ticketHolders;
    mapping(address => uint8) public ticketLevel;
    
    address public vaultWallet = 0xe000000000000000000000000000000000000000;
    
    constructor() public ERC721("AllInclusive", "ALLIN") {
        //ifps, first mint, etc
    }
    
    //mint a ticket, one per wallet. address must be in guestList
    function mintTicket() public payable {
        //do our checks
        require(checkGuestList(msg.sender) == true, "yo, who do you know here?");
        require(rsvpOpen == true, "oh nice, youre on the list. let me check if tickets are available");
        require(ticketHolders[msg.sender] == 0, "you sure you dont have a ticket already?");
        require(ticketHolders[msg.sender] < 1, "let me double check");
        require(msg.value >= ticketPrice, "ahh ok nice, you good, pay here");
    
        //mint the ticket
        _safeMint(msg.sender, numTix = numTix.add(1));
        payable(vaultWallet).transfer(msg.value);
        
        //this person has rsvp'd, they are good.
        rsvpList.push(msg.sender);
        tickerHolders[msg.sender] = 1;
        ticketLevel[msg.sender] = 1;
    }
    
    //use this function to upgrade your ticket, in case you want more stuff covered for the trip
    function upgradeTicket() public payable {
        require(checkGuestList(msg.sender) == true);
        require(upgradesAvailable == true);
        require(ticketHolders[msg.sender] == 1);
        require(msg.value >= upgradePrice, "ahh ok nice, you good, pay here");
        
        payable(vaultWallet).transfer(msg.value);
        
        ticketLevel[msg.sender] = ticketLevel[msg.sender].add(1);
    }
    
    //Check to see if an address is in a guest list. 
    function checkGuestList(address addy) private returns (bool) {
        for (uint i = 0; i < guestList.length; i++) {
            if (guestList[i] == addy) {
                return true;
            }
        }
        
        return false;
    }
    
    //Check if an address is already in a guest list, otherwise add it to the list
    function addToGuestList(address addy) public onlyOwner returns (bool) {
        //check if address is already there
        for (uint i = 0; i < guestList.length; i++) {
            if (guestList[i] == addy) {
                return false;
            }
        }
        
        guestList.push(addy);
        return true;
    }
    
    //stop allowing rsvps
    function changeRSVPstatus(bool rsvp) public onlyOwner {
        rsvpOpen = rsvp;
    }
    
    //stop allowing upgrades
    function changeRSVPstatus(bool upgrades) public onlyOwner {
        upgradesAvailable = upgrades;
    }
    
    
}