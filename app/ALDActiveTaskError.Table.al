table 55109 "ALD Active Task Error"
{
    Caption = 'Active Task Error';
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "ALD Test Batch";
            DataClassification = CustomerContent;
        }
        field(2; "Session No."; Code[20])
        {
            Caption = 'Session No.';
            TableRelation = "ALD Active Test Session"."Session No." where("Batch Name" = field("Batch Name"));
            DataClassification = CustomerContent;
        }
        field(3; "Session Clone No."; Integer)
        {
            Caption = 'Session Clone No.';
            TableRelation = "ALD Active Test Session"."Clone No." where("Batch Name" = field("Batch Name"), "Session No." = field("Session No."));
            DataClassification = CustomerContent;
        }
        field(4; "Task No."; Code[20])
        {
            Caption = 'Task No.';
            TableRelation =
                "ALD Active Test Task"."Task No." where("Batch Name" = field("Batch Name"),
                "Session No." = field("Session No."), "Session Clone No." = field("Session Clone No."));
            DataClassification = CustomerContent;
        }
        field(5; "Error Code"; Text[30])
        {
            Caption = 'Error Code';
            DataClassification = CustomerContent;
        }
        field(6; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
            DataClassification = CustomerContent;
        }
        field(7; "Error Call Stack"; Blob)
        {
            Caption = 'Error Call Stack';
            DataClassification = CustomerContent;
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