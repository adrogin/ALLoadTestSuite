page 55108 "ALD Active Tasks Subpage"
{
    PageType = ListPart;
    SourceTable = "ALD Active Test Task";

    layout
    {
        area(Content)
        {
            repeater(ActiveTestTasks)
            {
                field(TaskNo; Rec."Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Code of the test task.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description of the test task.';
                }
                field(ObjectType; Rec."Object Type")
                {
                    ToolTip = 'Type of the object executed in the test task.';
                }
                field(ObjectID; Rec."Object ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'ID of the object executed in the test task.';
                }
                field(ObjectName; Rec."Object Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the object executed in the test task.';
                }
            }
        }
    }
}