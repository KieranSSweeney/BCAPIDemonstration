namespace Morcadium.BCAPIDemo.Purchases.Document;

page 70002 StagingPurchaseLinesMORAPI
{
    ApplicationArea = All;
    Caption = 'Staging Purchase Lines';
    Editable = false;
    PageType = ListPart;
    SourceTable = StagingPurchLnMORAPI;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Type"; Rec."Type")
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                }
                field("Line Amount"; Rec."Line Amount")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Visible = false;
                    ToolTip = 'The date-time at which the record was created.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    Visible = false;
                    ToolTip = 'By whom the record was created.';
                }
                field(SystemId; Rec.SystemId)
                {
                    Visible = false;
                    ToolTip = 'Unique GUID across all records throughout this environment.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    Visible = false;
                    ToolTip = 'The date-time at which the record was last modified.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    Visible = false;
                    ToolTip = 'By whom the record was last modified.';
                }
            }
        }
    }
}