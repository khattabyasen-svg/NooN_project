using System.Configuration;
using System.Data.SqlClient;

namespace NooN
{
    /// <summary>
    /// Centralized database access helpers. Keeps the Web.config connection-string
    /// name in one place instead of being repeated across every page.
    /// </summary>
    public static class Db
    {
        /// <summary>Name of the connection string entry in Web.config.</summary>
        public const string ConnectionName = "MyConnection";

        /// <summary>The application's SQL Server connection string.</summary>
        public static string ConnectionString =>
            ConfigurationManager.ConnectionStrings[ConnectionName].ConnectionString;

        /// <summary>Creates a new (unopened) connection to the application database.</summary>
        public static SqlConnection CreateConnection() => new SqlConnection(ConnectionString);
    }
}
