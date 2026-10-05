$ErrorActionPreference = 'Stop'
$base = Join-Path $PSScriptRoot '../client-android/ring-android/libringclient/src/main/java/net/jami'
$path = Join-Path $base 'services/CallService.kt'
$s = [IO.File]::ReadAllText($path)
if ($s.Contains('CallAccounts.accountFor(')) { throw 'Call API migration already applied; refusing duplicate rewrite.' }
$methods = 'setActiveParticipant|setConferenceLayout|refuse|accept|hangUp|muteParticipant|hangupParticipant|hold|unhold|getCallDetails|muteLocalMedia|transfer|attendedTransfer|toggleRecording|sendTextMessage|addMainParticipant|detachParticipant|hangUpConference|holdConference|unholdConference|isConferenceParticipant|getParticipantList|getConferenceId|getConferenceDetails'
$s = [regex]::Replace($s, "JamiService\.($methods)\((\w+)(?=[,)])", 'JamiService.$1(CallAccounts.accountFor($2), $2')
$s = $s.Replace('JamiService.getCallList()', 'CallAccounts.allCalls()')
$s = $s.Replace('JamiService.joinParticipant(selCallId, dragCallId)', 'JamiService.joinParticipant(CallAccounts.accountFor(selCallId), selCallId, CallAccounts.accountFor(dragCallId), dragCallId)')
$s = $s.Replace('JamiService.addParticipant(callId, confId)', 'JamiService.addParticipant(CallAccounts.accountFor(callId), callId, CallAccounts.accountFor(confId), confId)')
$s = $s.Replace('JamiService.joinConference(selConfId, dragConfId)', 'JamiService.joinConference(CallAccounts.accountFor(selConfId), selConfId, CallAccounts.accountFor(dragConfId), dragConfId)')
[IO.File]::WriteAllText($path, $s, [Text.UTF8Encoding]::new($false))
