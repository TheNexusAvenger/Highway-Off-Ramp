using Highway.Server.Model.Project;
using Highway.Server.Model.Response;
using Highway.Server.Util;
using Microsoft.AspNetCore.Mvc;

namespace Highway.Server.Controller;

public class ProjectController : ControllerBase
{
    [HttpGet]
    [Route("/project/manifest")]
    public ObjectResult GetProjectManifest()
    {
        return new ProjectManifestResponse()
        {
            Manifest = FileUtil.Get<Manifest>(FileUtil.FindFileInParent(FileUtil.ProjectFileName))!,
        }.ToObjectResult(200);
    }
    
    [HttpGet]
    [Route("/project/hashes")]
    public ObjectResult GetProjectHashes()
    {
        return new BaseResponse()
        {
            Status = "Unsupported",
            Message = "Sync endpoints are not supported in Highway Off-Ramp."
        }.ToObjectResult(405);
    }
}