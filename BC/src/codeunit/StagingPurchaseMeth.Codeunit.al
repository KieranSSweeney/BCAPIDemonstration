namespace Morcadium.BCAPIDemo.Purchases.Document;

using Microsoft.Foundation.NoSeries;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Setup;
using Microsoft.Purchases.Vendor;
using System.Security.AccessControl;

codeunit 70000 StagingPurchaseMethMORAPI
{
    TableNo = StagingPurchHdrMORAPI;

    internal procedure Cancel(var StgPurchHdr: Record StagingPurchHdrMORAPI)
    begin
        StgPurchHdr.Validate(Status, StgPurchHdr.Status::Canceled);
        StgPurchHdr.Modify(true);
    end;

    [TryFunction]
    internal procedure Check(var StgPurchHdr: Record StagingPurchHdrMORAPI; IncludeLines: Boolean)
    begin
        CheckIntegrated(StgPurchHdr);
        StgPurchHdr.TestField("Buy-from Vendor No.");
        CheckVendor(StgPurchHdr."Buy-from Vendor No.");

        if IncludeLines then
            CheckLines(StgPurchHdr.EntryNo, StgPurchHdr.Total);
    end;

    internal procedure Process(var StgPurchHdr: Record StagingPurchHdrMORAPI)
    begin
        if StgPurchHdr.Status in [StgPurchHdr.Status::Canceled, StgPurchHdr.Status::Complete, StgPurchHdr.Status::Superseded] then
            exit;

        Clear(StgPurchHdr.Details);
        if Patch(StgPurchHdr) then begin
            StgPurchHdr.Validate(Status, StgPurchHdr.Status::Complete);
            Supersede(StgPurchHdr);
        end
        else begin
            StgPurchHdr.Validate(Status, StgPurchHdr.Status::Error);
            StgPurchHdr.Details := CopyStr(GetLastErrorText, 1, MaxStrLen(StgPurchHdr.Details));
        end;
        StgPurchHdr.Modify(true);
    end;

    local procedure CheckIntegrated(var StgPurchHdr: Record StagingPurchHdrMORAPI)
    var
        PurchHdr: Record "Purchase Header";
        PurchInvHdr: Record "Purch. Inv. Header";
        LblErrAlreadyIntegrated: Label 'This invoice has already been integrated%1.';
    begin
        PurchInvHdr.SetRange("Buy-from Vendor No.", StgPurchHdr."Buy-from Vendor No.");
        PurchInvHdr.SetRange("Vendor Invoice No.", StgPurchHdr."Vendor Invoice No.");
        if not PurchInvHdr.IsEmpty() then
            Error(LblErrAlreadyIntegrated, ' and posted');
        PurchHdr.SetRange("Buy-from Vendor No.", StgPurchHdr."Buy-from Vendor No.");
        PurchHdr.SetRange("Vendor Invoice No.", StgPurchHdr."Vendor Invoice No.");
        PurchHdr.SetFilter(Status, '%1|%2|%3', PurchHdr.Status::Released, PurchHdr.Status::"Pending Approval", PurchHdr.Status::"Pending Prepayment");
        if not PurchHdr.IsEmpty() then
            Error(LblErrAlreadyIntegrated, '');
    end;

    local procedure CheckLines(EntryNo: Integer; HdrTotal: Decimal)
    var
        StgPurchLn: Record StagingPurchLnMORAPI;
        LnTotal: Decimal;
        LblErrTotal: Label 'Variance of %1 was found comparing the %2 from Total field of the Staging Purchase to %3 summed from the Purchase Lines.';
    begin
        StgPurchLn.SetRange(EntryNo, EntryNo);
        if StgPurchLn.FindSet(false) then
            repeat
                StgPurchLn.Check(LnTotal);
            until StgPurchLn.Next() = 0;
        if LnTotal <> HdrTotal then
            Error(LblErrTotal, HdrTotal - LnTotal, HdrTotal, LnTotal);
    end;

    local procedure CheckVendor(VendorNo: Code[20])
    var
        Vendor: Record Vendor;
        LblErrBlocked: Label 'Vendor must have a blocked selection of either blank or Payment to process this purchase.';
        LblErrSetup: Label 'Vendor lacks a required fields to process a Purchase.';
    begin
        Vendor.SetLoadFields(Blocked, "Gen. Bus. Posting Group", "Vendor Posting Group");
        Vendor.Get(VendorNo);
        if Vendor.Blocked = Vendor.Blocked::All then
            Vendor.FieldError(Blocked, LblErrBlocked);
        if Vendor."Gen. Bus. Posting Group" = '' then
            Vendor.FieldError("Gen. Bus. Posting Group", LblErrSetup);
        if Vendor."Vendor Posting Group" = '' then
            Vendor.FieldError("Vendor Posting Group", LblErrSetup);
    end;

    local procedure DeletePurchsaeLines(PurchHdr: Record "Purchase Header")
    var
        PurchLn: Record "Purchase Line";
    begin
        PurchLn.SetRange("Document Type", PurchHdr."Document Type");
        PurchLn.SetRange("Document No.", PurchHdr."No.");
        PurchLn.DeleteAll(true);
    end;

    local procedure InsertPurchase(var PurchHdr: Record "Purchase Header"; StgPurchHdr: Record StagingPurchHdrMORAPI)
    var
        PurchPayableSetup: Record "Purchases & Payables Setup";
        NoSeriesMgmt: Codeunit "No. Series";
        LblErrNotImplemented: Label '%1 is not implemented.';
    begin
        PurchPayableSetup.SetLoadFields("Invoice Nos.");
        PurchPayableSetup.Get();

        PurchHdr.Init();

        PurchHdr.Validate("Document Type", StgPurchHdr."Document Type");
        PurchHdr.Validate("Buy-from Vendor No.", StgPurchHdr."Buy-from Vendor No.");
        case StgPurchHdr."Document Type" of
            StgPurchHdr."Document Type"::Invoice:
                PurchHdr.Validate("No.", NoSeriesMgmt.GetNextNo(PurchPayableSetup."Invoice Nos."));
            //TODO: Add handling for Credit Memos.
            else
                Error(LblErrNotImplemented, PurchHdr."Document Type");
        end;
        PurchHdr.Insert(true);
        PurchHdr.TransferFields(StgPurchHdr, false);
        if StgPurchHdr."Location Code" <> '' then
            PurchHdr.Validate("Location Code", StgPurchHdr."Location Code");
        PurchHdr.Modify(true)
    end;

    [TryFunction]
    local procedure Patch(var StgPurchHdr: Record StagingPurchHdrMORAPI)
    var
        PurchHdr: Record "Purchase Header";
        StgPurchLn: Record StagingPurchLnMORAPI;
        InvoiceNo: Code[20];
    begin
        Check(StgPurchHdr, true);

        PurchHdr.SetRange("Document Type", StgPurchHdr."Document Type");
        PurchHdr.SetRange("Vendor Invoice No.", StgPurchHdr."Vendor Invoice No.");
        if PurchHdr.FindFirst() then begin
            DeletePurchsaeLines(PurchHdr);
            PurchHdr.Delete(true);
        end;

        InsertPurchase(PurchHdr, StgPurchHdr);

        StgPurchLn.SetRange(EntryNo, StgPurchHdr.EntryNo);
        if StgPurchLn.FindSet(false) then
            repeat
                StgPurchLn.Patch(PurchHdr."No.");
            until StgPurchLn.Next() = 0;

        PurchHdr.PerformManualRelease();
    end;

    local procedure SetPurchase(var PurchHdr: Record "Purchase Header"; var StgPurchHdr: Record StagingPurchHdrMORAPI)
    begin
        PurchHdr.Validate("Vendor Invoice No.", StgPurchHdr."Vendor Invoice No.");
    end;

    local procedure Supersede(StgPurchHdr: Record StagingPurchHdrMORAPI)
    var
        StaleStgPurchHdrs: Record StagingPurchHdrMORAPI;
    begin
        StaleStgPurchHdrs.SetRange("Document Type", StgPurchHdr."Document Type");
        StaleStgPurchHdrs.SetRange("Buy-from Vendor No.", StgPurchHdr."Buy-from Vendor No.");
        StaleStgPurchHdrs.SetRange("Vendor Invoice No.", StgPurchHdr."Vendor Invoice No.");
        StaleStgPurchHdrs.SetFilter(EntryNo, '<%1', StgPurchHdr.EntryNo);
        StaleStgPurchHdrs.ModifyAll(Status, StaleStgPurchHdrs.Status::Superseded);
    end;

    internal procedure Initialize(var StgPurchHdr: Record StagingPurchHdrMORAPI)
    begin
        StgPurchHdr.Status := StgPurchHdr.Status::Pending;
    end;

    internal procedure GetModifiedByName(var StgPurchHdr: Record StagingPurchHdrMORAPI) Name: Text[80]
    begin
        Name := GetUsername(StgPurchHdr.SystemModifiedBy);
    end;

    internal procedure GetCreatedByName(var StgPurchHdr: Record StagingPurchHdrMORAPI) Name: Text[80]
    begin
        Name := GetUsername(StgPurchHdr.SystemCreatedBy);
    end;

    local procedure GetUsername(UserID: Guid) Name: Text[80]
    var
        User: Record User;
    begin
        User.SetLoadFields("Full Name");
        if User.Get(UserID) then
            Name := User."Full Name";
    end;

    internal procedure Show(var StgPurch: Record StagingPurchHdrMORAPI)
    var
        PurchHdr: Record "Purchase Header";
        PurchInv: Record "Purch. Inv. Header";
    begin
        if StgPurch."Document Type" = StgPurch."Document Type"::Invoice then begin
            if not ShowPostedInvoice(StgPurch) then
                ShowPurchase(StgPurch)
        end;
    end;

    local procedure ShowPurchase(var StgPurch: Record StagingPurchHdrMORAPI) Exists: Boolean
    var
        PurchHdr: Record "Purchase Header";
    begin
        PurchHdr.SetRange("Document Type", StgPurch."Document Type");
        PurchHdr.SetRange("Buy-from Vendor No.", StgPurch."Buy-from Vendor No.");
        PurchHdr.SetRange("Vendor Invoice No.", StgPurch."Vendor Invoice No.");
        Exists := PurchHdr.FindFirst();
        if Exists then
            //TODO: Add handling for other purchsae document types for broader display.
            Page.Run(Page::"Purchase Invoice", PurchHdr)
    end;

    internal procedure ShowPostedInvoice(var StgPurch: Record StagingPurchHdrMORAPI) Exists: Boolean
    var
        PurchInv: Record "Purch. Inv. Header";
    begin
        PurchInv.SetRange("Buy-from Vendor No.", StgPurch."Buy-from Vendor No.");
        PurchInv.SetRange("Vendor Invoice No.", StgPurch."Vendor Invoice No.");
        Exists := PurchInv.FindFirst();
        if Exists then
            Page.Run(Page::"Posted Purchase Invoice", PurchInv);
    end;

}