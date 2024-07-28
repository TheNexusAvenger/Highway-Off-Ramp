using Highway.Server.Model.State;
using Highway.Server.Util;
using NUnit.Framework;

namespace Highway.Server.Test.Model.Project;

public class ScriptHashCollectionTest
{
    [Test]
    public void TestSortHashKeys()
    {
        var hashCollection = new ScriptHashCollection();
        hashCollection.Hashes!["Path5"] = "hash5";
        hashCollection.Hashes!["Path4"] = "hash4";
        hashCollection.Hashes!["path3"] = "hash3";
        hashCollection.Hashes!["Path2"] = "hash2";
        hashCollection.Hashes!["Path1"] = "hash1";
        
        Assert.That(hashCollection.Hashes.Keys, Is.Not.EqualTo(new List<string>() {"Path1", "Path2", "path3", "Path4", "Path5"}));
        hashCollection.SortHashes();
        Assert.That(hashCollection.Hashes.Keys, Is.EqualTo(new List<string>() {"Path1", "Path2", "path3", "Path4", "Path5"}));
    }
}