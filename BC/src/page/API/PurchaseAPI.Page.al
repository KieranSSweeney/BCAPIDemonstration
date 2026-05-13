namespace Morcadium.BCAPIDemo.Purchases.Document;

page 70003 StagingPurchaseAPIMORAPI
{
    APIGroup = 'purchasing';
    APIPublisher = 'morcadium';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Staging Purchase API';
    DelayedInsert = true;
    EntityName = 'stagingPurchase';
    EntitySetName = 'stagingPurchases';
    PageType = API;
    SourceTable = StagingPurchHdrMORAPI;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(documentType; Rec."Document Type")
                {
                }
                field(buyFromVendorNo; Rec."Buy-from Vendor No.")
                {
                }
                field(yourReference; Rec."Your Reference")
                {
                }
                field(dueDate; Rec."Due Date")
                {
                }
                field(locationCode; Rec."Location Code")
                {
                }
                field(vendorInvoiceNo; Rec."Vendor Invoice No.")
                {
                }
                field(documentDate; Rec."Document Date")
                {
                }
                field(total; Rec.Total)
                {
                }
                field(entryNo; Rec.EntryNo)
                {
                }
                field(status; Rec.Status)
                {
                }
                field(details; Rec.Details)
                {
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Editable = false;
                }
                field(systemCreatedBy; Rec.GetCreatedByName())
                {
                    Editable = false;
                }
                field(systemId; Rec.SystemId)
                {
                    Editable = false;
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Editable = false;
                }
                field(systemModifiedBy; Rec.GetModifiedByName())
                {
                    Editable = false;
                }
                part(stagingPurchaseLines; StagingPurchaseLineAPIMORAPI)
                {
                    SubPageLink = EntryNo = field(EntryNo), "Document Type" = field("Document Type");
                }
            }
        }
    }
}