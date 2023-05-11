library DllInscE;

uses
  ValidarInscricaoEstadual in 'ValidarInscricaoEstadual.pas';

{$ifdef CPUX64}
  {$libsuffix '64'}
{$else}
  {$libsuffix '32'}
{$endif CPUX64}

{$R *.res}

exports
  UFByStringA,
  UFByStringW,
  ConsisteInscricaoEstadual,
  ConsisteInscricaoEstadualW;

begin

end.