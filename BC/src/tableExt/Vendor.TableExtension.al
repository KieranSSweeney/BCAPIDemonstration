namespace Morcadium.BCAPIDemo.Purchases.Vendor;

using Microsoft.Purchases.Vendor;
tableextension 70001 VendorMORAPI extends Vendor
{
    internal procedure Initialize()
    var
        VendorMeth: Codeunit VendorMethMORAPI;
    begin
        VendorMeth.Initialize(Rec);
    end;
}