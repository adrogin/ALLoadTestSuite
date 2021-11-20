table 55108 "ALD Active Test Task"
{
    Caption = 'Active Test Task';
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "ALD Active Test Batch";
            Editable = false;
        }
        field(15; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(20; "Session Code"; Code[20])
        {
            Caption = 'Session Code';
            TableRelation = "ALD Active Test Session"."Session Code" where("Batch Name" = field("Batch Name"));
            Editable = false;
        }
        field(30; "Session Clone No."; Integer)
        {
            Caption = 'Session Clone No.';
            TableRelation =
                "ALD Active Test Session"."Clone No."
                    where("Batch Name" = field("Batch Name"), "No." = field("No."));
            Editable = false;
        }
        field(40; "Task No."; Code[20])
        {
            Caption = 'Task No.';
            TableRelation = "ALD Test Task"."Task No." where("Session Code" = field("Session Code"));
            Editable = false;
        }
        field(50; State; Enum "ALD Test State")
        {
            Caption = 'State';
            InitValue = Ready;
            Editable = false;
        }
        field(60; "Start DateTime"; DateTime)
        {
            Caption = 'Start Date/Time';
            Editable = false;
        }
        field(70; "End DateTime"; DateTime)
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
        field(80; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = ,,,Report,,Codeunit;
            OptionCaption = ',,,Report,,Codeunit';
            Editable = false;
        }
        field(90; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = field("Object Type"));
            Editable = false;
        }
        field(100; "Object Name"; Text[30])
        {
            Caption = 'Object Name';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = field("Object Type"), "Object ID" = field("Object ID")));
            Editable = false;
        }
        field(110; Description; Text[30])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(120; "Duration"; Integer)
        {
            Caption = 'Duration';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Batch Name", "No.", "Session Clone No.", "Task No.")
        {
            Clustered = true;
        }
    }
}