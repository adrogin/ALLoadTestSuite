table 55113 "ALD Active Client Session"
{
    fields
    {
        field(10; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "ALD Test Batch";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(20; "Session No."; Code[20])
        {
            Caption = 'Session No.';
            TableRelation = "ALD Batch Session" where("Batch Name" = field("Batch Name"));
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(30; "Clone No."; Integer)
        {
            Caption = 'Clone No.';
            Editable = false;
            DataClassification = CustomerContent;
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
        key(PK; "Batch Name", "Session No.", "Clone No.")
        {
            Clustered = true;
        }
    }
}