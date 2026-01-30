<?php

header('Content-Type: text/plain');

echo "=== HestiaCP Simple Connection Diagnostic ===\n\n";

// 1. Basic environment info
$server_ip = $_SERVER['SERVER_ADDR'] ?? gethostbyname(gethostname());
echo "Server Name: " . ($_SERVER['SERVER_NAME'] ?? 'Unknown') . "\n";
echo "Server IP: " . $server_ip . "\n";
echo "Client IP: " . ($_SERVER['REMOTE_ADDR'] ?? 'Unknown') . "\n";
echo "PHP Version: " . PHP_VERSION . "\n";
echo "Server Software: " . ($_SERVER['SERVER_SOFTWARE'] ?? 'Unknown') . "\n\n";

echo "\n=== System Info ===\n";
echo "Operating System: " . php_uname() . "\n"; // Show OS details
echo "Hostname: " . gethostname() . "\n"; // Show Hostname
echo "Current User: " . get_current_user() . "/n"; // Show which user PHP is running as
$uptime = @shell_exec('uptime');
echo "Uptime: " . ($uptime ? trim($uptime) : "Unavailable") . "\n";

$dns_test = 'google.com';
$dns_ip = gethostbyname($dns_test);
echo "DNS Test ($dns_test): $dns_ip\n\n";

$ports = [80, 443, 8080, 8443, 8083, 9000];
foreach ($ports as $port) {
    $start = microtime(true);
    $conn = @fsockopen($server_ip, $port, $errno, $errstr, 1.5);
    $elapsed = round((microtime(true) - $start) * 1000, 1);
    if ($conn) {
        echo "[OK]  Connected to {$server_ip}:{$port} in {$elapsed} ms\n";
        fclose($conn);
    } else {
        echo "[FAIL] {$server_ip}:{$port} → {$errstr} ({$errno})\n";
    }
}

echo "=== Extra Port Checks ===\n";
$extra_ports = [
	21 => 'FTP',
	22 => 'SSH',
	25 => 'SMTP',
	53 => 'DNS',
	110 => 'POP3',
	143 => 'IMAP',
	3306 => 'MySQL'
];

foreach ($extra_ports as $port => $label) {
	$conn = @fsockopen($server_ip, $port, $errno, $errstr, 1.5);
	if ($conn) {
		echo "[OK] $label port $port reachable\n";
		fclose($conn);
	} else {
		echo "[FAIL] $label port $port -> $errstr ($errno)\n";
	}
}

echo "\n";

$testUrl = 'https://www.google.com';
echo "Testing outbound HTTPS request to $testUrl ...\n";
$context = stream_context_create(['http' => ['timeout' => 3]]);
$result = @file_get_contents($testUrl, false, $context);
if ($result === false) {
    echo "[FAIL] Could not reach $testUrl\n";
} else {
    echo "[OK] Successfully reached $testUrl (" . strlen($result) . " bytes)\n";
}

echo "\n=== End of Test ===\n";
?>