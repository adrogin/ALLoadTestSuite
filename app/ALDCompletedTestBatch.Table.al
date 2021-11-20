table 55110 "ALD Completed Test Batch"
{
    DataClassification = CustomerContent;
    Caption = 'Completed Test Batch';

    fields
    {
        field(1; "Test Run No."; Integer)
        {
            Caption = 'Test Run No.';
            Editable = false;
        }
        field(2; "Test Batch Name"; Code[20])
        {
            Caption = 'Test Batch Name';
            Editable = false;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup("ALD Test Batch".Description where(Name = field("Test Batch Name")));
            Editable = false;
        }
        field(4; "Start DateTime"; DateTime)
        {
            Caption = 'Start Date/Time';
            Editable = false;
        }
        field(5; "End DateTime"; DateTime)
        {
            Caption = 'End Date/Time';
            Editable = false;

            trigger OnValidate()
            var
                TestExecute: Codeunit "ALD Test - Execute";
            begin
                Rec.Validate("Duration", TestExecute.GetDuration(Rec."Start DateTime", Rec."End DateTime"));
            end;
        }
        field(7; "Duration"; Integer)
        {
            Caption = 'Duration';
            Editable = false;
        }
        field(8; State; Enum "ALD Completed Test State")
        {
            Caption = 'State';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Test Run No.")
        {
            Clustered = true;
        }
        key(BatchName; "Test Batch Name") { }
        key(StartTime; "Start DateTime") { }
        key(EndTime; "End DateTime") { }
    }
}