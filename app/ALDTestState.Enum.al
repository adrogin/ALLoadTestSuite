enum 55100 "ALD Test State"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; Ready) { Caption = 'Ready'; }
    value(1; Running) { Caption = 'Running'; }
    value(2; Completed) { Caption = 'Completed'; }
    value(3; Failed) { Caption = 'Failed'; }
    value(4; Terminated) { Caption = 'Terminated'; }
}