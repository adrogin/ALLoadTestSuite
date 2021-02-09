table 55106 "ALD Active Test Session"
{
    Caption = 'Active Test Session';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(10; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "ALD Test Batch";
            Editable = false;
        }
        field(20; "Session No."; Code[20])
        {
            Caption = 'Session No.';
            TableRelation = "ALD Batch Session" where("Batch Name" = field("Batch Name"));
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
            TableRelation = Session."Connection ID";
            Editable = false;
        }
        field(50; "Scheduled Start DateTime"; DateTime)
        {
            Caption = 'Scheduled Start Date/Time';
            Editable = false;
        }
        field(60; "Start DateTime"; DateTime)
        {
            Caption = 'Start Date/Time';
            Editable = false;
        }
        field(70; "End DateTime"; DateTime)
        {
            Caption = 'End Date/Time';
            Editable = false;
        }
        field(80; State; Option)
        {
            Caption = 'State';
            OptionMembers = Ready,Running,Completed,Failed,Terminated;
            OptionCaption = 'Ready,Running,Completed,Failed,Terminated';
            InitValue = Ready;
            Editable = false;
        }
        field(90; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Batch Name", "Session No.", "Clone No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        ActiveTestTask: Record "ALD Active Test Task";
    begin
        ActiveTestTask.SetRange("Batch Name", Rec."Batch Name");
        ActiveTestTask.SetRange("Session No.", Rec."Session No.");
        ActiveTestTask.SetRange("Session Clone No.", Rec."Clone No.");
        ActiveTestTask.DeleteAll(true);
    end;
}