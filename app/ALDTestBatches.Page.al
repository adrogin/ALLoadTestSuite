page 55101 "ALD Test Batches"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALD Test Batch";
    Caption = 'Load Test Batches';
    PromotedActionCategories = 'New,Process,Report,Manage';

    layout
    {
        area(Content)
        {
            repeater(LoadTestBatches)
            {
                Caption = 'Load Test Batches';

                field(Name; Rec.Name)
                {
                    ToolTip = 'The name of the batch.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description of the batch';
                    ApplicationArea = All;
                }
            }
        }
    }
    // TODO: Add a factbox with batch sessions

    actions
    {
        area(Processing)
        {
            action(Execute)
            {
                Caption = 'Run Test Batch';
                ApplicationArea = All;
                ToolTip = 'Executes the selected test batch';
                Image = ExecuteBatch;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;

                trigger OnAction();
                var
                    LoadTestExecute: Codeunit "ALD Test - Execute";
                    ActiveTestBatch: Page "ALD Active Test Batch";
                begin
                    ActiveTestBatch.Run();
                    LoadTestExecute.RunTestBatch(Rec.Name);
                end;
            }
        }
        area(Navigation)
        {
            action(Sessions)
            {
                Caption = 'Sessions';
                ApplicationArea = All;
                ToolTip = 'Open the list of batch sessions';
                Image = WorkflowSetup;
                RunObject = page "ALD Batch Sessions";
                RunPageLink = "Batch Name" = field(Name);
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;
            }
        }
    }
}