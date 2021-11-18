function SetTimerInterval(timerInterval) {
    setInterval(SendTimerEvent, timerInterval)
}

function SendTimerEvent() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OnTimer');
}