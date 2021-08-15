function getTokenCounter()
{
	if(!web3.isConnected()) {

	  
	  $.toast({
		heading: 'Error',
		text: "Please connect to Metamask.",
		position: 'top-right',
		loaderBg: '#ff6849',
		icon: 'error',
		hideAfter: 10000

	});
	return;
	 
	}

	// check network
	var networkID = web3.version.network;	// change this in the future
	var networkName = "Ropsten Test Network";	// change this in the future

	if(networkID !== "3")
	{
		
		console.log("Result: " + result);
		
		return;
	}

    
	NFT.getTokenCounter(function(error, result)
	{
		if (!error)
		{
			// Transaction submitted Successfully
			console.log("Result: " + result);
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
				console.log("Unknown Error: " + JSON.stringify(error));
				return;
			}
		}
	});
		

	return;
}
