var TicketRepository = artifacts.require("TicketRepository");

module.exports = (deployer)=>{
    deployer.deploy(TicketRepository, "criptovent", "ETCKT");
};