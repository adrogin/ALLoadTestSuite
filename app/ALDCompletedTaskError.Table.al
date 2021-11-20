table 55114 "ALD Completed Task Error"
{
    Caption = 'Completed Task Error';
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Test Run No."; Integer)
        {
            Caption = 'Test Run No.';
            TableRelation = "ALD Completed Test Batch"."Test Run No.";
        }
        field(2; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "ALD Test Batch";
        }
        field(3; "Session No."; Code[20])
        {
            Caption = 'Session No.';
            TableRelation = "ALD Completed Test Session"."Session No." where("Test Batch Name" = field("Batch Name"));
        }
        field(4; "Session Clone No."; Integer)
        {
            Caption = 'Session Clone No.';
            TableRelation = "ALD Completed Test Session"."Clone No." where("Test Batch Name" = field("Batch Name"), "Session No." = field("Session No."));
        }
        field(5; "Task No."; Code[20])
        {
            Caption = 'Task No.';
            TableRelation =
                "ALD Completed Test Task"."Task No." where("Batch Name" = field("Batch Name"),
                "Session No." = field("Session No."), "Session Clone No." = field("Session Clone No."));
        }
        field(6; "Error Code"; Text[30])
        {
            Caption = 'Error Code';
        }
        field(7; "Error Text"; Blob)
        {
            Caption = 'Error Text';
        }
        field(8; "Error Call Stack"; Blob)
        {
            Caption = 'Error Call Stack';
        }
    }

    keys
    {
        key(PK; "Test Run No.", "Session No.", "Session Clone No.", "Task No.")
        {
            Clustered = true;
        }
    }
}
