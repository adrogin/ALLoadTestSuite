table 55106 "ALD Active Test Session"
{
    Caption = 'Active Test Session';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(10; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "ALD Test Batch";
        }
        field(20; "Session No."; Code[20])
        {
            Caption = 'Session No.';
            TableRelation = "ALD Batch Session"."Session Code" where("Batch Name" = field("Batch Name"));
        }
        field(30; "Clone No."; Integer)
        {
            Caption = 'Clone No.';
        }
        field(40; "Client Session ID"; Integer)
        {
            Caption = 'Client Session ID';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("ALD Active Client Session"."Client Session ID"
                where("Batch Name" = field("Batch Name"), "Session No." = field("Session No."), "Clone No." = field("Clone No.")));
        }
        field(50; "Scheduled Start DateTime"; DateTime)
        {
            Caption = 'Scheduled Start Date/Time';
        }
        field(60; "Start DateTime"; DateTime)
        {
            Caption = 'Start Date/Time';
        }
        field(70; "End DateTime"; DateTime)
        {
            Caption = 'End Date/Time';

            trigger OnValidate()
            var
                TestExecute: Codeunit "ALD Test - Execute";
            begin
                Rec.Validate("Duration", TestExecute.GetDuration(Rec."Start DateTime", Rec."End DateTime"));
            end;
        }
        field(80; State; Enum "ALD Test State")
        {
            Caption = 'State';
            InitValue = Ready;
        }
        field(90; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company;
        }
        field(100; "Duration"; Integer)
        {
            Caption = 'Duration';
        }
    }

    keys
    {
        key(PK; "Batch Name", "Session No.", "Clone No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        ActiveTestTask: Record "ALD Active Test Task";
    begin
        ActiveTestTask.SetRange("Batch Name", Rec."Batch Name");
        ActiveTestTask.SetRange("Session No.", Rec."Session No.");
        ActiveTestTask.SetRange("Session Clone No.", Rec."Clone No.");
        ActiveTestTask.DeleteAll(true);
    end;
}