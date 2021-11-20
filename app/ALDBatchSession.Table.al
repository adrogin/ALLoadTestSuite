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
            Caption = 'Session No.';
            TableRelation = "ALD Test Session";
            NotBlank = true;

            trigger OnValidate()
            var
                LoadTestSession: Record "ALD Test Session";
            begin
                if "Session Code" = '' then
                    Validate("Company Name", '')
                else begin
                    LoadTestSession.Get("Session Code");
                    Rec.Validate("Company Name", LoadTestSession."Company Name");
                    Rec.Validate("No. of Clones", LoadTestSession."No. of Clones");
                    Rec.Validate("Delay Between Clones", LoadTestSession."Delay Between Clones");
                    Rec.Validate("Session Start Delay", LoadTestSession."Session Start Delay");
                end;
            end;
        }
        field(3; "Session Sequence No."; Integer)
        {
            Caption = 'Session Sequence No.';
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
            DataClassification = CustomerContent;
            Caption = 'Delay Between Clones (ms)';

            trigger OnValidate()
            begin
                TestExecute.CheckDelayTime("Delay Between Clones");
            end;
        }
    }

    keys
    {
        key(PK; "Batch Name", "Session Code")
        {
            Clustered = true;
        }
    }

    var
        TestExecute: Codeunit "ALD Test - Execute";
}