<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="reset.css">
    <link rel="stylesheet" href="style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=VT323&display=swap&family=Poetsen+One&display=swap" rel="stylesheet">
    <title>Emli-7 Wildlife Camera</title>
</head>
<body>
	<div class="container">
    		<h1 id="title">Emli-7 Wildlife Camera</h1>
    		<a href="/pictures/" id="pictures-logo">
			<img src="images/Logo.png" alt="Button to pictures">
		</a>
		<div id="log">
			<h3 class="pixel-font">Log</h3>
			<?php
			$logFilePath = "logs/camera-log.txt";
			$logOutput = shell_exec("tail -n 100 $logFilePath");
        		$logMessages = explode("\n", $logOutput);

			foreach ($logMessages as $message) {
			    $datetime = shell_exec("echo '$message' | grep -oE '[0-9]+-[0-9]+-[0-9]+ [0-9]+:[0-9]+:[0-9]+\.[0-9]+ [a-zA-Z]+'");
			    $messageWithoutDatetime = shell_exec("echo '$message' | sed 's/[0-9]\+-[0-9]\+-[0-9]\+ [0-9]\+:[0-9]\+:[0-9]\+\.[0-9]\+ [a-zA-Z]\+//'");
			    echo "<p class='pixel-font'><span class='datetime'>$datetime</span> $messageWithoutDatetime</p>";
			}
			?>
		</div>
	</div>
</body>
</html>
