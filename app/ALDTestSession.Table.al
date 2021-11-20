table 55101 "ALD Test Session"
{
    DataClassification = CustomerContent;
    LookupPageId = "ALD Test Session List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company.Name;
        }
        field(4; "No. of Clones"; Integer)
        {
            Caption = 'No. of Clones';
            MinValue = 1;
            InitValue = 1;
        }
        field(5; "Session Start Delay"; Integer)
        {
            Caption = 'First Session Delay (ms)';

            trigger OnValidate()
            begin
                TestExecute.CheckDelayTime("Session Start Delay");
            end;
        }
        field(6; "Delay Between Clones"; Integer)
        {
            Caption = 'Delay Between Clones (ms)';

            trigger OnValidate()
            begin
                TestExecute.CheckDelayTime("Delay Between Clones");
            end;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        TestTask: Record "ALD Test Task";
    begin
        TestTask.SetRange("Session Code", Rec.Code);
        TestTask.DeleteAll(true);
    end;

    trigger OnRename()
    var
        TestTask: Record "ALD Test Task";
    begin
        TestTask.SetRange("Session Code", xRec.Code);
        if TestTask.FindSet(true, true) then
            repeat
                TestTask.Rename(Rec.Code, TestTask."Task No.");
            until TestTask.Next() = 0;
    end;

    var
        TestExecute: Codeunit "ALD Test - Execute";
}