var nftcontract = web3.eth.contract(
	[
		{
		  "inputs": [],
		  "stateMutability": "nonpayable",
		  "type": "constructor"
		},
		{
		  "anonymous": false,
		  "inputs": [
			{
			  "indexed": true,
			  "internalType": "address",
			  "name": "_owner",
			  "type": "address"
			},
			{
			  "indexed": true,
			  "internalType": "address",
			  "name": "_approved",
			  "type": "address"
			},
			{
			  "indexed": true,
			  "internalType": "uint256",
			  "name": "_tokenId",
			  "type": "uint256"
			}
		  ],
		  "name": "Approval",
		  "type": "event"
		},
		{
		  "anonymous": false,
		  "inputs": [
			{
			  "indexed": true,
			  "internalType": "address",
			  "name": "_owner",
			  "type": "address"
			},
			{
			  "indexed": true,
			  "internalType": "address",
			  "name": "_operator",
			  "type": "address"
			},
			{
			  "indexed": false,
			  "internalType": "bool",
			  "name": "_approved",
			  "type": "bool"
			}
		  ],
		  "name": "ApprovalForAll",
		  "type": "event"
		},
		{
		  "anonymous": false,
		  "inputs": [
			{
			  "indexed": true,
			  "internalType": "address",
			  "name": "previousOwner",
			  "type": "address"
			},
			{
			  "indexed": true,
			  "internalType": "address",
			  "name": "newOwner",
			  "type": "address"
			}
		  ],
		  "name": "OwnershipTransferred",
		  "type": "event"
		},
		{
		  "anonymous": false,
		  "inputs": [
			{
			  "indexed": true,
			  "internalType": "address",
			  "name": "_from",
			  "type": "address"
			},
			{
			  "indexed": true,
			  "internalType": "address",
			  "name": "_to",
			  "type": "address"
			},
			{
			  "indexed": true,
			  "internalType": "uint256",
			  "name": "_tokenId",
			  "type": "uint256"
			}
		  ],
		  "name": "Transfer",
		  "type": "event"
		},
		{
		  "inputs": [],
		  "name": "CANNOT_TRANSFER_TO_ZERO_ADDRESS",
		  "outputs": [
			{
			  "internalType": "string",
			  "name": "",
			  "type": "string"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [],
		  "name": "NOT_CURRENT_OWNER",
		  "outputs": [
			{
			  "internalType": "string",
			  "name": "",
			  "type": "string"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "address",
			  "name": "_approved",
			  "type": "address"
			},
			{
			  "internalType": "uint256",
			  "name": "_tokenId",
			  "type": "uint256"
			}
		  ],
		  "name": "approve",
		  "outputs": [],
		  "stateMutability": "nonpayable",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "address",
			  "name": "_owner",
			  "type": "address"
			}
		  ],
		  "name": "balanceOf",
		  "outputs": [
			{
			  "internalType": "uint256",
			  "name": "",
			  "type": "uint256"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "",
			  "type": "uint256"
			}
		  ],
		  "name": "blockedTokenId",
		  "outputs": [
			{
			  "internalType": "bool",
			  "name": "",
			  "type": "bool"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "_tokenId",
			  "type": "uint256"
			}
		  ],
		  "name": "disableToken",
		  "outputs": [],
		  "stateMutability": "nonpayable",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "_tokenId",
			  "type": "uint256"
			}
		  ],
		  "name": "getApproved",
		  "outputs": [
			{
			  "internalType": "address",
			  "name": "",
			  "type": "address"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "address",
			  "name": "_owner",
			  "type": "address"
			},
			{
			  "internalType": "address",
			  "name": "_operator",
			  "type": "address"
			}
		  ],
		  "name": "isApprovedForAll",
		  "outputs": [
			{
			  "internalType": "bool",
			  "name": "",
			  "type": "bool"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "address",
			  "name": "_to",
			  "type": "address"
			},
			{
			  "internalType": "string",
			  "name": "_uri",
			  "type": "string"
			}
		  ],
		  "name": "mint",
		  "outputs": [
			{
			  "internalType": "uint256",
			  "name": "",
			  "type": "uint256"
			}
		  ],
		  "stateMutability": "nonpayable",
		  "type": "function"
		},
		{
		  "inputs": [],
		  "name": "name",
		  "outputs": [
			{
			  "internalType": "string",
			  "name": "_name",
			  "type": "string"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "",
			  "type": "uint256"
			}
		  ],
		  "name": "originalOwner",
		  "outputs": [
			{
			  "internalType": "address",
			  "name": "",
			  "type": "address"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [],
		  "name": "owner",
		  "outputs": [
			{
			  "internalType": "address",
			  "name": "",
			  "type": "address"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "_tokenId",
			  "type": "uint256"
			}
		  ],
		  "name": "ownerOf",
		  "outputs": [
			{
			  "internalType": "address",
			  "name": "_owner",
			  "type": "address"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [],
		  "name": "royalty",
		  "outputs": [
			{
			  "internalType": "uint256",
			  "name": "",
			  "type": "uint256"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "address",
			  "name": "_from",
			  "type": "address"
			},
			{
			  "internalType": "address",
			  "name": "_to",
			  "type": "address"
			},
			{
			  "internalType": "uint256",
			  "name": "_tokenId",
			  "type": "uint256"
			}
		  ],
		  "name": "safeTransferFrom",
		  "outputs": [],
		  "stateMutability": "nonpayable",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "address",
			  "name": "_from",
			  "type": "address"
			},
			{
			  "internalType": "address",
			  "name": "_to",
			  "type": "address"
			},
			{
			  "internalType": "uint256",
			  "name": "_tokenId",
			  "type": "uint256"
			},
			{
			  "internalType": "bytes",
			  "name": "_data",
			  "type": "bytes"
			}
		  ],
		  "name": "safeTransferFrom",
		  "outputs": [],
		  "stateMutability": "nonpayable",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "address",
			  "name": "_operator",
			  "type": "address"
			},
			{
			  "internalType": "bool",
			  "name": "_approved",
			  "type": "bool"
			}
		  ],
		  "name": "setApprovalForAll",
		  "outputs": [],
		  "stateMutability": "nonpayable",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "bytes4",
			  "name": "_interfaceID",
			  "type": "bytes4"
			}
		  ],
		  "name": "supportsInterface",
		  "outputs": [
			{
			  "internalType": "bool",
			  "name": "",
			  "type": "bool"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [],
		  "name": "symbol",
		  "outputs": [
			{
			  "internalType": "string",
			  "name": "_symbol",
			  "type": "string"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "_tokenId",
			  "type": "uint256"
			}
		  ],
		  "name": "tokenURI",
		  "outputs": [
			{
			  "internalType": "string",
			  "name": "",
			  "type": "string"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "address",
			  "name": "_from",
			  "type": "address"
			},
			{
			  "internalType": "address",
			  "name": "_to",
			  "type": "address"
			},
			{
			  "internalType": "uint256",
			  "name": "_tokenId",
			  "type": "uint256"
			}
		  ],
		  "name": "transferFrom",
		  "outputs": [],
		  "stateMutability": "nonpayable",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "address",
			  "name": "_newOwner",
			  "type": "address"
			}
		  ],
		  "name": "transferOwnership",
		  "outputs": [],
		  "stateMutability": "nonpayable",
		  "type": "function"
		}
	  ]
);

