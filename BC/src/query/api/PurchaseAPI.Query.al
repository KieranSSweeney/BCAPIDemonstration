namespace BC.Purchases.Document;

using Microsoft.Purchases.Document;

query 70000 purchaseAPIMOR
{
    APIGroup = 'purchasing';
    APIPublisher = 'morcadium';
    APIVersion = 'v2.0';
    Caption = 'Purchase API';
    EntityName = 'purchase';
    EntitySetName = 'purchases';
    QueryType = API;

    Permissions = tabledata "Purchase Header" = R, tabledata "Purchase Line" = R;

    elements
    {
        dataitem(purchase; "Purchase Header")
        {
            column(documentType; "Document Type")
            {
            }
            column(no; "No.")
            {
            }
            column(documentDate; "Document Date")
            {
            }
            column(postingDate; "Posting Date")
            {
            }
            column(dueDate; "Due Date")
            {
            }
            column(vendorInvoiceNo; "Vendor Invoice No.")
            {
            }
            column(yourReference; "Your Reference")
            {
            }
            column(buyFromVendorNo; "Buy-from Vendor No.")
            {
            }
            column(buyFromVendorName; "Buy-from Vendor Name")
            {
            }
            column(buyFromVendorName2; "Buy-from Vendor Name 2")
            {
            }
            column(buyFromAddress; "Buy-from Address")
            {
            }
            column(buyFromAddress2; "Buy-from Address 2")
            {
            }
            column(buyFromCity; "Buy-from City")
            {
            }
            column(buyFromContact; "Buy-from Contact")
            {
            }
            column(payToVendorNo; "Pay-to Vendor No.")
            {
            }
            column(payToName; "Pay-to Name")
            {
            }
            column(payToName2; "Pay-to Name 2")
            {
            }
            column(payToAddress; "Pay-to Address")
            {
            }
            column(payToAddress2; "Pay-to Address 2")
            {
            }
            column(payToCity; "Pay-to City")
            {
            }
            column(payToContact; "Pay-to Contact")
            {
            }
            dataitem(purchaseLines; "Purchase Line")
            {
                DataItemLink = "Document Type" = purchase."Document Type", "Document No." = purchase."No.";
                column(purchLine_lineNo; "Line No.")
                {
                }
                column(purchLine_type; Type)
                {
                }
                column(purchLine_no; "No.")
                {
                }
                column(purchLine_description; Description)
                {
                }
                column(purchLine_quantity; Quantity)
                {
                }
                column(purchLine_uom; "Unit of Measure")
                {
                }
                column(purchLine_directUnitCost; "Direct Unit Cost")
                {
                }
                column(purchLine_lineAmount; "Line Amount")
                {
                }
            }
        }
    }
}