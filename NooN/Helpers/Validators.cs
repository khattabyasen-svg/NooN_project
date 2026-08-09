using System.Text.RegularExpressions;

namespace NooN
{
    /// <summary>
    /// Shared input-validation rules so client and server (and multiple pages)
    /// stay consistent. Jordan region: phone must be 07XXXXXXXX.
    /// </summary>
    public static class Validators
    {
        public const int MinPasswordLength = 8;

        private static readonly Regex EmailRegex =
            new Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$", RegexOptions.Compiled);
        private static readonly Regex JordanPhoneRegex =
            new Regex(@"^07\d{8}$", RegexOptions.Compiled);

        public static bool IsValidEmail(string email) =>
            !string.IsNullOrWhiteSpace(email) && EmailRegex.IsMatch(email);

        public static bool IsValidJordanPhone(string phone) =>
            !string.IsNullOrWhiteSpace(phone) && JordanPhoneRegex.IsMatch(phone);

        public static bool IsValidPassword(string password) =>
            !string.IsNullOrEmpty(password) && password.Length >= MinPasswordLength;
    }
}
