<!DOCTYPE html>
<html>
<head>
	<title>PayPal API test page</title>
</head>
<body>
 Test PayPal API response
</body>
</html>

<script type="text/javascript">

	document.onload = ajaxRequest();

	function ajaxRequest() {
		console.log("In ajaxRequest");

		// setup a dummy ajax call
		var xmlHttpObj;
		var productID 
		productID = '123456';
		
		if (productID.length != 0)
		{
			console.log("productID length = " + productID.length);
			var url = "https://api.sandbox.paypal.com/v1/payments/payment/PAY-38M956064Y725522GLHKPOGQ";

			if (!xmlHttpObj)
				xmlHttpObj = new XMLHttpRequest();
			xmlHttpObj.open('GET', url, true);
			xmlHttpObj.setRequestHeader("Content-Type", "application/json");
			xmlHttpObj.setRequestHeader("Authorization", "Bearer ###################-#################################################--#########");
			xmlHttpObj.onreadystatechange = ajaxDone();
			xmlHttpObj.send(url);
		}
		else
			productID = 0;
	}

	function ajaxDone() {
		console.log("Ajax call done.");
	}
</script>
