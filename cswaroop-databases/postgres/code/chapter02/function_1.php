<html>
<?php
	$db = pg_connect(“host port user password dbname schema”);
	$sql = “SELECT * FROM customer WHERE id = 23”;
	$row = pg_fetch_array($db,$sql);
	if ($row['account_balance'] > 6000) {
	$sql = “UPDATE customer SET valued_customer = true;”;
 	pg_query($db,$sql);
	}
	pg_close($db);
?>
</html>
