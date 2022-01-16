table 55105 "ALD Batch Session"
{
    Caption = 'Batch Session';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "ALD Test Batch";
            NotBlank = true;
        }
        field(2; "Session Code"; Code[20])
        {
            Caption = 'Session Code';
            TableRelation = "ALD Test Session";
            NotBlank = true;

            trigger OnValidate()
            begin
                if "Session Code" = '' then
                    ClearSessionSettings()
                else
                    CopySessionSettings("Session Code");
            end;
        }
        field(3; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(4; "Session Description"; Text[50])
        {
            Caption = 'Session Description';
            FieldClass = FlowField;
            CalcFormula = lookup("ALD Test Session".Description where(Code = field("Session Code")));
        }
        field(5; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company.Name;
        }
        field(6; "No. of Clones"; Integer)
        {
            Caption = 'No. of Clones';
            MinValue = 1;
            InitValue = 1;
        }
        field(7; "Session Start Delay"; Integer)
        {
            Caption = 'First Session Delay (ms)';

            trigger OnValidate()
            begin
                TestExecute.CheckDelayTime("Session Start Delay");
            end;
        }
        field(8; "Delay Between Clones"; Integer)
        {
            Caption = 'Delay Between Clones (ms)';

            trigger OnValidate()
            begin
                TestExecute.CheckDelayTime("Delay Between Clones");
            end;
        }
        field(9; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
        }
    }

    keys
    {
        key(PK; "Batch Name", "No.")
        {
            Clustered = true;
        }
    }

    local procedure ClearSessionSettings()
    begin
        Rec.Validate("Company Name", '');
        Rec.Validate("No. of Clones", 0);
        Rec.Validate("Delay Between Clones", 0);
        Rec.Validate("Session Start Delay", 0);
    end;

    local procedure CopySessionSettings(FromTestSessionCode: Code[20])
    var
        TestSession: Record "ALD Test Session";
    begin
        TestSession.Get(FromTestSessionCode);
        Rec.Validate("Company Name", TestSession."Company Name");
        Rec.Validate("No. of Clones", TestSession."No. of Clones");
        Rec.Validate("Delay Between Clones", TestSession."Delay Between Clones");
        Rec.Validate("Session Start Delay", TestSession."Session Start Delay");
    end;

    procedure GetLastSessionNo(): Integer
    var
        BatchSession: Record "ALD Batch Session";
    begin
        BatchSession.SetRange("Batch Name", Rec."Batch Name");
        if BatchSession.FindLast() then
            exit(BatchSession."No.");

        exit(0);
    end;

    var
        TestExecute: Codeunit "ALD Test - Execute";
}