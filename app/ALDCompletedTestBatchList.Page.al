page 55110 "ALD Completed Test Batch List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALD Completed Test Batch";
    Caption = 'Completed Test Batches';
    CardPageId = "ALD Completed Test Batch Card";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(TestBatches)
            {
                field(Name; Rec."Test Run No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sequential number of the test batch execution.';
                }
                field(Rec; Rec."Test Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The name of the test batch.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"ALD Completed Test Batch Card", Rec);
                    end;
                }
                field("Start DateTime"; "Start DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when the test batch started.';
                }
                field("End DateTime"; "End DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when the test batch completed or was terminated.';
                }
            }
        }
    }
}