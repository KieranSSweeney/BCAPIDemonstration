namespace Morcadium.BCAPIDemo.Purchases.Document;
using Microsoft.Inventory.Location;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;
using Morcadium.BCAPIDemo.Integration;

table 70000 StagingPurchHdrMORAPI
{
    Caption = 'Staging Purchaes Header';
    DataClassification = CustomerContent;
    DrillDownPageId = StagingPurchaseMORAPI;
    LookupPageId = StagingPurchasesMORAPI;

    fields
    {
        field(1; "Document Type"; Enum "Purchase Document Type")
        {
            Caption = 'Document Type';
            ToolTip = 'They type of purchase document.';
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor;
            ToolTip = 'Specifies the vendor who will deliver the goods or services. Each vendor has a unique number to help you track related documents. The number can come from a number series or be added manually.';
        }
        field(11; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
            ToolTip = 'Specifies the vendor''s reference.';
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
            ToolTip = 'Specifies when the purchase invoice is due for payment.';
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            ToolTip = 'Specifies the location where the items are to be placed when they are received. This field acts as the default location for new lines. You can update the location code for individual lines as needed.';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(68; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
            ToolTip = 'Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it''s required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.';
        }
        field(99; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ToolTip = 'Specifies the date when the related document was created.';
        }
        field(70001; EntryNo; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            ToolTip = 'Incrementing number used to sequence integrations.';
        }
        field(70002; Status; Enum StatusMORAPI)
        {
            ToolTip = 'Indicates current integration progress.';
        }
        field(70003; Details; Text[500])
        {
            ToolTip = 'Supplemental information to the integration status.';
        }
        field(70004; Total; Decimal)
        {
            AutoFormatType = 1;
            ToolTip = 'Compared to the summation of Purchase Lines as a checksum.';
        }
    }
    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
    }
    var
        StgPurchMeth: Codeunit StagingPurchaseMethMORAPI;

    internal procedure Check(IncludeLines: Boolean)
    begin
        StgPurchMeth.Check(Rec, IncludeLines);
    end;

    internal procedure Check()
    begin
        StgPurchMeth.Check(Rec, false);
    end;

    internal procedure Initialize()
    begin
        StgPurchMeth.Initialize(Rec);
    end;

    internal procedure GetCreatedByName() Name: Text[80]
    begin
        Name := StgPurchMeth.GetCreatedByName(Rec)
    end;

    internal procedure GetModifiedByName() Name: Text[80]
    begin
        Name := StgPurchMeth.GetModifiedByName(Rec)
    end;

    internal procedure Process()
    begin
        StgPurchMeth.Process(Rec);
    end;

    internal procedure Cancel()
    begin
        StgPurchMeth.Cancel(Rec);
    end;

    internal procedure Show()
    begin
        StgPurchMeth.Show(Rec);
    end;
}