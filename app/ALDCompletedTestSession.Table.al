table 55111 "ALD Completed Test Session"
{
    Caption = 'Completed Test Session';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Test Run No."; Integer)
        {
            Caption = 'Test Run No.';
            TableRelation = "ALD Completed Test Batch"."Test Run No.";
            DataClassification = CustomerContent;
        }
        field(10; "Test Batch Name"; Code[20])
        {
            Caption = 'Test Batch No.';
            TableRelation = "ALD Completed Test Batch"."Test Batch Name" where("Test Run No." = field("Test Run No."));
            DataClassification = CustomerContent;
        }
        field(20; "Session No."; Code[20])
        {
            Caption = 'Session No.';
            TableRelation = "ALD Batch Session"."Session Code" where("Batch Name" = field("Test Batch Name"));
            DataClassification = CustomerContent;
        }
        field(30; "Clone No."; Integer)
        {
            Caption = 'Clone No.';
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
        field(80; State; Option)
        {
            Caption = 'State';
            OptionMembers = ,,Completed,Failed,Terminated;
            OptionCaption = ',,Completed,Failed,Terminated';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Test Run No.", "Session No.", "Clone No.")
        {
            Clustered = true;
        }
        key(BatchSession; "Test Batch Name", "Session No.", "Clone No.") { }
        key(RunDateTime; "Start DateTime", "End DateTime") { }
    }
}