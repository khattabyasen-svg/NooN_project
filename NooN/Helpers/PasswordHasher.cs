using System;
using System.Security.Cryptography;
using System.Text;

namespace NooN
{
    /// <summary>
    /// PBKDF2 (SHA-256) password hashing with a per-password random salt.
    /// Stored format: "PBKDF2$&lt;iterations&gt;$&lt;saltBase64&gt;$&lt;hashBase64&gt;".
    ///
    /// A legacy plaintext fallback is included so accounts created before hashing
    /// keep working; those should be upgraded via <see cref="NeedsUpgrade"/> on the
    /// next successful login.
    /// </summary>
    public static class PasswordHasher
    {
        private const string Prefix = "PBKDF2";
        private const char Delimiter = '$';
        private const int SaltSize = 16;       // 128-bit salt
        private const int KeySize = 32;        // 256-bit derived key
        private const int Iterations = 100000;

        /// <summary>Hashes a plaintext password into the stored format.</summary>
        public static string Hash(string password)
        {
            if (password == null) throw new ArgumentNullException(nameof(password));

            byte[] salt = new byte[SaltSize];
            using (var rng = RandomNumberGenerator.Create())
                rng.GetBytes(salt);

            byte[] key = Pbkdf2(password, salt, Iterations);

            return string.Join(
                Delimiter.ToString(),
                Prefix,
                Iterations.ToString(),
                Convert.ToBase64String(salt),
                Convert.ToBase64String(key));
        }

        /// <summary>
        /// Verifies a plaintext password against a stored value. Hashed values are
        /// checked with PBKDF2; legacy (non-hashed) values fall back to a
        /// fixed-time plaintext comparison.
        /// </summary>
        public static bool Verify(string password, string stored)
        {
            if (password == null || string.IsNullOrEmpty(stored))
                return false;

            if (!IsHashed(stored))
            {
                return FixedTimeEquals(
                    Encoding.UTF8.GetBytes(password),
                    Encoding.UTF8.GetBytes(stored));
            }

            string[] parts = stored.Split(Delimiter);
            if (parts.Length != 4) return false;
            if (!int.TryParse(parts[1], out int iterations) || iterations <= 0) return false;

            byte[] salt, expected;
            try
            {
                salt = Convert.FromBase64String(parts[2]);
                expected = Convert.FromBase64String(parts[3]);
            }
            catch (FormatException)
            {
                return false;
            }

            byte[] actual = Pbkdf2(password, salt, iterations);
            return FixedTimeEquals(actual, expected);
        }

        /// <summary>True if the stored value is already in our hash format.</summary>
        public static bool IsHashed(string stored)
        {
            return stored != null
                && stored.StartsWith(Prefix + Delimiter, StringComparison.Ordinal);
        }

        /// <summary>True if a stored value is legacy plaintext and should be re-hashed.</summary>
        public static bool NeedsUpgrade(string stored)
        {
            return !IsHashed(stored);
        }

        private static byte[] Pbkdf2(string password, byte[] salt, int iterations)
        {
            using (var pbkdf2 = new Rfc2898DeriveBytes(
                password, salt, iterations, HashAlgorithmName.SHA256))
            {
                return pbkdf2.GetBytes(KeySize);
            }
        }

        // Length-independent comparison to avoid leaking timing information.
        private static bool FixedTimeEquals(byte[] a, byte[] b)
        {
            int diff = a.Length ^ b.Length;
            for (int i = 0; i < a.Length && i < b.Length; i++)
                diff |= a[i] ^ b[i];
            return diff == 0;
        }
    }
}
