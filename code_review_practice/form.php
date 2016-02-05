<?php # Script - Group Project - form.php
//Insert description here
// Random PHP page for code review
$page_title = 'Book Order Form';
include ('header.html');

/**Function that makes shipping option radio buttons **/
function create_shipping_radio($value) {

	echo '<input type="radio" name="shipping_option" value="' . $value . '"';
	
	if(isset($_post['gallon_price']) && ($_POST['gallon_price'] == $value)){
		echo ' checked="checked"';
	}
	
	echo " /> $value ";
	
}

// Check for form submission:
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

	// Minimal form validation:
	if (isset($_POST['quantity1'], $_POST['quantity1'], $_POST['quantity2'], $_POST['quantity3'], $_POST['quantity4'], $_POST['quantity5'], $_POST['quantity6'], $_POST['quantity7'], $_POST['quantity8'], $_POST['name'], $_POST['address'], $_POST['creditcard'], $_POST['shipping']) && is_numeric($_POST['quantity1']) && is_numeric($_POST['quantity2']) && is_numeric($_POST['quantity3']) && is_numeric($_POST['quantity4']) && is_numeric($_POST['quantity5']) && is_numeric($_POST['quantity6']) && is_numeric($_POST['quantity7']) && is_numeric($_POST['quantity8']) && is_string($_POST['name']) && is_string($_POST['address'])  && is_string($_POST['city']) && is_string($_POST['state']) && is_numeric($_POST['zip']) && is_numeric($_POST['creditcard']) && is_string($_POST['shipping']) ) {

			// Calculate total order
			$global['totalcost'] = ($_POST['quantity1'] * $_POST['price1']) + ($_POST['quantity2'] * $_POST['price2']) + ($_POST['quantity3'] * $_POST['price3']) + ($_POST['quantity4'] * $_POST['price4']) + ($_POST['quantity5'] * $_POST['price5']) + ($_POST['quantity6'] * $_POST['price6']) + ($_POST['quantity7'] * $_POST['price7']) + ($_POST['quantity8'] * $_POST['price8']);
		
			// Calculate tax
		if ($_POST['state'] == 'MI') {
			$global['taxrate'] = '.06';
		} else {
			$global['taxrate'] = '0'; 
		}

		$global['tax'] = $global['totalcost'] * $global['taxrate'];

			// Set shipping rate
		if ($_POST['shipping'] == '1-day') {
			$global['shippingrate'] = '19.95';
		}
		elseif ($_POST['shipping'] == '2-day') {
			$global['shippingrate'] = '12.95';
		}	
		else $global['shippingrate'] = '5.95';
		}

			// Calculate total cost
		$grandtotal = $totalcost + $tax + $shippingrate;

		// Print the Order:
		echo '<h1>Order Submitted</h1>';

	}   // End of main submission IF.

// Leave the PHP section and create the HTML form:
?>

	<div id="content">
		<h1>New York Times Best Sellers</h1>
		
		<form action="form.php" method="post"> 
		<fieldset>
		<!-- Insert pictures and item names in this section -->
			<p>Gone Girl, Gillian Flynn</p>
				<p>Quantity: <input type="text" name="quantity1" value="<?php if (isset($_POST['quantity1'])) echo $_POST['quantity1']; ?>" /></p>
			
			<p>Burn, James Patterson</p>
				<p>Quantity: <input type="text" name="quantity2" value="<?php if (isset($_POST['quantity2'])) echo $_POST['quantity2']; ?>" /></p>
			
			<p>The Lost Key, Catherine Coulter</p>
				<p>Quantity: <input type="text" name="quantity3" value="<?php if (isset($_POST['quantity3'])) echo $_POST['quantity3']; ?>" /></p>		
			
			<p>The Best of Me, Nicholas Sparks</p>
				<p>Quantity: <input type="text" name="quantity4" value="<?php if (isset($_POST['quantity4'])) echo $_POST['quantity4']; ?>" /></p>
			
			<p>Edge of Eternity, Ken Follett</p>
				<p>Quantity: <input type="text" name="quantity5" value="<?php if (isset($_POST['quantity5'])) echo $_POST['quantity5']; ?>" /></p>
			
			<p>Outlander, Diana Gabaldon</p>
				<p>Quantity: <input type="text" name="quantity1" value="<?php if (isset($_POST['quantity6'])) echo $_POST['quantity6']; ?>" /></p>
			
			<p>Stepbrother Dearest, Penelope Ward</p>
				<p>Quantity: <input type="text" name="quantity7" value="<?php if (isset($_POST['quantity7'])) echo $_POST['quantity7']; ?>" /></p>

			<p>Personal, Lee Child</p>
				<p>Quantity: <input type="text" name="quantity8" value="<?php if (isset($_POST['quantity8'])) echo $_POST['quantity8']; ?>" /></p>
			
			<p>Name: <input type="text" name="name" value="<?php if (isset($_POST['name'])) echo $_POST['name']; ?>"/></p>
	<p></p>
			<p>Address: <input type="text" name="address" value="<?php if (isset($_POST['address'])) echo $_POST['address']; ?>"/></p>
	<p></p>
			<p>City: <input type="text" name="city" value="<?php if (isset($_POST['city'])) echo $_POST['city']; ?>"/></p>
	<p></p>
			<p>State: <input type="text" name="state" value="<?php if (isset($_POST['state'])) echo $_POST['state']; ?>"/></p>
	<p></p>
			<p>Zip Code: <input type="text" name="zip" value="<?php if (isset($_POST['zip'])) echo $_POST['zip']; ?>"/></p>
	<p></p>
			<p>Credit Card: <input type="text" name="credit_card" value="<?php if (isset($_POST['credit_card'])) echo $_POST['credit_card']; ?>"/></p>
	<p></p>
			<p>Shipping Option: <span class="input"> <?php
				create_shipping_radio('Standard $5.95');
				create_shipping_radio('2-day Shipping $12.95');
				create_shipping_radio('1-day Shipping $19.95');
				?>
	</span></p>
			<div>
			<p align="center"><input type="submit" name="submit" value="Submit" /></p>
			</div>
		</fieldset>
			</form>

<?php include ('footer.html'); ?>

