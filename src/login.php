<?php
//Ming-Xia Delvas 20104038 et  Calin Popa 20158726 
	$host="localhost"; 
	$username="root"; 
	$password=""; 
	$db_name="admin"; 
	$tbl_name="members"; 
	mysql_connect("$host", "$username", "$password")or die("cannot connect"); 
	mysql_select_db("$db_name")or die("cannot select DB");

	$username=$_POST['username']; 
	$password=$_POST['password']; 

	$username = stripslashes($username);
	$password = stripslashes($password);
	$username = mysql_real_escape_string($username);
	$password = mysql_real_escape_string($password);
	$sql="SELECT * FROM $tbl_name WHERE username='$username' and
	password='$password'";
	$result=mysql_query($sql);

	$count=mysql_num_rows($result);

	if($count==1){
		session_register("username");
		session_register("password");
	} else {
		echo "
		<p>Wrong Username or Password</p>
		<form action=\"check_login.php\" method=\"post\">
			<table class=\"login_table\">
			<tr>
				<td>Username:</td>
				<td><input type=\"text\" name=\"username\" id=\"username\"></td>
			</tr>
			<tr>
				<td>Password:</td>
				<td><input type=\"text\" name=\"password\" id=\"password\"></td>
			</tr>
			<tr>
				<td><input type=\"submit\" value=\"Login\"></td>
			</tr>
			</table>
		</form>";
	}
?>

<?php
	error_reporting(0);
	session_start();
	if(!session_is_registered(username)){
		header("location:login.html");
	}
?>

<?php 
	session_start();
	session_destroy();
?>

<?php
	error_reporting(0);
	session_start();
	if(!session_is_registered(username)){
		header("location:index.php");
	}
?>