var simpleAuctionABI = web3.eth.contract(
	[
		{
		  "inputs": [
			{
			  "internalType": "address",
			  "name": "_addressOfNFT",
			  "type": "address"
			}
		  ],
		  "stateMutability": "nonpayable",
		  "type": "constructor"
		},
		{
		  "anonymous": false,
		  "inputs": [
			{
			  "indexed": false,
			  "internalType": "address",
			  "name": "winner",
			  "type": "address"
			},
			{
			  "indexed": false,
			  "internalType": "uint256",
			  "name": "amount",
			  "type": "uint256"
			}
		  ],
		  "name": "AuctionEnded",
		  "type": "event"
		},
		{
		  "anonymous": false,
		  "inputs": [
			{
			  "indexed": false,
			  "internalType": "address",
			  "name": "bidder",
			  "type": "address"
			},
			{
			  "indexed": false,
			  "internalType": "uint256",
			  "name": "amount",
			  "type": "uint256"
			}
		  ],
		  "name": "HighestBidIncreased",
		  "type": "event"
		},
		{
		  "anonymous": false,
		  "inputs": [
			{
			  "indexed": true,
			  "internalType": "address",
			  "name": "previousOwner",
			  "type": "address"
			},
			{
			  "indexed": true,
			  "internalType": "address",
			  "name": "newOwner",
			  "type": "address"
			}
		  ],
		  "name": "OwnershipTransferred",
		  "type": "event"
		},
		{
		  "inputs": [],
		  "name": "CANNOT_TRANSFER_TO_ZERO_ADDRESS",
		  "outputs": [
			{
			  "internalType": "string",
			  "name": "",
			  "type": "string"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [],
		  "name": "NOT_CURRENT_OWNER",
		  "outputs": [
			{
			  "internalType": "string",
			  "name": "",
			  "type": "string"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "_auctionId",
			  "type": "uint256"
			}
		  ],
		  "name": "auctionEnd",
		  "outputs": [],
		  "stateMutability": "nonpayable",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "",
			  "type": "uint256"
			}
		  ],
		  "name": "auctionEndTime",
		  "outputs": [
			{
			  "internalType": "uint256",
			  "name": "",
			  "type": "uint256"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "_auctionId",
			  "type": "uint256"
			}
		  ],
		  "name": "bid",
		  "outputs": [],
		  "stateMutability": "payable",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "_auctionId",
			  "type": "uint256"
			}
		  ],
		  "name": "disableClaim",
		  "outputs": [],
		  "stateMutability": "nonpayable",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "_auctionId",
			  "type": "uint256"
			}
		  ],
		  "name": "getInitialBidAmount",
		  "outputs": [
			{
			  "internalType": "uint256",
			  "name": "",
			  "type": "uint256"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "",
			  "type": "uint256"
			}
		  ],
		  "name": "highestBid",
		  "outputs": [
			{
			  "internalType": "uint256",
			  "name": "",
			  "type": "uint256"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "",
			  "type": "uint256"
			}
		  ],
		  "name": "highestBidder",
		  "outputs": [
			{
			  "internalType": "address",
			  "name": "",
			  "type": "address"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [],
		  "name": "owner",
		  "outputs": [
			{
			  "internalType": "address",
			  "name": "",
			  "type": "address"
			}
		  ],
		  "stateMutability": "view",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "_auctionId",
			  "type": "uint256"
			},
			{
			  "internalType": "uint256",
			  "name": "_tokenId",
			  "type": "uint256"
			},
			{
			  "internalType": "uint256",
			  "name": "_initialBidAmount",
			  "type": "uint256"
			},
			{
			  "internalType": "address payable",
			  "name": "_beneficiary",
			  "type": "address"
			}
		  ],
		  "name": "startAuction",
		  "outputs": [],
		  "stateMutability": "nonpayable",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "address",
			  "name": "_newOwner",
			  "type": "address"
			}
		  ],
		  "name": "transferOwnership",
		  "outputs": [],
		  "stateMutability": "nonpayable",
		  "type": "function"
		},
		{
		  "inputs": [
			{
			  "internalType": "uint256",
			  "name": "_auctionId",
			  "type": "uint256"
			}
		  ],
		  "name": "withdraw",
		  "outputs": [
			{
			  "internalType": "bool",
			  "name": "",
			  "type": "bool"
			}
		  ],
		  "stateMutability": "nonpayable",
		  "type": "function"
		}
	  ]
);

var contractAddress = "0x40cAf67018B5F28489Cbd44819C6A5Afb81B0030"; // Change this to ropsten test address
var NFT = nftcontract.at(contractAddress);

var simpleAuctionAddress = "0x34120A3fb8a24c30A82b3037d47f00903aD4d0D0";
var auction = simpleAuctionABI.at(simpleAuctionAddress);


// const onClickConnect = async () => {
//     try {
//       const newAccounts = await ethereum.request({
//         method: 'eth_requestAccounts',
//       });
//       handleNewAccounts(newAccounts);
//     } catch (error) {
//       console.error(error);
//     }
//   };

// onClickConnect();