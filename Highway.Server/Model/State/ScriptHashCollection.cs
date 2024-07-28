namespace Highway.Server.Model.State;

public class ScriptHashCollection
{
    /// <summary>
    /// Current hashes of the script contents in Roblox Studio.
    /// </summary>
    public IDictionary<string, string>? Hashes { get; set; } = new Dictionary<string, string>();

    /// <summary>
    /// Sorts the hashes by key.
    /// This does decrease the performances of adding/getting hashes. Only intended to be called before saving.
    /// </summary>
    public void SortHashes()
    {
        var newHashes = new SortedDictionary<string, string>(StringComparer.InvariantCultureIgnoreCase);
        foreach (var (key, value) in this.Hashes!)
        {
            newHashes[key] = value;
        }
        this.Hashes = newHashes;
    }
}