namespace Morcadium.BCAPIDemo.System.Security.AccessControl;
using Morcadium.BCAPIDemo.Purchases.Document;
using System.Security.AccessControl;
using Morcadium.BCAPIDemo.Purchases.Vendor;
using BC.Purchases.Document;
using Microsoft.Purchases.Vendor;

permissionset 70000 BCAPIDemoAdminMORAPI
{
    Assignable = true;
    Caption = 'Admin (BC API Demo)';
    IncludedPermissionSets = "D365 BASIC",
        "D365 PURCH DOC, EDIT",
        LOCAL,
        LOGIN,
        "Vendor - Edit";
    Permissions = table StagingPurchHdrMORAPI = X,
        tabledata StagingPurchHdrMORAPI = RIMD,
        table StagingPurchLnMORAPI = X,
        tabledata StagingPurchLnMORAPI = RIMD,
        table Vendor = X,
        tabledata Vendor = RIMD,
        codeunit StagingPurchaseLineMethMORAPI = X,
        codeunit StagingPurchaseMethMORAPI = X,
        codeunit VendorMethMORAPI = X,
        page StagingPurchaseAPIMORAPI = X,
        page StagingPurchaseLineAPIMORAPI = X,
        page StagingPurchaseLinesMORAPI = X,
        page StagingPurchaseMORAPI = X,
        page StagingPurchasesMORAPI = X,
        page VendorAPIMORAPI = X,
        query purchaseAPIMOR = X;
}