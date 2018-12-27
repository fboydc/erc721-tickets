pragma solidity ^0.4.24;

import "./TicketRepository.sol";


contract EventRepository {
    Event[] public events;
    uint256 totalCollected;
    mapping(uint256=>address) eventCreators;
    mapping(uint256=>uint256[]) eventToTickets;
    
    struct Event{
        uint256 id;
        uint256 startDate;
        uint256 endDate;
        bool capped;
        uint256 maxTickets;
        uint256 price;
        string starring;
        uint256 status;
    }
    
    event NewEvent( 
        address creator, 
        uint256 _eventId
    );

    event TicketRegistered(
        address ticketOwner,
        uint256 _ticketId, 
        uint256 _eventId
    );

    event EventCancelled (
        uint256 _eventId,
        address eventCreator
    );

    modifier isOwner(address _ticketRepositoryAddress, uint256 _ticketId){
        address ticketOwner = TicketRepository(_ticketRepositoryAddress).ownerOf(_ticketId);
        require(ticketOwner == msg.sender);
        _;
    }

    modifier isEventOwner(uint256 _eventId){
        require(eventCreators[_eventId] == msg.sender);
        _;
    }

    
    function createEvent(
        uint256 id,
        uint256 startDate,
        uint256 endDate,
        bool capped,
        uint256 maxTickets,
        uint256 price,
        string starring,
        uint256 status) public{
        events.push(Event(id, startDate, endDate, capped, maxTickets, price, starring, status));
        emit NewEvent(msg.sender, id);
    }
    
    function registerTicket(
        address _ticketRepositoryAddress, 
        uint256 _ticketId, 
        uint256 _eventId) isOwner(_ticketRepositoryAddress, _ticketId) public payable{
        uint256 ethSent = msg.value;
        require(events[_eventId].status == 0, "Event is not active for new tickets.");
        require(ethSent >= events[_eventId].price, "Not enough funds to cover ticket price.");
        eventToTickets[_eventId].push(_ticketId);
        totalCollected += ethSent;
        if(ethSent > events[_eventId].price){
            msg.sender.transfer(ethSent - events[_eventId].price);
        }

        emit TicketRegistered(msg.sender, _ticketId, _eventId);
        
    }

    function cancelEvent(uint256 _eventId) isEventOwner(_eventId) public{
        events[_eventId].status = 3;
        emit EventCancelled(_eventId, msg.sender);
    }

    function refundCustomer(uint256 _eventId) public{
        require(events[_eventId].status != 2 && events[_eventId].status != 1);
        require(totalCollected > 0, "Not enough funds in this contract");
        totalCollected -= events[_eventId].price;
        msg.sender.transfer(events[_eventId].price);
    }

    



    


}