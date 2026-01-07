class PayPalConfig {
  // ✅ Sandbox credentials (lấy trong PayPal Developer Dashboard)
  static const bool sandboxMode = true;

  static const String clientId = "AWqJZFV4jB7lW1Hl01Byj2SKFYloGZMQTTjkxGZyRELAocz80f6GxgBAqNUjpo4r8DlJOcit51bqXsAZ";
  static const String secretKey = "EDF1TTJD42fPGEpdjMTsgIO_KW9wHIN0XmIrB9XFsqF0ahaJLk4uOaNkjSzsnLOnOlU1t26_HV5NSAT2";

  // return/cancel URL chỉ để webview redirect (demo thôi)
  static const String returnURL = "https://example.com/success";
  static const String cancelURL = "https://example.com/cancel";

  static const String currency = "USD";
}
