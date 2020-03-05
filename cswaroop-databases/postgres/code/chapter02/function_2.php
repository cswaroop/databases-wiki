<html>
<?php
	$db = pg_connect('...');
	pg_query('UPDATE customer SET valued_customer = true WHERE balance > 6000;', $db);
	pg_close($db);
?>
</html>
