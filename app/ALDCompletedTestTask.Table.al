table 55112 "ALD Completed Test Task"
{
    Caption = 'Completed Test Task';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Test Run No."; Integer)
        {
            Caption = 'Test Run No.';
            TableRelation = "ALD Completed Test Batch"."Test Run No.";
            DataClassification = ToBeClassified;
        }
        field(10; "Batch Name"; Code[20])
        {
            Caption = 'Test Batch Name';
            TableRelation = "ALD Completed Test Batch"."Test Batch Name" where("Test Run No." = field("Test Run No."));
            DataClassification = CustomerContent;
        }
        field(20; "Session No."; Code[20])
        {
            Caption = 'Session No.';
            TableRelation = "ALD Completed Test Session"."Session No." where("Test Run No." = field("Test Run No."));
            DataClassification = CustomerContent;
        }
        field(30; "Session Clone No."; Integer)
        {
            Caption = 'Session Clone No.';
            TableRelation = "ALD Completed Test Session"."Clone No." where("Test Run No." = field("Test Run No."), "Test Batch Name" = field("Batch Name"));
            DataClassification = CustomerContent;
        }
        field(40; "Task No."; Code[20])
        {
            Caption = 'Task No.';
            TableRelation = "ALD Test Task"."Task No." where("Session Code" = field("Session No."));
            DataClassification = CustomerContent;
        }
        field(50; State; Option)
        {
            Caption = 'State';
            OptionMembers = ,,Completed,Failed,Terminated;
            OptionCaption = ',,Completed,Failed,Terminated';
            DataClassification = CustomerContent;
        }
        field(60; "Start DateTime"; DateTime)
        {
            Caption = 'Start Date/Time';
            DataClassification = CustomerContent;
        }
        field(70; "End DateTime"; DateTime)
        {
            Caption = 'End Date/Time';
            DataClassification = CustomerContent;
        }
        field(80; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = ,,,Report,,Codeunit;
            OptionCaption = ',,,Report,,Codeunit';
            DataClassification = SystemMetadata;
        }
        field(90; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = field("Object Type"));
            DataClassification = SystemMetadata;
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
        key(PK; "Test Run No.", "Session No.", "Session Clone No.", "Task No.")
        {
            Clustered = true;
        }
        key(BatchTask; "Batch Name", "Session No.", "Session Clone No.", "Task No.") { }
        key(RunDateTime; "Start DateTime", "End DateTime") { }
    }
}