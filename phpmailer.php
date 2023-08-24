<!DOCTYPE html>
<html>
<head>
    <title>SMTP Email Sender</title>
</head>
<body>
    <h2>SMTP Email Sender</h2>
    <form method="post">
        <label for="smtp_host">SMTP Host:</label>
        <input type="text" id="smtp_host" name="smtp_host" required><br><br>

        <label for="smtp_port">SMTP Port:</label>
        <input type="number" id="smtp_port" name="smtp_port" required><br><br>

        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br><br>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>

        <label for="to_email">To Email:</label>
        <input type="email" id="to_email" name="to_email" required><br><br>

        <input type="submit" name="send_email" value="Send Test Email">
    </form>

    <?php
    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\Exception;
    
    if (isset($_POST['send_email'])) {
        $smtp_host = $_POST['smtp_host'];
        $smtp_port = $_POST['smtp_port'];
        $username = $_POST['username'];
        $password = $_POST['password'];
        $to_email = $_POST['to_email'];

        require 'PHPMailer/src/Exception.php';
        require 'PHPMailer/src/PHPMailer.php';
        require 'PHPMailer/src/SMTP.php';


        $mail = new PHPMailer;
        $mail->isSMTP();
        $mail->Host = $smtp_host;
        $mail->Port = $smtp_port;
        $mail->SMTPAuth = true;
        $mail->Username = $username;
        $mail->Password = $password;
        $mail->SMTPSecure = 'tls';

        $mail->From = $username;
        $mail->FromName = 'SMTP Test';
        $mail->addAddress($to_email);

        $mail->Subject = 'SMTP Test Email';
        $mail->Body = 'This is a test email sent via SMTP.';
        
        if ($mail->send()) {
            echo '<p style="color: green;">Test email sent successfully!</p>';
        } else {
            echo '<p style="color: red;">Error sending email: ' . $mail->ErrorInfo . '</p>';
        }
    }
    ?>
</body>
</html>
