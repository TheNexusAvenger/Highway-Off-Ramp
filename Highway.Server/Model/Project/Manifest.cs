﻿namespace Highway.Server.Model.Project;

public class Manifest
{
    /// <summary>
    /// Optional display name of the project.
    /// </summary>
    public string? Name { get; set; }
    
    /// <summary>
    /// Optional place id to require for pulling/pushing changes.
    /// </summary>
    public long? PushPlaceId { get; set; }

    /// <summary>
    /// Dictionary of the Studio paths to the file system paths to sync.
    /// </summary>
    public Dictionary<string, string> Paths { get; set; } = null!;

    /// <summary>
    /// Determines the file system path for a script path.
    /// </summary>
    /// <param name="parentDirectory">Parent directory to base the manifest off of.</param>
    /// <param name="scriptPath">Path of the script.</param>
    /// <returns>File path of the script, if any.</returns>
    public string? GetPathForScriptPath(string parentDirectory, string scriptPath)
    {
        // Determine the longest file path that matches the script path.
        string? baseScriptPath = null;
        foreach (var (newBaseScriptPath, _) in this.Paths)
        {
            if (!scriptPath.StartsWith(newBaseScriptPath.Replace('.', '/'))) continue;
            if (baseScriptPath != null && baseScriptPath.Length > newBaseScriptPath.Length) continue;
            baseScriptPath = newBaseScriptPath;
        }
        
        // Return the path.
        if (baseScriptPath == null) return null;
        return Path.GetFullPath(Path.Combine(parentDirectory, this.Paths[baseScriptPath], scriptPath.Replace(baseScriptPath.Replace('.', '/') + "/", "")));
    }

    /// <summary>
    /// Determines the script path for a file system path.
    /// </summary>
    /// <param name="parentDirectory">Parent directory to base the manifest off of.</param>
    /// <param name="path">Path of the file. Must be an absolute path.</param>
    /// <returns>Script path of the file, if any.</returns>
    public string? GetScriptPathForPath(string parentDirectory,string path)
    {
        foreach (var (baseScriptPath, baseFilePath) in this.Paths)
        {
            var fullBaseFilePath = Path.GetFullPath(Path.Combine(parentDirectory, baseFilePath));
            if (!path.StartsWith(fullBaseFilePath)) continue;
            if (!fullBaseFilePath.EndsWith(Path.DirectorySeparatorChar.ToString()))
            {
                fullBaseFilePath += Path.DirectorySeparatorChar;
            }
            var remainingPath = path.Substring(fullBaseFilePath.Length).Replace(Path.DirectorySeparatorChar, '/');
            var scriptPath = baseScriptPath.Replace('.', '/') + "/" + remainingPath;
            return scriptPath;
        }
        return null;
    }
}