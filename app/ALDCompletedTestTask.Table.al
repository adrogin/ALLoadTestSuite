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
        }
        field(10; "Batch Name"; Code[20])
        {
            Caption = 'Test Batch Name';
            TableRelation = "ALD Completed Test Batch"."Test Batch Name" where("Test Run No." = field("Test Run No."));
        }
        field(20; "Session No."; Code[20])
        {
            Caption = 'Session No.';
            TableRelation = "ALD Completed Test Session"."Session No." where("Test Run No." = field("Test Run No."));
        }
        field(30; "Session Clone No."; Integer)
        {
            Caption = 'Session Clone No.';
            TableRelation = "ALD Completed Test Session"."Clone No." where("Test Run No." = field("Test Run No."), "Test Batch Name" = field("Batch Name"));
        }
        field(40; "Task No."; Code[20])
        {
            Caption = 'Task No.';
            TableRelation = "ALD Test Task"."Task No." where("Session Code" = field("Session No."));
        }
        field(50; State; Enum "ALD Completed Test State")
        {
            Caption = 'State';
        }
        field(60; "Start DateTime"; DateTime)
        {
            Caption = 'Start Date/Time';
        }
        field(70; "End DateTime"; DateTime)
        {
            Caption = 'End Date/Time';
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
        }
        field(110; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(120; "Duration"; Integer)
        {
            Caption = 'Duration';
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