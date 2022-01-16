page 55113 "ALD Completed Test Batch Card"
{
    PageType = Card;
    SourceTable = "ALD Completed Test Batch";
    Caption = 'Completed Load Test Batch';
    Editable = false;
    DataCaptionFields = "Test Run No.", "Test Batch Name";

    layout
    {
        area(Content)
        {
            group(TestBatch)
            {
                ShowCaption = false;

                field(BatchName; Rec."Test Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the selected test batch.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description of the selected test batch.';
                }
                field("Start DateTime"; Rec."Start DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when the test batch started.';
                }
                field("End DateTime"; Rec."End DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when the test batch completed.';
                }
            }

            part(TestSessions; "ALD Completed Sessions Subpage")
            {
                SubPageLink = "Test Run No." = field("Test Run No."), "Test Batch Name" = field("Test Batch Name");
                ApplicationArea = All;
            }

            part(ActiveTestTasks; "ALD Completed Tasks Subpage")
            {
                Provider = TestSessions;
                SubPageLink =
                    "Test Run No." = field("Test Run No."), "Batch Name" = field("Test Batch Name"),
                    "No." = field("No."), "Session Clone No." = field("Clone No.");

                ApplicationArea = All;
            }
        }
    }
}