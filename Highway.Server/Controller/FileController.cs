using Highway.Server.Model.Response;
using Microsoft.AspNetCore.Mvc;

namespace Highway.Server.Controller;

public class FileController : ControllerBase
{
    [HttpGet]
    [Route("/file/list/hashes")]
    public ObjectResult GetListHashes()
    {
        return new BaseResponse()
        {
            Status = "Unsupported",
            Message = "Sync endpoints are not supported in Highway Off-Ramp."
        }.ToObjectResult(405);
    }

    [HttpGet]
    [Route("/file/list/hashes/changes")]
    public ObjectResult GetListHashChanges()
    {
        return new BaseResponse()
        {
            Status = "Unsupported",
            Message = "Sync endpoints are not supported in Highway Off-Ramp."
        }.ToObjectResult(405);
    }

    [HttpGet]
    [Route("/file/read")]
    public ObjectResult GetFile(string? path)
    {
        return new BaseResponse()
        {
            Status = "Unsupported",
            Message = "Sync endpoints are not supported in Highway Off-Ramp."
        }.ToObjectResult(405);
    }
}