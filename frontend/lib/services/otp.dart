import 'package:email_otp/email_otp.dart';

class OTPService {
  static void configure() {
    // Basic configuration
    EmailOTP.config(
      appName: 'PowerTrack',
      otpType: OTPType.numeric,
      emailTheme: EmailTheme.v1,
      appEmail: 'cliffco24@gmail.com',
      otpLength: 6,
    );

    // Optional SMTP configuration if you have a custom SMTP server
    EmailOTP.setSMTP(
      host: 'smtp.gmail.com',
      emailPort: EmailPort.port587,
      secureType: SecureType.tls,
      username: 'cliffco24@gmail.com',
      password: 'nzqo jtlf kuau xtus',
    );

    // Custom email template with your specified colors and branding
    EmailOTP.setTemplate(
      template: '''
      <div style="background-color: #F3F4F6; padding: 20px; font-family: Arial, sans-serif;">
        <div style="max-width: 600px; margin: auto; background-color: #ffffff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">
          <div style="text-align: center; margin-bottom: 20px;">
            <img src="https://example.com/path/to/powertrack-logo.png" alt="PowerTrack Logo" style="height: 50px;">
          </div>
          <h1 style="color: #4A90E2; text-align: center;">PowerTrack</h1>
          <p style="color: #333333; text-align: center;">Your OTP is <strong style="font-size: 24px;">{{otp}}</strong></p>
          <p style="color: #333333; text-align: center;">This OTP is valid for 5 minutes.</p>
          <p style="color: #333333; text-align: center;">If you did not request this, please ignore this email.</p>
          <p style="color: #333333; text-align: center;">Thank you for using PowerTrack.</p>
          <div style="text-align: center; margin-top: 20px;">
            <a href="https://powertrack.com" style="color: #4A90E2; text-decoration: none;">Visit our website</a>
          </div>
        </div>
      </div>
      ''',
    );
  }

  static void sendOTP(String email) {
    EmailOTP.sendOTP(email: email);
  }

  static bool verifyOTP(String otp) {
    return EmailOTP.verifyOTP(otp: otp);
  }
}
