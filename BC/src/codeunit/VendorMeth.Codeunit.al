namespace Morcadium.BCAPIDemo.Purchases.Vendor;

using Microsoft.Finance.Dimension;
using Microsoft.Foundation.NoSeries;
using Microsoft.Purchases.Setup;
using Microsoft.Purchases.Vendor;
using System.Reflection;

codeunit 70003 VendorMethMORAPI
{
    TableNo = Vendor;
    internal procedure Initialize(var Vendor: Record Vendor)
    begin
        if Vendor."No." = '' then
            Vendor."No." := GetNextVendorNo();
    end;

    local procedure GetNextVendorNo() VendorNo: Code[20]
    var
        PurchPayableSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        PurchPayableSetup.SetLoadFields("Vendor Nos.");
        PurchPayableSetup.Get();
        if PurchPayableSetup."Vendor Nos." = '' then exit;

        NoSeries.TestAutomatic(PurchPayableSetup."Vendor Nos.");
        VendorNo := NoSeries.GetNextNo(PurchPayableSetup."Vendor Nos.");
    end;
}