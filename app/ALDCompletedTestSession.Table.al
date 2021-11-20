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
        }
        field(10; "Test Batch Name"; Code[20])
        {
            Caption = 'Test Batch No.';
            TableRelation = "ALD Completed Test Batch"."Test Batch Name" where("Test Run No." = field("Test Run No."));
        }
        field(15; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(20; "Session Code"; Code[20])
        {
            Caption = 'Session Code';
            TableRelation = "ALD Batch Session"."Session Code" where("Batch Name" = field("Test Batch Name"));
        }
        field(30; "Clone No."; Integer)
        {
            Caption = 'Clone No.';
        }
        field(60; "Start DateTime"; DateTime)
        {
            Caption = 'Start Date/Time';
        }
        field(70; "End DateTime"; DateTime)
        {
            Caption = 'End Date/Time';
        }
        field(80; State; Enum "ALD Completed Test State")
        {
            Caption = 'State';
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
        key(PK; "Test Run No.", "No.", "Clone No.")
        {
            Clustered = true;
        }
        key(BatchSession; "Test Batch Name") { }
        key(RunDateTime; "Start DateTime", "End DateTime") { }
    }
}