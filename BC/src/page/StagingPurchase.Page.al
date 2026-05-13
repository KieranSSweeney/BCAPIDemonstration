namespace Morcadium.BCAPIDemo.Purchases.Document;

page 70001 StagingPurchaseMORAPI
{
    ApplicationArea = All;
    Caption = 'Staging Purchase';
    Editable = false;
    PageType = Card;
    SourceTable = StagingPurchHdrMORAPI;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(Integration)
            {

                field(EntryNo; Rec.EntryNo)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Details; Rec.Details)
                {
                    MultiLine = true;
                    Width = 500;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Visible = false;
                    ToolTip = 'The date-time at which the record was created.';
                }
                field(SystemCreatedBy; Rec.GetCreatedByName())
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
                    ToolTip = 'The date-time at which the record was last modified.';
                }
                field(SystemModifiedBy; Rec.GetModifiedByName())
                {
                    ToolTip = 'By whom the record was last modified.';
                }
            }
            group(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                }
                field(Total; Rec.Total)
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Your Reference"; Rec."Your Reference")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
            }
            part(Lines; StagingPurchaseLinesMORAPI)
            {
                SubPageLink = EntryNo = field(EntryNo);
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Process)
            {
                ApplicationArea = All;
                Enabled = CanCancelOrProcess;
                Image = Process;
                ToolTip = 'Processes purchase record.';
                trigger OnAction()
                begin
                    Rec.Process();
                end;
            }
            action(Cancel)
            {
                ApplicationArea = All;
                Enabled = CanCancelOrProcess;
                Image = Cancel;
                ToolTip = 'Cancels integration of purchase record.';
                trigger OnAction()
                begin
                    Rec.Cancel();
                end;
            }
            action(Show)
            {
                ApplicationArea = All;
                Enabled = CanShow;
                Image = Navigate;
                ToolTip = 'Shows integrated purchase record.';
                trigger OnAction()
                begin
                    Rec.Show();
                end;
            }
        }
        area(Promoted)
        {
            actionref(Process_Promoted; Process)
            {
            }
            actionref(Cancel_Promoted; Cancel)
            {
            }
            actionref(Show_Promoted; Show)
            {
            }
        }
    }
    var
        CanCancelOrProcess: Boolean;
        CanShow: Boolean;

    trigger OnAfterGetRecord()
    begin
        SetActionEnablement();
    end;

    local procedure SetActionEnablement()
    begin
        CanCancelOrProcess := Rec.Status in [Rec.Status::Error, Rec.Status::Pending];
        CanShow := (Rec."Document Type" = Rec."Document Type"::Invoice) and (Rec.Status in [Rec.Status::Complete, Rec.Status::Superseded]);
    end;
}