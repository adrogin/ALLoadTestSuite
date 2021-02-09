table 55101 "ALD Test Session"
{
    DataClassification = CustomerContent;
    LookupPageId = "ALD Test Session List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(3; "Company Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Company Name';
            TableRelation = Company.Name;
        }
        field(4; "No. of Clones"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Clones';
            MinValue = 1;
            InitValue = 1;
        }
        field(5; "Session Start Delay"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'First Session Delay (ms)';

            trigger OnValidate()
            begin
                CheckDelayTime("Session Start Delay");
            end;
        }
        field(6; "Delay Between Clones"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Delay Between Clones (ms)';

            trigger OnValidate()
            begin
                CheckDelayTime("Delay Between Clones");
            end;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        TestTask: Record "ALD Test Task";
    begin
        TestTask.SetRange("Session Code", Rec.Code);
        TestTask.DeleteAll(true);
    end;

    trigger OnRename()
    var
        TestTask: Record "ALD Test Task";
    begin
        TestTask.SetRange("Session Code", xRec.Code);
        if TestTask.FindSet(true, true) then
            repeat
                TestTask.Rename(Rec.Code, TestTask."Task No.");
            until TestTask.Next() = 0;
    end;

    local procedure CheckDelayTime(NewTime: Integer)
    var
        LoadTestSetup: Record "ALD Setup";
        DelayNotSetupMultipleErr: Label 'Delay time must be a multiple of %1.', Comment = '%1: base time unit multiplier';
    begin
        LoadTestSetup.Get();
        LoadTestSetup.TestField("Task Update Frequency");
        if NewTime mod LoadTestSetup."Task Update Frequency" <> 0 then
            Error(DelayNotSetupMultipleErr, LoadTestSetup."Task Update Frequency");
    end;
}