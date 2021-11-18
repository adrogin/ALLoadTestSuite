table 55104 "ALD Active Test Batch"
{
    Caption = 'Active Test Batch';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(2; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "ALD Test Batch";
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup("ALD Test Batch".Description where(Name = field("Batch Name")));
            Editable = false;
        }
        field(4; "Start DateTime"; DateTime)
        {
            Caption = 'Start Date/Time';
        }
        field(5; "End DateTime"; DateTime)
        {
            Caption = 'End Date/Time';

            trigger OnValidate()
            var
                TestExecute: Codeunit "ALD Test - Execute";
            begin
                Rec.Validate("Duration", TestExecute.GetDuration(Rec."Start DateTime", Rec."End DateTime"));
            end;
        }
        field(6; "Controller Session ID"; Integer)
        {
            Caption = 'Controller Session ID';
            DataClassification = SystemMetadata;
        }
        field(7; "Duration"; Integer)
        {
            Caption = 'Duration';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Batch Name")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        ActiveTestSession: Record "ALD Active Test Session";
    begin
        ActiveTestSession.SetRange("Batch Name", Rec."Batch Name");
        ActiveTestSession.DeleteAll(true);
    end;
}