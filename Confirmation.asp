<%
	Option Explicit
%>

<!-- #Include virtual = "/Main/Include/CommonFunc.asp" -->
<!-- #Include virtual = "/Main/Include/ECommerce/RequestedVariable.asp" -->
<%
    ToHTTPS	

	Dim blnPayPal			' if this is a PayPal checkout 

	' For PayPal checkout we want to test the query string to see if the customer selected PayPal checkout
	If InStr(Request.Querystring, "PayPalCheckout.x") then
		If (XSSFilter(Request.Querystring("PayPalCheckout.x")) ) > 0 then
			strShipMethod = "1"		' set strShipMethod to 1 as we're not accepting any other type for PayPal
			blnPayPal = true   		' will control page layout to modify elements for the PayPal checkout
		End if
	End if

	
%>
<!-- Paypal checkout JH 10-10-17 -->
<table cellSpacing="0" cellPadding="0" width="20%" align="right" border="0" style="display: inline-table; border-color: red;" ID="Table5">
	<tr>
		<td>
			<% 
			Dim dblGrandTotalForPayPal		     ' To strip the $ sign out of dblGrandTotal for PayPal
			dblGrandTotalForPayPal = Replace(dblGrandTotal, "$", "") 
			%>

    	    <div id="paypal-button"></div>

    	    <script src="https://www.paypalobjects.com/api/checkout.js"></script>

    	    <div id="paypal-button-container" style="float:right;margin-bottom: 20px"></div> 

        	    <script>
        	        paypal.Button.render({

        	            env: 'sandbox', // sandbox | production

        	            client: {
        	                sandbox:    '############################################-#####################',
        	                production: '<insert production client id here>'
        	            },

        	            // Specify the style of the button
        	            style: {
        	                label: 'pay',
        	                size:  'medium', 	// small | medium | large | responsive
        	                shape: 'rect',   	// pill | rect
        	                color: 'gold'   	// gold | blue | silver | black
        	            },

        	            commit: true,  			// If offering a chance to review the order on our site; make this false since we don't offer this option

        	            payment: function(data, actions) {
        	                return actions.payment.create({
        	                    payment: {
        	                    
        	                        transactions: [
        	                            {
        	                                amount: { total: "<%=dblGrandTotalForPayPal%>", currency: "USD" }
        	                            }
        	                        ]
        	                        ,

        	                        redirect_urls: {
	                                  //"return_url": "/ECommerce/Order/Checkout.asp",
	                                  "cancel_url": "https://<%=strServerName%>/ECommerce/ShoppingCart/Cart.asp"       // If the paypal transactions fails
	                                }
        	                    }
        	                });
        	            },

        	            // Wait for the payment to be authorized by the customer
        	            onAuthorize: function(data, actions) {
        	                // Get the payment details
        	                return actions.payment.get().then(function(data) {

        	                    // Get the customer's info from the data.payer object
        	                    var shipping = data.payer.payer_info.shipping_address;

        	                    if (shipping.line2 == null) {  			         // For empty line 2 fields so we don't get nulls below
        	                    	shipping.line2 = "";
        	                    }

        	                    if (shipping.country_code === "US") {	         // Convert Paypal supplied contry code to match what our site expects
        	                    	shipping.country_code = "USA";
        	                	}
        	                    
        	                    // Load up the form variables
        	                    document.ConfirmForm.ShipFName.value = data.payer.payer_info.first_name.toUpperCase();
        	                    document.ConfirmForm.ShipLName.value = data.payer.payer_info.last_name.toUpperCase();
        	                    document.ConfirmForm.ShipAddress1.value = shipping.line1.toUpperCase();
        	                    document.ConfirmForm.ShipAddress2.value = shipping.line2.toUpperCase();
        	                    document.ConfirmForm.ShipCity.value = shipping.city.toUpperCase();
        	                    document.ConfirmForm.ShipState.value = shipping.state.toUpperCase();
        	                    document.ConfirmForm.ShipZip.value = shipping.postal_code;
        	                    document.ConfirmForm.ShipCountry.value = shipping.country_code;
        	                    document.ConfirmForm.BillEmailAddress.value = data.payer.payer_info.email.toUpperCase();
        	                    document.ConfirmForm.ShipDayPhone.value = data.payer.payer_info.phone;
        	                    document.ConfirmForm.CardType.value = "PAYPAL";
        	                    document.ConfirmForm.CardID.value = "";
        	                    document.ConfirmForm.CardNumber.value = data.id;											// PayPal transaction ID
        	                    document.ConfirmForm.CardExpMonth.value = "";
        	                    document.ConfirmForm.CardExpYear.value = "";
        	                    document.ConfirmForm.PaypalInfo.value = data.id + "\\" + data.payer.payer_info.payer_id;	// PayPal transaction ID and Paypal customerID concatenated to save in db
        	                   	
    	                        // Execute the payment
    	                        return actions.payment.execute().then(function() {
    	                            document.ConfirmForm.submit(); 		
    	                        });
    	                        //return actions.redirect();
        	                });
        	            }
        	        }, '#paypal-button-container');
        	    </script>
		</td>
	</tr>
	<input type="hidden" name="PaypalInfo" value="">
</table>
