# Highway Off-Ramp
Highway Off-Ramp is a fork of [Highway](https://github.com/TheNexusAvenger/Highway)
for exporting scripts to the file system. Code exported this way is meant for
evaluation with external tools, as opposed to active workflows that will
eventually get synced back into Roblox Studio.

# Files
## `highway.json`
This JSON file is used to configure the server. It can have the following:
- `name: string`: Display name of the project.
- `pushPlaceId: number`: Optional place id to require for pushing changes.
- `paths: {[string]: string}` *(Required)*: Map of the Studio instance paths to the directories to store the files.

Unlike Highway, `pushPlaceId` can be considered optional since the tool
is meant for simple exports. Below is a sample configuration.

```json
{
    "name": "My Project",
    "pushPlaceId": 12345,
    "paths": {
        "ReplicatedStorage": "src/ReplicatedStorage",
        "ServerStorage.Folder1": "src/ServerStorage/Folder1",
        "ServerStorage.Folder2": "src/ServerStorage/Folder2",
        "ServerStorage.Folder3.Folder4": "src/Custom",
        "TestService": "test"
    }
}
```

## `highway-hashes.json`
This file is generated when a push from Roblox Studio is done. It has no
functional use in Highway Off-Ramp, but is kept for comparisons.

## License
Highway Off-Ramp is available under the terms of the GNU Lesser General
Public License. See [LICENSE](LICENSE) for details.