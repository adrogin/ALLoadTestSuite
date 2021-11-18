controladdin "ALD Timer Event AddIn"
{
    StartupScript = '.\TimerEventAddIn\TimerEventAddInStartup.js';
    Scripts = '.\TimerEventAddIn\TimerEventAddIn.js';

    procedure SetTimerInterval(Interval: Integer);

    event AddInLoaded();
    event OnTimer();
}