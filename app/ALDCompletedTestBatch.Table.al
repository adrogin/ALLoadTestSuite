table 55110 "ALD Completed Test Batch"
{
    DataClassification = CustomerContent;
    Caption = 'Completed Test Batch';

    fields
    {
        field(1; "Test Run No."; Integer)
        {
            Caption = 'Test Run No.';
            Editable = false;
        }
        field(2; "Test Batch Name"; Code[20])
        {
            Caption = 'Test Batch Name';
            Editable = false;
        }
        field(3; "Start DateTime"; DateTime)
        {
            Caption = 'Start Date/Time';
            Editable = false;
        }
        field(4; "End DateTime"; DateTime)
        {
            Caption = 'End Date/Time';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Test Run No.")
        {
            Clustered = true;
        }
        key(BatchName; "Test Batch Name") { }
        key(StartTime; "Start DateTime") { }
        key(EndTime; "End DateTime") { }
    }
}