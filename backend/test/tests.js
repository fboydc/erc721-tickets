const TicketRepository = artifacts.require("./TicketRepository.sol");

contract("TicketRepository",  async (accounts) => {

    const creatorAccount = accounts[0];
    const ticket_buyer_1 = accounts[1];
    const ticket_buyer_2 = accounts[2];
    const ticket_rebuyer_1 = accounts[3];
    let instance; 
    beforeEach("create a contract instance everytime", async ()=>{
        instance = await TicketRepository.deployed();
    })
    it("should be able to register a ticket", async ()=>{
        
        await instance.emitTicket(ticket_buyer_1, 1);
        assert.equal(await instance.ownerOf(1), ticket_buyer_1);
    })

    it("should be able to transfer a ticket", async ()=>{
        await instance.transferFrom(ticket_buyer_1, ticket_rebuyer_1, 1);
        assert.equal(await instance.ownerOf(1), ticket_rebuyer_1);
    })
});