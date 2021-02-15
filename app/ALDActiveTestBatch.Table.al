table 55104 "ALD Active Test Batch"
{
    Caption = 'Active Test Batch';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Batch Name"; Code[20])
        {
            Caption = 'Batch Name';
            TableRelation = "ALD Test Batch";
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup("ALD Test Batch".Description where(Name = field("Batch Name")));
            Editable = false;
        }
        field(3; "Start DateTime"; DateTime)
        {
            Caption = 'Start Date/Time';
            DataClassification = CustomerContent;
        }
        field(4; "End DateTime"; DateTime)
        {
            Caption = 'End Date/Time';
            DataClassification = CustomerContent;
        }
        field(100; "Controller Session ID"; Integer)
        {
            Caption = 'Controller Session ID';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Batch Name")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        ActiveTestSession: Record "ALD Active Test Session";
    begin
        ActiveTestSession.SetRange("Batch Name", Rec."Batch Name");
        ActiveTestSession.DeleteAll(true);
    end;
}