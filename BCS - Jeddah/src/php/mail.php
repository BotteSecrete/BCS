<?php
   $senderName = $_POST['senderName'];
   $senderEmail =  $_POST['senderEmail'];
   $sendToEmail = $_POST['destiEmail'];
   $id = $_POST['boreholeID'];
   $locaID = $_POST['locaID'];
   $destiName = $_POST['destiName'];
   $subject = $_POST['emailSubject'];
   $projName = $_POST['projName'];
    
   $recipient = "$sendToEmail";
   $headers  = 'MIME-Version: 1.0' . "\r\n";
   $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n"; 
   $headers .= "From: SYG <syg@systra.com> ";
   //$message = "Hello $destiName, \n\n$senderName has completed a borehole at the id $id. \nDon't forget that you can use the 'Search completed borehole' widget at the bottom of the page https://sygdev.systra.info to get it. Please refer to the online help if you need some. \r\n\r\n\r\nThis message has been send automatically, please not reply. \r\nThanks you";
   
   // message
   $message = '
       <html>
	  	 <head>
      		 <title>Automatic mail from SYG</title>
 	     </head>
    	 <body>
      		 <p>Hello ' .$destiName.',</p>
      		 <br />
	   		 <p>SYG\'s user <b>'.$senderName.' </b> completed the borehole id <b>'.$id.'</b> which LOCA_ID (name) is <b>'.$locaID.'</b> on project <b>'.$projName.'</b></p>
      		 <p>Please access to the website <a href="https://sygdev.systra.info">here</a> to check this borehole.</p>
	  
	 		 <p style="line-height:60px; vertical-align:middle"><img src="http://blog.lalettregourmande.com/wp-content/uploads/2012/06/warning-caution-icon.jpg" alt="warning" height="42" width="42" style="vertical-align:middle; margin-right:5px;"> <span style="padding-right:10px">If you can\'t see this borehole please refer it to the SYG admin.</span></p>
 	   		 <p>-- <br />
		  		This is an automatic email, please don\'t answer it
		  	 </p>
		  	 <br />
		  	 <p>
		  	 <img src="http://www.systra.com/squelettes/img/systra-logo-fr.png" alt="warning" height="40" style="vertical-align:middle; margin-right:5px;"><br /><br />
		  	 <b><span style="font-family:\'Calibri\',\'sans-serif\'; color:#585858; font-size:11px">72-76 rue Henry Farman, 75513 PARIS CEDEX 15, France<br />
		  	 <a style="font-family:\'Calibri\',\'sans-serif\'; color:#585858; font-size:11px; text-decoration:none" href="http://www.systra.com">http://www.systra.com</a></span>
		  	 </p> 
	   	 </body>
      </html>
     ';
     
   echo $projName;  
   mail($recipient, $subject, $message, $headers)
?>