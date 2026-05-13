namespace Morcadium.BCAPIDemo.Purchases.Document;

page 70004 StagingPurchaseLineAPIMORAPI
{
    APIGroup = 'purchasing';
    APIPublisher = 'morcadium';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Staging Purchase Line API';
    DelayedInsert = true;
    EntityName = 'stagingPurchaseLine';
    EntitySetName = 'stagingPurchaseLines';
    PageType = API;
    SourceTable = StagingPurchLnMORAPI;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(lineNo; Rec."Line No.")
                {
                }
                field("type"; Rec."Type")
                {
                }
                field(no; Rec."No.")
                {
                }
                field(description; Rec.Description)
                {
                }
                field(description2; Rec."Description 2")
                {
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                }
                field(quantity; Rec.Quantity)
                {
                }
                field(directUnitCost; Rec."Direct Unit Cost")
                {
                }
                field(lineAmount; Rec."Line Amount")
                {
                }
                field(orderNo; Rec."Order No.")
                {
                }
                field(entryNo; Rec.EntryNo)
                {
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                }
                field(systemId; Rec.SystemId)
                {
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                }
            }
        }
    }
}