codeunit 55101 "ALD Task Runner"
{
    TableNo = "ALD Active Test Task";

    trigger OnRun()
    begin
        case Rec."Object Type" of
            Rec."Object Type"::Codeunit:
                Codeunit.Run(Rec."Object ID");
            Rec."Object Type"::Report:
                Report.Run(Rec."Object ID");
        end;
    end;
}