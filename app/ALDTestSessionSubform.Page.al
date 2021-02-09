page 55103 "ALD Test Session Subform"
{
    PageType = ListPart;
    SourceTable = "ALD Test Task";
    Caption = 'Session Tasks';

    layout
    {
        area(Content)
        {
            repeater(Tasks)
            {
                Caption = 'Tasks';

                field(TaskNo; Rec."Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the task';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the text description of the task';
                }
                field(ObjType; Rec."Object Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the olbject to run';
                }
                field(ObjectNo; Rec."Object ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the object to run';
                }
            }
        }
    }
}