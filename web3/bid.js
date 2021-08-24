
function bid(_auctionId)
{
	if(!web3.isConnected()) {
		console.log("Please connect to Metamask.");
	 
	return;
	 
	}

	// check network
	var networkID = web3.version.network;	// change this in the future
	var networkName = "Ropsten Test Network";	// change this in the future

	if(networkID !== "3")
	{
		console.log("Please Switch to the " + networkName);
		
		return;
	}

    auction.bid.estimateGas(_auctionId, function(error, result) {
        if (!error) {
            auction.bid(_auctionId, function(error, result)
			{
				if (!error)
				{
					// Transaction submitted Successfully
					console.log("Success: " + result);
					
					return;
					// can open https://ropsten.etherscan.io/tx/<result> in a new tab
				}
				else
				{
					if (error.message.indexOf("User denied") != -1)
					{
						console.log("You rejected the transaction on Metamask!");
						
						
						return;
					}
					else
					{
						// some unkonwn error
						console.log("Unkown error: " + error);
						return;
					}
				}
			});
        } else {
            // transaction will fail! So dont execute
			console.log("This function cannot be run at this time.");
			
			return;
        }
    });
		

	return;
}
