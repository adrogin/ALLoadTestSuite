table 55113 "ALD Active Client Session"
{
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "ALD Test Batch";
            Editable = false;
        }
        field(15; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(20; "Session Code"; Code[20])
        {
            Caption = 'Session Code';
            TableRelation = "ALD Batch Session"."Session Code" where("Batch Name" = field("Batch Name"));
            Editable = false;
        }
        field(30; "Clone No."; Integer)
        {
            Caption = 'Clone No.';
            Editable = false;
        }
        field(40; "Client Session ID"; Integer)
        {
            Caption = 'Client Session ID';
            Editable = false;
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Batch Name", "No.", "Clone No.")
        {
            Clustered = true;
        }
    }
}