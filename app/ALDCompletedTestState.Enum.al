enum 55101 "ALD Completed Test State"
{
    Extensible = true;
    AssignmentCompatibility = true;

    // Numbering starts from 2 for compatibility with the "Test State" enum 
    value(2; Completed) { Caption = 'Completed'; }
    value(3; Failed) { Caption = 'Failed'; }
    value(4; Terminated) { Caption = 'Terminated'; }
}