namespace Morcadium.BCAPIDemo.Purchases.Document;

using Microsoft.Finance.AllocationAccount;
using Microsoft.Foundation.UOM;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;
using Microsoft.Utilities;

table 70001 StagingPurchLnMORAPI
{
    Caption = 'Staging Purch Line';
    DataClassification = CustomerContent;
    DrillDownPageId = StagingPurchaseLinesMORAPI;
    LookupPageId = StagingPurchaseLinesMORAPI;

    fields
    {

        field(1; "Document Type"; Enum "Purchase Document Type")
        {
            Caption = 'Document Type';
            ToolTip = 'Specifies the type of document that you are about to create.';
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            ToolTip = 'Specifies the name of the vendor who delivered the items.';
            TableRelation = Vendor;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            ToolTip = 'Specifies the document number.';
            TableRelation = "Purchase Header"."No." where("Document Type" = field("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the line''s number.';
        }
        field(5; Type; Enum "Purchase Line Type")
        {
            Caption = 'Type';
            ToolTip = 'Specifies the line type.';
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
            ValidateTableRelation = false;
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true), "Account Type" = const(Posting), Blocked = const(false))
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge"
            else
            if (Type = const(Item)) Item where(Blocked = const(false), "Purchasing Blocked" = const(false))
            else
            if (Type = const("Allocation Account")) "Allocation Account"
            else
            if (Type = const(Resource)) Resource;
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies a description of the entry of the product to be purchased. To add a non-transactional text line, fill in the Description field only.';
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            ToolTip = 'Specifies information in addition to the description.';
        }
        field(13; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            ToolTip = 'Specifies the unit of measure.';
        }
        field(15; Quantity; Decimal)
        {
            AutoFormatType = 0;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the number of units of the item specified on the line.';
        }
        field(22; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
        }
        field(65; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            ToolTip = 'Specifies the order number this line is associated with.';
        }
        field(103; "Line Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount';
            ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item),
                                "No." = filter(<> '')) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            if (Type = const(Resource), "No." = filter(<> '')) "Resource Unit of Measure".Code where("Resource No." = field("No."))
            else
            if (Type = filter("Charge (Item)" | "Fixed Asset" | "G/L Account")) "Unit of Measure";
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        field(70001; EntryNo; Integer)
        {
            Caption = 'Entry No.';
            TableRelation = StagingPurchHdrMORAPI.EntryNo;
            ToolTip = 'Auto-incrementing number to indicate sequential order of integrations.';
        }
    }
    keys
    {
        key(PK; EntryNo, "Line No.")
        {
            Clustered = true;
        }
    }

    var
        StgPurchLnMeth: Codeunit StagingPurchaseLineMethMORAPI;

    internal procedure Check()
    begin
        StgPurchLnMeth.Check(Rec);
    end;

    internal procedure Check(var Total: Decimal)
    begin
        StgPurchLnMeth.Check(Rec, Total);
    end;

    internal procedure Patch(DocumentNo: Code[20])
    begin
        StgPurchLnMeth.Patch(Rec, DocumentNo);
    end;

    internal procedure Initialize()
    begin
        StgPurchLnMeth.Initialize(Rec);
    end;
}