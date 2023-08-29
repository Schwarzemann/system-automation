use Net::SMTP;
use IO::Socket::SSL;
use IO::Socket::SSL::Constants;

print "SMTP Host: ";
my $smtp_host = <STDIN>;
chomp $smtp_host;

print "SMTP Port: ";
my $smtp_port = <STDIN>;
chomp $smtp_port;

print "Username: ";
my $username = <STDIN>;
chomp $username;

print "Password: ";
my $password = <STDIN>;
chomp $password;

print "Security Method (ssl/tls/none): ";
my $security_method = lc(<STDIN>);
chomp $security_method;

print "To Email: ";
my $to_email = <STDIN>;
chomp $to_email;

my $smtp;
if ($security_method eq 'ssl') {
    $smtp = Net::SMTP->new(
        $smtp_host,
        Port    => $smtp_port,
        SSL     => 1,
    );
} elsif ($security_method eq 'tls') {
    $smtp = Net::SMTP->new(
        $smtp_host,
        Port    => $smtp_port,
        SSL     => 0,
        StartTLS => 1,
        SSL_ca_file => Mozilla::CA::SSL_ca_file(),
    );
} else {
    $smtp = Net::SMTP->new(
        $smtp_host,
        Port    => $smtp_port,
        SSL     => 0,
    );
}

$smtp->auth($username, $password) or die "Authentication failed: $!";

$smtp->mail($username);
$smtp->to($to_email);

$smtp->data();
$smtp->datasend("From: $username\n");
$smtp->datasend("To: $to_email\n");
$smtp->datasend("Subject: Test Email\n");
$smtp->datasend("\n");
$smtp->datasend("This is a test email sent via SMTP in Perl.\n");
$smtp->dataend();

$smtp->quit;
print "Test email sent successfully!\n";
