table 55107 "ALD Test Task"
{
    Caption = 'Load Test Session Task';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Session Code"; Code[20])
        {
            Caption = 'Session No.';
            TableRelation = "ALD Test Session";
            DataClassification = CustomerContent;
        }
        field(2; "Task No."; Code[20])
        {
            Caption = 'Task No.';
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = ,,,"Report",,"Codeunit";
            OptionCaption = ',,,Report,,Codeunit';
            DataClassification = SystemMetadata;
            InitValue = "Codeunit";

            trigger OnValidate()
            begin
                Validate("Object ID", 0);
            end;
        }
        field(5; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = field("Object Type"));
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                AllObjWithCaption: Record AllObjWithCaption;
            begin
                if "Object ID" > 0 then begin
                    AllObjWithCaption.Get("Object Type", "Object ID");
                    Validate(Description, AllObjWithCaption."Object Caption");
                end
                else
                    Validate(Description, '');
            end;
        }
        field(6; "Object Name"; Text[30])
        {
            Caption = 'Object Name';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = field("Object Type"), "Object ID" = field("Object ID")));
            Editable = false;
        }
        field(7; "Delay Before Task"; Integer)
        {
            Caption = 'Delay Before Task';
            DataClassification = CustomerContent;
            // TODO: Add the delays to scheduling or delete
        }
        field(8; "Delay After Task"; Integer)
        {
            Caption = 'Delay After Task';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Session Code", "Task No.")
        {
            Clustered = true;
        }
    }
}