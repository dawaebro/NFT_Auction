pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";

contract SimpleAuction is Ownable{

	// Keep auction ID and map all fields to that to handle multiple auctions
    NFTokenMetadata _nft;
    mapping(uint256 => address) tokenOwner;
    mapping(uint256 => uint256) tokenId;
    

    // Parameters of the auction. Times are either
    // absolute unix timestamps (seconds since 1970-01-01)
    // or time periods in seconds.
    // address payable public beneficiary;
    mapping(uint256 => address payable) beneficiary;
    
    uint256 internal secondsInDay = 86400;

    // uint public auctionEndTime;
    mapping(uint256 => uint) auctionEndTime;

    // Current state of the auction.
    // address public highestBidder;
    // uint public highestBid;
    mapping(uint256 => address) highestBidder;
    mapping(uint256 => uint) highestBid;

    // Allowed withdrawals of previous bids
    // mapping(address => uint) pendingReturns;
    mapping(uint256 => mapping(address => uint)) pendingReturns;

    // Set to true at the end, disallows any change.
    // By default initialized to `false`.
    // bool ended;
    mapping(uint256 => bool) ended;

    // Events that will be emitted on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    // The following is a so-called natspec comment,
    // recognizable by the three slashes.
    // It will be shown when the user is asked to
    // confirm a transaction.
    constructor(NFTokenMetadata _addressOfNFT) {
        _nft = _addressOfNFT;
    }

    /// Create a simple auction with `_biddingTime`
    /// seconds bidding time on behalf of the
    /// beneficiary address `_beneficiary`.
    function startAuction(
        uint256 _auctionId,
        uint256 _tokenId,
        address payable _beneficiary
    ) public {
        require(msg.sender == _nft.ownerOf(_tokenId), "Only token owner can start auction for the tokenId");
        beneficiary[_auctionId] = _beneficiary;
        auctionEndTime[_auctionId] = block.timestamp + secondsInDay;
        tokenOwner[_auctionId] = _nft.ownerOf(_tokenId);
        tokenId[_auctionId] = _tokenId;
    }
    
    function disableClaim(uint256 _auctionId) public onlyOwner {
        ended[_auctionId] = true;
    }

    /// Bid on the auction with the value sent
    /// together with this transaction.
    /// The value will only be refunded if the
    /// auction is not won.
    function bid(uint256 _auctionId) public payable {
        // No arguments are necessary, all
        // information is already part of
        // the transaction. The keyword payable
        // is required for the function to
        // be able to receive Ether.
        
        // Check if auction ended
        require(!ended[_auctionId], "auctionEnd has already been called.");

        // Revert the call if the bidding
        // period is over.
        require(
            block.timestamp <= auctionEndTime[_auctionId],
            "Auction already ended."
        );

        // If the bid is not higher, send the
        // money back (the failing require
        // will revert all changes in this
        // function execution including
        // it having received the money).
        require(
            msg.value > highestBid[_auctionId],
            "There already is a higher bid."
        );

        if (highestBid[_auctionId] != 0) {
            // Sending back the money by simply using
            // highestBidder.send(highestBid) is a security risk
            // because it could execute an untrusted contract.
            // It is always safer to let the recipients
            // withdraw their money themselves.
            pendingReturns[_auctionId][highestBidder[_auctionId]] += highestBid[_auctionId];
        }
        highestBidder[_auctionId] = msg.sender;
        highestBid[_auctionId] = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    /// Withdraw a bid that was overbid.
    function withdraw(uint256 _auctionId) public returns (bool) {
        uint amount = pendingReturns[_auctionId][msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `send` returns.
            pendingReturns[_auctionId][msg.sender] = 0;

            if (!payable(msg.sender).send(amount)) {
                // No need to call throw here, just reset the amount owing
                pendingReturns[_auctionId][msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    /// End the auction and send the highest bid
    /// to the beneficiary.
    function auctionEnd(uint256 _auctionId) public {
        // It is a good guideline to structure functions that interact
        // with other contracts (i.e. they call functions or send Ether)
        // into three phases:
        // 1. checking conditions
        // 2. performing actions (potentially changing conditions)
        // 3. interacting with other contracts
        // If these phases are mixed up, the other contract could call
        // back into the current contract and modify the state or cause
        // effects (ether payout) to be performed multiple times.
        // If functions called internally include interaction with external
        // contracts, they also have to be considered interaction with
        // external contracts.

        // 1. Conditions
        require(block.timestamp >= auctionEndTime[_auctionId], "Auction not yet ended.");
        require(!ended[_auctionId], "auctionEnd has already been called.");

        // 2. Effects
        ended[_auctionId] = true;
        emit AuctionEnded(highestBidder[_auctionId], highestBid[_auctionId]);

        // 3. Interaction
        beneficiary[_auctionId].transfer(highestBid[_auctionId]);
        
        // 4. Transfer NFT to winner
        _nft.transferFrom(tokenOwner[_auctionId], msg.sender, tokenId[_auctionId]);
    }
}