namespace Morcadium.BCAPIDemo.System.Security.AccessControl;
using System.Security.AccessControl;

permissionsetextension 70000 D365BusFullAccessMORAPI extends "D365 BUS FULL ACCESS"
{
    IncludedPermissionSets = BCAPIDemoAdminMORAPI;
}