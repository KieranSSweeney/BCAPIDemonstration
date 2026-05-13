namespace Morcadium.BCAPIDemo.Integration;

using Microsoft.Purchases.Vendor;
using Morcadium.BCAPIDemo.Purchases.Document;
using Morcadium.BCAPIDemo.Purchases.Vendor;

codeunit 70002 EventSubscriptionsMORAPI
{
    [EventSubscriber(ObjectType::Page, Page::StagingPurchaseAPIMORAPI, OnNewRecordEvent, '', false, false)]
    local procedure StagingPurchaseAPIMORAPI_OnNewRecord(var Rec: Record StagingPurchHdrMORAPI)
    begin
        Rec.Initialize();
    end;

    [EventSubscriber(ObjectType::Page, Page::StagingPurchaseLineAPIMORAPI, OnNewRecordEvent, '', false, false)]
    local procedure StagingPurchaseLineAPIMORAPI_OnNewRecord(var Rec: Record StagingPurchLnMORAPI)
    begin
        Rec.Initialize();
    end;

    [EventSubscriber(ObjectType::Page, Page::VendorAPIMORAPI, OnNewRecordEvent, '', false, false)]
    local procedure VendorAPIMORAPI_OnNewRecord(var Rec: Record Vendor)
    begin
        Rec.Initialize();
    end;

    [EventSubscriber(ObjectType::Table, Database::StagingPurchHdrMORAPI, OnAfterInsertEvent, '', false, false)]
    local procedure StagingPurchHdrMORAPI_OnAfterInsert(var Rec: Record StagingPurchHdrMORAPI)
    begin
        Rec.Check();
    end;

    [EventSubscriber(ObjectType::Table, Database::StagingPurchLnMORAPI, OnAfterInsertEvent, '', false, false)]
    local procedure StagingPurchLnMORAPI_OnAfterInsert(var Rec: Record StagingPurchLnMORAPI)
    begin
        Rec.Check();
    end;
}