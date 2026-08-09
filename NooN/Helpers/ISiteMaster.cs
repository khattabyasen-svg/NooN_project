namespace NooN
{
    /// <summary>
    /// Implemented by every master page so content pages can refresh the navbar
    /// cart badge without depending on a specific master type (desktop/mobile).
    /// </summary>
    public interface ISiteMaster
    {
        void RefreshCartBadge();
    }
}
