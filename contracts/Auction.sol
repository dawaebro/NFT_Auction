pragma solidity >=0.7.0 <0.9.0;

import "@0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "./NFT.sol";
// import "NFT.sol";

contract SimpleAuction is Ownable{

    //modifiable variables
    uint256 internal secondsInDay = 60 * 10;
    // uint256 internal secondsInDay = 86400;
    uint256 internal last15Minutes = 60 * 15;
    uint256 internal additional15Mins = 60 * 15;
    uint256 internal nftPlatformShare = 15; // 15 percent of sale value. 

	// Keep auction ID and map all fields to that to handle multiple auctions
    NFT _nft;
    mapping(uint256 => address) tokenOwner;
    mapping(uint256 => uint256) tokenId;

    // Parameters of the auction. Times are either
    // absolute unix timestamps (seconds since 1970-01-01)
    // or time periods in seconds.
    // address payable public beneficiary;
    mapping(uint256 => address payable) beneficiary;

    // mapping to hold initial bid amount
    mapping(uint256 => uint256) initialBidAmount;

    // uint public auctionEndTime;
    mapping(uint256 => uint) public auctionEndTime;

    // Current state of the auction.
    // address public highestBidder;
    // uint public highestBid;
    mapping(uint256 => address) public highestBidder;
    mapping(uint256 => uint) public highestBid;

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
    constructor(address _addressOfNFT) {
        _nft = NFT(_addressOfNFT);
    }

    /// Create a simple auction with `_biddingTime`
    /// seconds bidding time on behalf of the
    /// beneficiary address `_beneficiary`.
    function startAuction(
        uint256 _auctionId,
        uint256 _tokenId,
        uint256 _initialBidAmount,
        address payable _beneficiary
    ) public {
        require(msg.sender == _nft.ownerOf(_tokenId), "Only token owner can start auction for the tokenId");
        beneficiary[_auctionId] = _beneficiary;
        auctionEndTime[_auctionId] = block.timestamp + secondsInDay * 3;
        tokenOwner[_auctionId] = _nft.ownerOf(_tokenId);
        initialBidAmount[_auctionId] = _initialBidAmount;
        tokenId[_auctionId] = _tokenId;
        _nft.setApprovalForAll(address(this), true);
    }
    
    function disableClaim(uint256 _auctionId) public onlyOwner {
        ended[_auctionId] = true;
    }

    function getInitialBidAmount(uint256 _auctionId) public view returns(uint256) {
        return initialBidAmount[_auctionId];
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

        // Check if last 1 minute
        require(block.timestamp < auctionEndTime[_auctionId] - 60, "Last one minute remaining. Not accepting any bids");

        // Revert the call if the bidding
        // period is over.
        require(
            block.timestamp <= auctionEndTime[_auctionId],
            "Auction already ended."
        );

        // Require price to be more than initial bid amount
        require(
            msg.value > initialBidAmount[_auctionId],
            "Please bid an amount > initialBidAmount"
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

        // if time to end is less
        if (auctionEndTime[_auctionId] < block.timestamp + last15Minutes) {
            auctionEndTime[_auctionId] = auctionEndTime[_auctionId] + additional15Mins;
        }


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

    function auctionEnd(uint256 _auctionId) public {

        // 1. Conditions
        require(block.timestamp >= auctionEndTime[_auctionId], "Auction not yet ended.");
        require(!ended[_auctionId], "auctionEnd has already been called.");

        // 2. Effects
        ended[_auctionId] = true;
        emit AuctionEnded(highestBidder[_auctionId], highestBid[_auctionId]);

        // 3. Interaction
        // Calculate amount for nft Platform
        uint256 nftPlatformAmount = (highestBid[_auctionId] * nftPlatformShare) / 100;
        uint256 originalOwnerShare = 0;
        if (_nft.originalOwner(tokenId[_auctionId]) != tokenOwner[_auctionId]) { // second sale or above. 
            originalOwnerShare = (highestBid[_auctionId] * _nft.royalties(tokenId[_auctionId])) / 100;
            // trnasfer original owner share
        }
        // transfer all amounts. 
        payable(_nft.owner()).transfer(nftPlatformAmount);
        if (originalOwnerShare != 0) {
            payable(_nft.originalOwner(tokenId[_auctionId])).transfer(originalOwnerShare);
        }
        beneficiary[_auctionId].transfer(highestBid[_auctionId] - originalOwnerShare - nftPlatformAmount);
        // beneficiary[_auctionId].transfer(highestBid[_auctionId]);
        
        // 4. Transfer NFT to winner
        _nft.transferFrom(tokenOwner[_auctionId], msg.sender, tokenId[_auctionId]);
    }
}