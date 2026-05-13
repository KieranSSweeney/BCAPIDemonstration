namespace Morcadium.BCAPIDemo.Purchases.Document;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Purchases.Document;

codeunit 70001 StagingPurchaseLineMethMORAPI
{
    TableNo = StagingPurchLnMORAPI;

    internal procedure Check(var StgPurchLn: Record StagingPurchLnMORAPI; var Total: Decimal)
    begin
        Check(StgPurchLn);
        if StgPurchLn."Line Amount" = 0 then
            Total += StgPurchLn.Quantity * StgPurchLn."Direct Unit Cost"
        else
            Total += StgPurchLn."Line Amount";
    end;

    internal procedure Check(var StgPurchLn: Record StagingPurchLnMORAPI)
    begin
        case StgPurchLn.Type of
            StgPurchLn.Type::"G/L Account":
                CheckGL(StgPurchLn."No.");
            StgPurchLn.Type::Item:
                CheckItem(StgPurchLn."No.");
            StgPurchLn.Type::Resource:
                CheckResource(StgPurchLn."No.");
        end;
    end;

    internal procedure Initialize(var StgPurchLn: Record StagingPurchLnMORAPI)
    begin
        if StgPurchLn."Line No." = 0 then
            StgPurchLn."Line No." := GetNextLineNo(StgPurchLn.EntryNo);
    end;

    local procedure GetNextLineNo(EntryNo: Integer) LineNo: Integer
    var
        StgPurchLn: Record StagingPurchLnMORAPI;
    begin
        LineNo := 10000;
        StgPurchLn.SetLoadFields("Line No.");
        StgPurchLn.SetRange(EntryNo, EntryNo);
        if StgPurchLn.FindLast() then
            LineNo += StgPurchLn."Line No.";
    end;

    internal procedure Patch(var StgPurchLn: Record StagingPurchLnMORAPI; DocumentNo: Code[20])
    var
        PurchLn: Record "Purchase Line";
    begin
        PurchLn.Init();
        PurchLn.Validate("Document Type", StgPurchLn."Document Type");
        PurchLn.Validate("Document No.", DocumentNo);
        PurchLn.Validate("Line No.", StgPurchLn."Line No.");
        PurchLn.Validate(Type, StgPurchLn.Type);
        PurchLn.Validate("No.", StgPurchLn."No.");
        PurchLn.Validate(Quantity, StgPurchLn.Quantity);
        if StgPurchLn."Line Amount" = 0 then
            PurchLn.Validate("Direct Unit Cost", StgPurchLn."Direct Unit Cost")
        else begin
            PurchLn.Validate("Direct Unit Cost", StgPurchLn."Line Amount" / StgPurchLn.Quantity);
            PurchLn.Validate("Line Amount", StgPurchLn."Line Amount");
        end;
        PurchLn.Insert(true);

        if StgPurchLn.Description <> '' then
            PurchLn.Validate(Description, StgPurchLn.Description);
        if StgPurchLn."Description 2" <> '' then
            PurchLn.Validate("Description 2", StgPurchLn."Description 2");
        if StgPurchLn."Order No." <> '' then
            PurchLn.Validate("Order No.", StgPurchLn."Order No.");

        if StgPurchLn."Unit of Measure Code" = '' then
            PurchLn.Validate("Unit of Measure Code", GetDefaultUOMCode(PurchLn.Type, PurchLn."No."))
        else
            PurchLn.Validate("Unit of Measure Code", StgPurchLn."Unit of Measure Code");

        PurchLn.Modify(true);
    end;

    local procedure GetDefaultUOMCode(Type: enum "Purchase Line Type"; No: Code[20]) UOMCode: Code[10]
    begin
        case Type of
            Type::Item:
                UOMCode := GetItemUOM(No);
            Type::Resource:
                UOMCode := GetResourceUOM(No);
        end;
    end;

    local procedure GetItemUOM(No: Code[20]) UOMCode: Code[10]
    var
        Item: Record Item;
    begin
        Item.SetLoadFields("Base Unit of Measure", "Purch. Unit of Measure");
        Item.Get(No);
        if Item."Purch. Unit of Measure" = '' then
            UOMCode := Item."Base Unit of Measure"
        else
            UOMCode := Item."Purch. Unit of Measure";
    end;

    local procedure GetResourceUOM(No: Code[20]) UOMCode: Code[10]
    var
        Resource: Record Resource;
    begin
        Resource.SetLoadFields("Base Unit of Measure");
        Resource.Get(No);
        UOMCode := Resource."Base Unit of Measure";
    end;

    local procedure CheckGL(GLNo: Code[20])
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.SetLoadFields(Blocked, "Direct Posting", "Account Type");
        GLAccount.Get(GLNo);
        GLAccount.TestField(Blocked, false);
        GLAccount.TestField("Direct Posting");
        GLAccount.TestField("Account Type", GLAccount."Account Type"::Posting);
    end;

    local procedure CheckItem(ItemNo: Code[20])
    var
        Item: Record Item;
        LblErrBlockedReason: Label 'Item is blocked due to the following reason: %1.';
    begin
        Item.SetLoadFields(Blocked, "Block Reason", "Purchasing Blocked");
        Item.Get(ItemNo);
        if Item.Blocked then
            Error(LblErrBlockedReason, Item."Block Reason");
        Item.TestField("Purchasing Blocked", false);
    end;

    local procedure CheckResource(ResourceNo: Code[20])
    var
        Resource: Record Resource;
    begin
        Resource.SetLoadFields(Blocked);
        Resource.Get(ResourceNo);
        Resource.TestField(Blocked, false);
    end;
}