table 55108 "ALD Active Test Task"
{
    Caption = 'Active Test Task';
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "ALD Active Test Batch";
            Editable = false;
        }
        field(2; "Session No."; Code[20])
        {
            Caption = 'Session No.';
            TableRelation = "ALD Active Test Session"."Session No." where("Batch Name" = field("Batch Name"));
            Editable = false;
        }
        field(3; "Session Clone No."; Integer)
        {
            Caption = 'Session Clone No.';
            TableRelation = "ALD Active Test Session"."Clone No." where("Batch Name" = field("Batch Name"), "Session No." = field("Session No."));
            Editable = false;
        }
        field(4; "Task No."; Code[20])
        {
            Caption = 'Task No.';
            TableRelation = "ALD Test Task"."Task No." where("Session Code" = field("Session No."));
            Editable = false;
        }
        field(5; State; Option)
        {
            Caption = 'State';
            OptionMembers = Ready,Running,Completed,Failed,Terminated;
            OptionCaption = 'Ready,Running,Completed,Failed,Terminated';
            InitValue = Ready;
            Editable = false;
        }
        field(6; "Start DateTime"; DateTime)
        {
            Caption = 'Start Date/Time';
            Editable = false;
        }
        field(7; "End DateTime"; DateTime)
        {
            Caption = 'End Date/Time';
            Editable = false;
        }
        field(8; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = ,,,Report,,Codeunit;
            OptionCaption = ',,,Report,,Codeunit';
            Editable = false;
        }
        field(9; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = field("Object Type"));
            Editable = false;
        }
        field(10; "Object Name"; Text[30])
        {
            Caption = 'Object Name';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = field("Object Type"), "Object ID" = field("Object ID")));
            Editable = false;
        }
        field(11; Description; Text[30])
        {
            Caption = 'Description';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Batch Name", "Session No.", "Session Clone No.", "Task No.")
        {
            Clustered = true;
        }
    }
}