namespace Morcadium.BCAPIDemo.Purchases.Vendor;

using Microsoft.Purchases.Vendor;

page 70005 VendorAPIMORAPI
{
    APIGroup = 'purchasing';
    APIPublisher = 'morcadium';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Vendor API';
    DelayedInsert = true;
    EntityName = 'vendor';
    EntitySetName = 'vendors';
    PageType = API;
    SourceTable = Vendor;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                }
                field(name; Rec.Name)
                {
                }
                field(name2; Rec."Name 2")
                {
                }
                field(ourAccountNo; Rec."Our Account No.")
                {
                }
                field(contact; Rec.Contact)
                {
                }
                field(email; Rec."E-Mail")
                {
                }
                field(phoneNo; Rec."Phone No.")
                {
                }
                field(address; Rec.Address)
                {
                }
                field(address2; Rec."Address 2")
                {
                }
                field(city; Rec.City)
                {
                }
                field(county; Rec.County)
                {
                }
                field(postCode; Rec."Post Code")
                {
                }
                field(countryRegionCode; Rec."Country/Region Code")
                {
                }
                field(paymentTermsCode; Rec."Payment Terms Code")
                {
                }
                field(vendorPostingGroup; Rec."Vendor Posting Group")
                {
                }
            }
        }
    }
    [ServiceEnabled]
    [Scope('Cloud')]
    procedure Block(var actionContext: WebServiceActionContext)
    begin
        Rec.Validate(Blocked, Rec.Blocked::All);
        Rec.Modify(true);

        actionContext.SetObjectType(ObjectType::Page);
        actionContext.SetObjectId(Page::VendorAPIMORAPI);
        actionContext.AddEntityKey(Rec.FIELDNO("No."), Rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Updated);

    end;

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure Unblock(var actionContext: WebServiceActionContext)
    begin
        Rec.Validate(Blocked, Rec.Blocked::" ");
        Rec.Modify(true);
        actionContext.SetObjectType(ObjectType::Page);
        actionContext.SetObjectId(Page::VendorAPIMORAPI);
        actionContext.AddEntityKey(Rec.FIELDNO("No."), Rec."No.");
        actionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;
}