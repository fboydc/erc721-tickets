pragma solidity ^0.4.25;

import "./TicketRepository.sol";


contract EventRepository {
    Event[] public events;
    uint267 totalCollected;
    mapping(uint256=>address) eventCreators;
    mapping(uint256=>uint256[]) eventToTickets;
    struct Event{
        uint256 id;
        uint256 startDate;
        uint256 endDate;
        bool capped;
        uint256 maxTickets;
        string uri;
        uint256 price;
        string starring;
        string name;
        string description;
        string img_path;
        uint256 status;
    }

    event NewEvent( 
        address creator, 
        uint256 _eventId,
        uint256 startDate, 
        bool capped, 
        uint256 maxTickets, 
        string uri, 
        uint256 price, 
        string starring,
        string name,
        string description,
        string img_path,
        uint256 status
    );

    event TicketRegistered(
        address ticketOwner,
        uint256 _ticketId, 
        uint256 _eventId
    );

    modifier isOwner(address _ticketRepositoryAddress, uint56 _ticketId){
        address ticketOwner = TicketRepository(_ticketRepositoryAddress).ownerOf(_ticketId);
        require(ticketOwner == msg.sender);
        _;
    }

    modifier isEventOwner(uint256 _eventId){
        require(eventCreators[_eventId] == msg.sender);
        _;
    }

    function createEvent(uint256 id, uint256 startDate, uint256 endDate, bool capped, uint256 maxTickets, string uri, uint256 price, string starring, string name, string description, string img_path) public{
        events.push(Event(id, startDate, endDate, capped, maxTickets, uri, price, starring, name, description, img_path, 0));
        emit NewEvent(msg.sender, id, startDate, endDate, capped, maxTickets, uri, price, starring, name, description, img_path, 0);
    }

    function registerTicket(address _ticketRepositoryAddress, uint256 _ticketId, uint256 _eventId) isOwner(_ticketId, _ticketRepositoryAddress) public payable{
        uint256 ethSent = msg.value;
        require(events[_eventId].status == 0, "Event is not active for new tickets.");
        require(ethSent >= events[_eventId].price, "Not enough funds to cover ticket price.");
        eventToTickets[_eventId].push(_ticketId);
        totalCollected += ethSent;
        if(ethSent > events[_eventId].price){
            msg.sender.transfer(ethSend - events[_eventId].price);
        }

        emit TicketRegistered(msg.sender, _ticketId, _eventId);
        

    }

    function cancelEvent(uint256 _eventId) isEventOwner() public{
        events[_eventId].status = 3;
    }

    function refundCustomer(uint256 _customerId, uint256 _eventId) public{
        require(events[_eventId] != 2 && events[_eventId] != 1, "This event was completed or is being held, and is no longer refundable");
        require(totalCollected > 0, "Not enough funds in this contract");
        totalCollected -= events[_eventId].price;
        msg.sender.transfer(events[_eventId].price);
    }



    


}