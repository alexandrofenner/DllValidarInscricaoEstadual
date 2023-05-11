unit ValidarInscricaoEstadual;

interface

{$minenumsize 4}

type
  TcrUF = (ufNenhum, ufAC, ufAL, ufAM, ufAP, ufBA, ufCE, ufDF, ufES,
    ufGO, ufMA, ufMG, ufMS, ufMT, ufPA, ufPB, ufPE, ufPI, ufPR, ufRJ,
    ufRN, ufRO, ufRR, ufRS, ufSC, ufSE, ufSP, ufTO);
  UString = UnicodeString;

function UFByStringA(S: PAnsiChar): TcrUF; stdcall;
function UFByStringW(S: PWideChar): TcrUF; stdcall;

{ ConsisteInscricaoEstadual -> com a mesma assinatura do método encontrado
    na DLL DllInscE32.dll fornecida pelo sintegra }
function ConsisteInscricaoEstadual(
  const AIE, AUF: PAnsiChar): Integer; stdcall;
function ConsisteInscricaoEstadualW(
  const AIE, AUF: PWideChar): Integer; stdcall;

implementation

function GetString(const P: PWideChar; const Len: Integer): UString; inline;
begin
  SetString(Result, P, Len);
end;

function TryStrToInt(const S: UString; var I: Integer): Boolean;
var
  Code: Integer;
begin
  Val(S, I, Code);
  Exit(Code <> 0);
end;

const
  cAC = TcrUF.ufAC; cAL = TcrUF.ufAL; cAM = TcrUF.ufAM; cAP = TcrUF.ufAP;
  cBA = TcrUF.ufBA; cCE = TcrUF.ufCE; cDF = TcrUF.ufDF; cES = TcrUF.ufES;
  cGO = TcrUF.ufGO; cMA = TcrUF.ufMA; cMG = TcrUF.ufMG; cMS = TcrUF.ufMS;
  cMT = TcrUF.ufMT; cPA = TcrUF.ufPA; cPB = TcrUF.ufPB; cPE = TcrUF.ufPE;
  cPI = TcrUF.ufPI; cPR = TcrUF.ufPR; cRJ = TcrUF.ufRJ; cRN = TcrUF.ufRN;
  cRO = TcrUF.ufRO; cRR = TcrUF.ufRR; cRS = TcrUF.ufRS; cSC = TcrUF.ufSC;
  cSE = TcrUF.ufSE; cSP = TcrUF.ufSP; cTO = TcrUF.ufTO; c00 = TcrUF.ufNenhum;

const
  UFFromIBGETable: array[00..99] of TcrUF = (
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,     //  00..09
    c00, cRO, cAC, cAM, cRR, cPA, cAP, cTO, c00, c00,     //  10..19
    c00, cMA, cPI, cCE, cRN, cPB, cPE, cAL, cSE, cBA,     //  20..29
    c00, cMG, cES, cRJ, c00, cSP, c00, c00, c00, c00,     //  30..39
    c00, cPR, cSC, cRS, c00, c00, c00, c00, c00, c00,     //  40..49
    cMS, cMT, cGO, cDF, c00, c00, c00, c00, c00, c00,     //  50..59
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,     //  60..69
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,     //  70..79
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,     //  80..89
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00);    //  90..99

  cTabUFByIndex: array[0..672] of TcrUF = (
    c00, c00, cAC, c00, c00, c00, c00, c00, c00, c00, c00, cAL, cAM, c00, c00, cAP,   //  0..15
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, cBA, c00, c00, c00, c00, c00,   //  16..31
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  32..47
    c00, c00, c00, c00, c00, c00, c00, c00, cCE, c00, c00, c00, c00, c00, c00, c00,   //  48..63
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  64..79
    c00, c00, c00, cDF, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  80..95
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  96..111
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, cES, c00, c00, c00, c00, c00,   //  112..127
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  128..143
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  144..159
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, cGO, c00, c00, c00, c00, c00,   //  160..175
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  176..191
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  192..207
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  208..223
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  224..239
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  240..255
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  256..271
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  272..287
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  288..303
    c00, c00, c00, c00, c00, c00, c00, c00, cMA, c00, c00, c00, c00, c00, cMG, c00,   //  304..319
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, cMS, cMT, c00, c00, c00, c00,   //  320..335
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  336..351
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  352..367
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  368..383
    c00, c00, c00, c00, c00, c00, cPA, cPB, c00, c00, cPE, c00, c00, c00, cPI, c00,   //  384..399
    c00, c00, c00, c00, c00, c00, c00, cPR, c00, c00, c00, c00, c00, c00, c00, c00,   //  400..415
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  416..431
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  432..447
    c00, c00, c00, cRJ, c00, c00, c00, cRN, cRO, c00, c00, cRR, cRS, c00, c00, c00,   //  448..463
    c00, c00, c00, c00, c00, c00, cSC, c00, cSE, c00, c00, c00, c00, c00, c00, c00,   //  464..479
    c00, c00, c00, cSP, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  480..495
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, cTO, c00, c00, c00,   //  496..511
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  512..527
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  528..543
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  544..559
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  560..575
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  576..591
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  592..606
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  607..623
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  624..639
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  640..655
    c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00, c00,   //  656..671
    c00);                                                                             //  672

type
  PcrUFSigla = ^TcrUFSigla;
  TcrUFSigla = array[1..2] of WideChar;

function _TrySiglaToUF(const Sigla: TcrUFSigla): TcrUF;
var
  A, B: Integer;
begin
  A := Ord(Sigla[1]) - Ord('A');
  B := Ord(Sigla[2]) - Ord('A');

  if (Cardinal(A) >= 26) then
  begin
    Dec(A, Ord('a') - Ord('A'));
    if (Cardinal(A) >= 26) then
      Exit(TcrUF.ufNenhum);
  end;

  if (Cardinal(B) >= 26) then
  begin
    Dec(B, Ord('a') - Ord('A'));
    if (Cardinal(B) >= 26) then
      Exit(TcrUF.ufNenhum);
  end;

  Exit(cTabUFByIndex[(A * $1A + B)]);
end;

type
  TIs_IE_UF_fn = function(const S: PWideChar; const Len: Integer): Boolean;

const
  Pesos_7_2: array[0..17] of Byte = (2, 3, 4, 5, 6, 7, 2, 3, 4, 5, 6, 7, 2, 3, 4, 5, 6, 7);
  Pesos_9_2: array[0..23] of Byte = (2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5, 6, 7, 8, 9);
  Pesos_9_1: array[0..26] of Byte = (1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  Pesos_10_2: array[0..26] of Byte = (2, 3, 4, 5, 6, 7, 8, 9, 10, 2, 3, 4, 5, 6, 7, 8, 9, 10, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  Pesos_11_2: array[0..29] of Byte = (2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);

type
  TDV1 = WideChar;
  TDV2 = array[1..2] of WideChar;

const
  cDV1_Error = TDV1(0);
  cDV2_Error: TDV2 = (cDV1_Error, cDV1_Error);

function MakeDV2(const C1, C2: WideChar): TDV2; inline;
begin
  Result[1] := C1;
  Result[2] := C2;
end;

function StdCheckDV1(const S: PWideChar; const Len: Integer;
  const DV: TDV1): Boolean; inline;
begin
  Exit(S[Len - 1] = DV);
end;

function StdCheckDV2(const S: PWideChar; const Len: Integer;
  const DV: TDV2): Boolean; inline;
begin
  Exit(PCardinal(@S[Len - 2])^ = Cardinal(DV));
end;

const
  CPrefix01: array[1..2] of WideChar = '01';
  CPrefix03: array[1..2] of WideChar = '03';
  CPrefix12: array[1..2] of WideChar = '12';
  CPrefix15: array[1..2] of WideChar = '15';
  CPrefix20: array[1..2] of WideChar = '20';
  CPrefix24: array[1..2] of WideChar = '24';
  CPrefix28: array[1..2] of WideChar = '28';

{ _DV_IE_AC -> Retorna o dígito verificador de uma IE do ACRE
    Retorna '' se ocorrer algum erro }
function _DV_IE_AC(const S: PWideChar; const Len: Integer): TDV2;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, ac2, dg, dv1, dv2: Integer;
begin
  if (Len <> 11) then
  begin
    { É obrigatório que tenha 11 dígitos a IE sem o DV }
    Exit(cDV2_Error);
  end;

  if (PCardinal(S)^ <> Cardinal(CPrefix01)) then
  begin
    { É obrigatório que comece com '01' }
    Exit(cDV2_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 11);
  Peso := @Pesos_9_2[High(Pesos_9_2) - 4];

  ac1 := 0;
  ac2 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV2_Error);
    end;

    Inc(ac2, (dg * Peso^));
    Dec(Peso);
    Inc(ac1, (dg * Peso^));
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0
  else
    Inc(ac2, dv1 * 2);

  dv2 := (11 - (ac2 mod 11));
  if (dv2 >= 10) then
    dv2 := 0;

  Exit(MakeDV2(WideChar(dv1 + Ord('0')), WideChar(dv2 + Ord('0'))));
end;

function Is_IE_AC(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV2;
begin
  DV := _DV_IE_AC(S, (Len - 2));
  Exit((Cardinal(DV) <> 0) and StdCheckDV2(S, Len, DV));
end;

{ _DV_IE_AL -> Retorna o dígito verificador de uma IE do Alagoas
    Retorna '' se ocorrer algum erro }
function _DV_IE_AL(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  if (PCardinal(S)^ <> Cardinal(CPrefix24)) then
  begin
    { É obrigatório que comece com '24' }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_AL(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_AL(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_AP -> Retorna o dígito verificador de uma IE do Amapá
    Retorna '' se ocorrer algum erro }
function _DV_IE_AP(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  i, p, d, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  if (PCardinal(S)^ <> Cardinal(CPrefix03)) then
  begin
    { É obrigatório que comece com '03' }
    Exit(cDV1_Error);
  end;

  if (not TryStrToInt(GetString(S, Len), i)) then
  begin
    { Se não for possível converter para inteiro }
    Exit(cDV1_Error);
  end;

  if (i < 03017001) then
  begin
    p := 5;
    d := 0;
  end else
  if (i < 03019023) then
  begin
    p := 9;
    d := 1;
  end else
  begin
    p := 0;
    d := 0;
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  while (Cursor < OutOf) do
  begin
    Inc(p, ((Ord(Cursor^) - Ord('0')) * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (p mod 11));
  if (dv1 = 11) then
    dv1 := d
  else if (dv1 = 10) then
    dv1 := 0;

  Exit(WideChar(dv1 + Ord('0')));
end;

function Is_IE_AP(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_AP(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_AM -> Retorna o dígito verificador de uma IE do Amazonas
    Retorna '' se ocorrer algum erro }
function _DV_IE_AM(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_AM(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_AM(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

function _DV_IE_BA8(const S: PWideChar): TDV2;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  dg, ac1, ac2, dv1, dv2: Integer;
begin
  Cursor := Pointer(S);
  OutOf := (Cursor + 6);
  Peso := @Pesos_9_2[High(Pesos_9_2) - 1];

  ac1 := 0;
  ac2 := 0;
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(cDV2_Error);

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(ac2, (dg * Peso^));

    Inc(Cursor);
  end;

  dg := (Ord(S[0]) - Ord('0'));
  case dg of
    0..5, 8:
      begin
        dv2 := (10 - (ac2 mod 10));
        Inc(ac1, (dv2 * 2));
        dv1 := (10 - (ac1 mod 10));
      end;
    6, 7, 9:
      begin
        dv2 := (11 - (ac2 mod 11));
        if (dv2 >= 10) then
          dv2 := 0;
        Inc(ac1, (dv2 * 2));
        dv1 := (11 - (ac1 mod 11));
        if (dv1 >= 10) then
          dv1 := 0;
      end;
    else
      Exit(cDV2_Error);
  end;

  Exit(MakeDV2(WideChar(Ord('0') + dv1), WideChar(Ord('0') + dv2)));
end;

function _DV_IE_BA9(const IE_Sem_DV: UnicodeString): TDV2;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  dg, ac1, ac2, dv1, dv2: Integer;
begin
  Cursor := Pointer(IE_Sem_DV);
  OutOf := (Cursor + 7);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;
  ac2 := 0;
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(cDV2_Error);

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(ac2, (dg * Peso^));

    Inc(Cursor);
  end;

  dg := (Ord(IE_Sem_DV[Low(UnicodeString) + 1]) - Ord('0'));
  case dg of
    0..5, 8:
      begin
        dv2 := (10 - (ac2 mod 10));
        if (dv2 >= 10) then
          dv2 := 0;
        Inc(ac1, (dv2 * 2));
        dv1 := (10 - (ac1 mod 10));
        if (dv1 >= 10) then
          dv1 := 0;
      end;
    6, 7, 9:
      begin
        dv2 := (11 - (ac2 mod 11));
        if (dv2 >= 10) then
          dv2 := 0;
        Inc(ac1, (dv2 * 2));
        dv1 := (11 - (ac1 mod 11));
        if (dv1 >= 10) then
          dv1 := 0;
      end;
    else
      Exit(cDV2_Error);
  end;

  Exit(MakeDV2(WideChar(Ord('0') + dv1), WideChar(Ord('0') + dv2)));
end;

{ _DV_IE_BA -> Retorna o dígito verificador de uma IE da Bahia
    Retorna '' se ocorrer algum erro

    A bahia tem 2 tipos de IE (com 8 e com 9 dígitos) }
function _DV_IE_BA(const S: PWideChar; const Len: Integer): TDV2;
begin
  case Len of
    6: Exit(_DV_IE_BA8(S));
    7: Exit(_DV_IE_BA9(S));
    else
      Exit(cDV2_Error);
  end;
end;

function Is_IE_BA(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV2;
begin
  DV := _DV_IE_BA(S, (Len - 2));
  Exit((Cardinal(DV) <> 0) and StdCheckDV2(S, Len, DV));
end;

{ _DV_IE_CE -> Retorna o dígito verificador de uma IE do Ceará
    Retorna '' se ocorrer algum erro }
function _DV_IE_CE(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  dg, ac1, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(cDV1_Error);

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_CE(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_CE(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_DF -> Retorna o dígito verificador de uma IE do Distrito Federal
    Retorna '' se ocorrer algum erro }
function _DV_IE_DF(const S: PWideChar; const Len: Integer): TDV2;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  dg, ac1, ac2, dv1, dv2: Integer;
begin
  if (Len <> 11) then
  begin
    { É obrigatório que tenha 11 dígitos a IE sem o DV }
    Exit(cDV2_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 11);
  Peso := @Pesos_9_2[High(Pesos_9_2) - 4];

  ac1 := 0;
  ac2 := 0;
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(cDV2_Error);

    Inc(ac2, (dg * Peso^));
    Dec(Peso);
    Inc(ac1, (dg * Peso^));

    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Inc(ac2, (dv1 * 2));
  dv2 := (11 - (ac2 mod 11));
  if (dv2 >= 10) then
    dv2 := 0;

  Exit(MakeDV2(WideChar(Ord('0') + dv1), WideChar(Ord('0') + dv2)));
end;

function Is_IE_DF(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV2;
begin
  DV := _DV_IE_DF(S, (Len - 2));
  Exit((Cardinal(DV) <> 0) and StdCheckDV2(S, Len, DV));
end;

{ _DV_IE_ES -> Retorna o dígito verificador de uma IE do Espírito Santo
    Retorna '' se ocorrer algum erro }
function _DV_IE_ES(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  dg, ac1, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(cDV1_Error);

    Inc(ac1, (dg * Peso^));
    Dec(Peso);

    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_ES(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_ES(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_GO -> Retorna o dígito verificador de uma IE do Goiás
    Retorna '' se ocorrer algum erro }
function _DV_IE_GO(const S: PWideChar; const Len: Integer): TDV1;
const
  cP1: array[1..2] of WideChar = '10';
  cP2: array[1..2] of WideChar = '11';
  cP3: array[1..2] of WideChar = '15';

var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  dg, ac1, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  if (PCardinal(S)^ <> Cardinal(cP1)) and
     (PCardinal(S)^ <> Cardinal(cP2)) and
     (PCardinal(S)^ <> Cardinal(cP3)) then
  begin
    { Deve começar com '10', '11' ou '15' }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(cDV1_Error);

    Inc(ac1, (dg * Peso^));

    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (ac1 mod 11);
  case dv1 of
    0: { Se for zero mantém } ;
    1:
      begin
        { Regra estranha.. mas está no sintegra! }
        if (not TryStrToInt(GetString(S, Len), ac1)) then
          Exit(#0);

        if ((ac1 < 10103105) or (ac1 > 10119997)) then
          dv1 := 0;
      end;
    else
      dv1 := (11 - dv1);
  end;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_GO(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_GO(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_MA -> Retorna o dígito verificador de uma IE do Maranhão
    Retorna '' se ocorrer algum erro }
function _DV_IE_MA(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  dg, ac1, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  if (PCardinal(S)^ <> Cardinal(CPrefix12)) then
  begin
    { É obrigatório que comece com '12' }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(cDV1_Error);

    Inc(ac1, (dg * Peso^));

    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_MA(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_MA(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_MT -> Retorna o dígito verificador de uma IE de Mato Grosso
    Retorna '' se ocorrer algum erro }
function _DV_IE_MT(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  dg, ac1, dv1: Integer;
begin
  if ((Len = 0) or (Len > 10)) then
  begin
    { Para o Estado de Mato Grosso não encontramos tamanho fixo definido
      Sabemos que não pode ser maior que 10 }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + Len);
  Peso := @Pesos_9_2[High(Pesos_9_2) - ((16 - Len) mod 10)];

  ac1 := 0;
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(cDV1_Error);

    Inc(ac1, (dg * Peso^));

    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_MT(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_MT(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_MS -> Retorna o dígito verificador de uma IE de Mato Grosso do Sul
    Retorna '' se ocorrer algum erro }
function _DV_IE_MS(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  dg, ac1, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  if (PCardinal(S)^ <> Cardinal(CPrefix28)) then
  begin
    { É obrigatório que comece com '12' }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(cDV1_Error);

    Inc(ac1, (dg * Peso^));

    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_MS(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_MS(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_MG -> Retorna o dígito verificador de uma IE de Minas Gerais
    Retorna '' se ocorrer algum erro }
function _DV_IE_MG(const S: PWideChar; const Len: Integer): TDV2;
var
  ac, dg1, dg2: Integer;
  Peso: PByte;
  Cursor, OutOf: PWideChar;

  function Add1M1(IdChar: WideChar): Boolean;
  var
    Vlr: Integer;
  begin
    Vlr := (Ord(IdChar) - Ord('0'));
    if (Cardinal(Vlr) > 9) then
      Exit(False);
    Inc(ac, Vlr);
    Exit(True);
  end;

  function Add1M2(IdChar: WideChar): Boolean;
  var
    Vlr: Integer;
  begin
    Vlr := (Ord(IdChar) - Ord('0'));
    if (Cardinal(Vlr) > 9) then
      Exit(False);
    Inc(Vlr, Vlr);
    Inc(ac, (Vlr mod 10) + (Vlr div 10));
    Exit(True);
  end;

begin
  if (Len <> 11) then
  begin
    { É obrigatório que tenha 11 dígitos a IE sem o DV }
    Exit(cDV2_Error);
  end;

  ac := 0;
  if not (Add1M1(S[00]) and Add1M2(S[01]) and Add1M1(S[02]) and Add1M1(S[03]) and Add1M2(S[04]) and
    Add1M1(S[05]) and Add1M2(S[06]) and Add1M1(S[07]) and Add1M2(S[08]) and Add1M1(S[09]) and Add1M2(S[10])) then
  begin
    { Falha ao tentar obter o acumulador 1}
    Exit(cDV2_Error);
  end;

  dg1 := (10 - (ac mod 10));

  Peso := @Pesos_11_2[High(Pesos_11_2) - 8];
  Cursor := S;
  OutOf := (S + Len);
  ac := (dg1 * 2);

  while (Cursor < OutOf) do
  begin
    Inc(ac, (Ord(Cursor^) - Ord('0')) * Peso^);
    Inc(Cursor);
    Dec(Peso);
  end;

  dg2 := (11 - (ac mod 11));
  if (dg2 >= 10) then
    dg2 := 0;

  Exit(MakeDV2(WideChar(Ord('0') + dg1), WideChar(Ord('0') + dg2)));
end;

function Is_IE_MG(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV2;
begin
  DV := _DV_IE_MG(S, (Len - 2));
  Exit((Cardinal(DV) <> 0) and StdCheckDV2(S, Len, DV));
end;

{ _DV_IE_PA -> Retorna o dígito verificador de uma IE do Pará
    Retorna '' se ocorrer algum erro }
function _DV_IE_PA(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  if (PCardinal(S)^ <> Cardinal(CPrefix15)) then
  begin
    { É obrigatório que comece com '15' }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_PA(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_PA(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_PB -> Retorna o dígito verificador de uma IE da Paraíba
    Retorna '' se ocorrer algum erro }
function _DV_IE_PB(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_PB(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_PB(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_PR -> Retorna o dígito verificador de uma IE do Paraná
    Retorna '' se ocorrer algum erro }
function _DV_IE_PR(const S: PWideChar; const Len: Integer): TDV2;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, ac2, dg, dv1, dv2: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV2_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_7_2[High(Pesos_7_2) - 3];

  ac1 := 0;
  ac2 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV2_Error);
    end;

    Inc(ac2, (dg * Peso^));
    Dec(Peso);
    Inc(ac1, (dg * Peso^));
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Inc(ac2, (dv1 * 2));
  dv2 := (11 - (ac2 mod 11));
  if (dv2 >= 10) then
    dv2 := 0;

  Exit(MakeDV2(WideChar(Ord('0') + dv1), WideChar(Ord('0') + dv2)));
end;

function Is_IE_PR(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV2;
begin
  DV := _DV_IE_PR(S, (Len - 2));
  Exit((Cardinal(DV) <> 0) and StdCheckDV2(S, Len, DV));
end;

{ _DV_IE_PE -> Retorna o dígito verificador de uma IE do Pernambuco
    Retorna '' se ocorrer algum erro }
function _DV_IE_PE9(const S: PWideChar): TDV2;
//  _DV_IE_PE9 -> Calcula o dígito verificador da inscrição no eFisco de Pernambuco
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, ac2, dg, dv1, dv2: Integer;
begin
  Cursor := Pointer(S);
  OutOf := (Cursor + 7);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;
  ac2 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV2_Error);
    end;

    Inc(ac2, (dg * Peso^));
    Dec(Peso);
    Inc(ac1, (dg * Peso^));
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Inc(ac2, (dv1 * 2));
  dv2 := (11 - (ac2 mod 11));
  if (dv2 >= 10) then
    dv2 := 0;

  Exit(MakeDV2(WideChar(Ord('0') + dv1), WideChar(Ord('0') + dv2)));
end;

function _DV_IE_PE14(const S: PWideChar): TDV1;
//  _DV_IE_PE14 -> Calcula o dígito verificador da inscrição no CACEPE (IE antiga)
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  Cursor := Pointer(S);
  OutOf := (Cursor + 13);
  Peso := @Pesos_9_1[High(Pesos_9_1) - 4];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function _DV_IE_PE(const S: PWideChar; const Len: Integer): TDV2;
begin
  case Len of
    7: Exit(_DV_IE_PE9(S));
    13: Exit(MakeDV2(_DV_IE_PE14(S), #$00));
    else
      Exit(cDV2_Error);
  end;
end;

function Is_IE_PE(const S: PWideChar; const Len: Integer): Boolean;
var
  DV2: TDV2;
  DV1: TDV1 absolute DV2;
begin
  case Len of
    9:
      begin
        DV2 := _DV_IE_PE9(S);
        Exit((Cardinal(DV2) <> 0) and StdCheckDV2(S, Len, DV2));
      end;
    14:
      begin
        DV1 := _DV_IE_PE14(S);
        Exit((Word(DV1) <> 0) and StdCheckDV1(S, Len, DV1));
      end;
    else
      Exit(False);
  end;
end;

{ _DV_IE_PI -> Retorna o dígito verificador de uma IE do Piauí
    Retorna '' se ocorrer algum erro }
function _DV_IE_PI(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_PI(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_PI(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_RJ -> Retorna o dígito verificador de uma IE do Rio de Janeiro
    Retorna '' se ocorrer algum erro }
function _DV_IE_RJ(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (Len <> 7) then
  begin
    { É obrigatório que tenha 7 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 7);
  Peso := @Pesos_7_2[High(Pesos_7_2) - 5];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_RJ(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_RJ(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_RN -> Retorna o dígito verificador de uma IE do Alagoas
    Retorna '' se ocorrer algum erro }
function _DV_IE_RN9(const S: PWideChar): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (PCardinal(S)^ <> Cardinal(CPrefix20)) then
  begin
    { É obrigatório que comece com '20' }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  ac1 := (ac1 * 10);
  dv1 := (ac1 mod 11);
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function _DV_IE_RN10(const S: PWideChar): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (PCardinal(S)^ <> Cardinal(CPrefix20)) then
  begin
    { É obrigatório que comece com '20' }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_11_2[High(Pesos_11_2) - 1];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  ac1 := (ac1 * 10);
  dv1 := (ac1 mod 11);
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function _DV_IE_RN(const S: PWideChar; const Len: Integer): TDV1;
begin
  case Len of
    8: Exit(_DV_IE_RN9(S));
    9: Exit(_DV_IE_RN10(S));
    else
      Exit(cDV1_Error);
  end;
end;

function Is_IE_RN(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_RN(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_RS -> Retorna o dígito verificador de uma IE do Rio Grande do Sul
    Retorna '' se ocorrer algum erro }
function _DV_IE_RS(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (Len <> 9) then
  begin
    { É obrigatório que tenha 9 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 9);
  Peso := @Pesos_9_2[High(Pesos_9_2) - 7];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_RS(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_RS(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

function _DV_IE_RO9(const S: PWideChar): TDV1;
{ _DV_IE_RO9 -> IE com fórmula adotada antes de 01/08/2000 }
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Inc(Cursor, 3);    { Ignorar o código do município }

  Peso := @Pesos_9_2[High(Pesos_9_2) - 3];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function _DV_IE_RO14(const S: PWideChar): TDV1;
{ _DV_IE_RO14 -> IE com fórmula adotada a partir de 01/08/2000 }
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  Cursor := Pointer(S);
  OutOf := (Cursor + 13);

  Peso := @Pesos_9_2[High(Pesos_9_2) - 3];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function _DV_IE_RO(const S: PWideChar; const Len: Integer): TDV1;
begin
  case Len of
    8: Exit(_DV_IE_RO9(S));
    13: Exit(_DV_IE_RO14(S));
    else
      Exit(cDV1_Error);
  end;
end;

function Is_IE_RO(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_RO(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_RR -> Retorna o dígito verificador de uma IE de Roraíma
    Retorna '' se ocorrer algum erro }
function _DV_IE_RR(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  if (PCardinal(S)^ <> Cardinal(CPrefix24)) then
  begin
    { É obrigatório que comece com '24' }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_1[0];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Inc(Peso);
    Inc(Cursor);
  end;

  dv1 := (ac1 mod 9);

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_RR(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_RR(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_SC -> Retorna o dígito verificador de uma IE de Santa Catarina
    Retorna '' se ocorrer algum erro }
function _DV_IE_SC(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_SC(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_SC(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

const
  Peso_SP1: array[0..7] of Byte = (1, 3, 4, 5, 6, 7, 8, 10);

function Is_IE_SP12(const S: PWideChar): Boolean;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac, dg, dv: Integer;
begin
  Cursor := S;
  OutOf := (S + 8);
  Peso := @Peso_SP1;

  ac := 0;
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(False);

    Inc(ac, dg * Peso^);
    Inc(Peso);
    Inc(Cursor);
  end;

  dv := (ac mod 11);
  if (dv >= 10) then
    dv := 0;

  { -> Valida o primeiro digito verificador }
  if (Cursor^ <> WideChar(Ord('0') + dv)) then
    Exit(False);

  Peso := @Pesos_10_2[High(Pesos_10_2) - 7];
  Cursor := S;
  OutOf := (S + 11);

  ac := 0;
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(False);

    Inc(ac, dg * Peso^);
    Dec(Peso);
    Inc(Cursor);
  end;

  dg := (ac mod 11);
  if (dg >= 10) then
    dg := 0;

  Exit(S[11] = WideChar(Ord('0') + dg));
end;

function Is_IE_SP13(const S: PWideChar): Boolean;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac, dg, dv: Integer;
begin
  if (UpCase(S[0]) <> 'P') then
  begin
    { IE de produtor sempre começa com 'P' }
    Exit(False);
  end;

  Cursor := (S + 1);
  OutOf := (Cursor + 8);
  Peso := @Peso_SP1;

  ac := 0;
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(False);

    Inc(ac, dg * Peso^);
    Inc(Peso);
    Inc(Cursor);
  end;

  dv := (ac mod 11);
  if (dv >= 10) then
    dv := 0;

  { -> Valida o primeiro digito verificador }
  if (Cursor^ <> WideChar(Ord('0') + dv)) then
    Exit(False);

  OutOf := (S + 13);
  Inc(Cursor);

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
      Exit(False);

    Inc(Cursor);
  end;

  Exit(True);
end;

function Is_IE_SP(const S: PWideChar; const Len: Integer): Boolean;
begin
  case Len of
    12: Exit(Is_IE_SP12(S));
    13: Exit(Is_IE_SP13(S));
    else
      Exit(False);
  end;
end;

{ _DV_IE_SE -> Retorna o dígito verificador de uma IE do Sergipe
    Retorna '' se ocorrer algum erro }
function _DV_IE_SE(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_SE(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_SE(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_IE_TO -> Retorna o dígito verificador de uma IE do Tocantins
    Retorna '' se ocorrer algum erro }
function _DV_IE_TO(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, tp, dg, dv1: Integer;
begin
  if (Len <> 10) then
  begin
    { É obrigatório que tenha 10 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 2);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  tp := 0;
  Inc(OutOf, 2);
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    tp := (tp * 10) + dg;

    Dec(Peso);
    Inc(Cursor);
  end;

  if ((tp <> 01) and (tp <> 02) and (tp <> 03) and (tp <> 99)) then
  begin
//      01 = Produtor Rural (não possui CGC)
//      02 = Industria e Comércio
//      03 = Empresas Rudimentares
//      99 = Empresas do Cadastro Antigo (SUSPENSAS)
    Exit(cDV1_Error);
  end;

  Inc(OutOf, 6);
  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_IE_TO(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_IE_TO(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

{ _DV_Suframa -> Calcula o dígito verificador do registro no suframa }
function _DV_Suframa(const S: PWideChar; const Len: Integer): TDV1;
var
  Cursor, OutOf: PWideChar;
  Peso: PByte;
  ac1, dg, dv1: Integer;
begin
  if (Len <> 8) then
  begin
    { É obrigatório que tenha 8 dígitos a IE sem o DV }
    Exit(cDV1_Error);
  end;

  Cursor := Pointer(S);
  OutOf := (Cursor + 8);
  Peso := @Pesos_9_2[High(Pesos_9_2)];

  ac1 := 0;

  while (Cursor < OutOf) do
  begin
    dg := (Ord(Cursor^) - Ord('0'));
    if (Cardinal(dg) > 9) then
    begin
      { Se chegou um caractere que não está entre '0' e '9' }
      Exit(cDV1_Error);
    end;

    Inc(ac1, (dg * Peso^));
    Dec(Peso);
    Inc(Cursor);
  end;

  dv1 := (11 - (ac1 mod 11));
  if (dv1 >= 10) then
    dv1 := 0;

  Exit(WideChar(Ord('0') + dv1));
end;

function Is_Suframa(const S: PWideChar; const Len: Integer): Boolean;
var
  DV: TDV1;
begin
  DV := _DV_Suframa(S, (Len - 1));
  Exit((Word(DV) <> 0) and StdCheckDV1(S, Len, DV));
end;

function Is_IE_AlwaysFalse(const S: PWideChar; const Len: Integer): Boolean;
begin
  Exit(False);
end;

const
  Table_fn_Is_IE_UF: array[TcrUF] of TIs_IE_UF_fn = (
    Is_IE_AlwaysFalse,      //  ufNenhum
    Is_IE_AC,               //  ufAC
    Is_IE_AL,               //  ufAL
    Is_IE_AM,               //  ufAM
    Is_IE_AP,               //  ufAP
    Is_IE_BA,               //  ufBA
    Is_IE_CE,               //  ufCE
    Is_IE_DF,               //  ufDF
    Is_IE_ES,               //  ufES
    Is_IE_GO,               //  ufGO
    Is_IE_MA,               //  ufMA
    Is_IE_MG,               //  ufMG
    Is_IE_MS,               //  ufMS
    Is_IE_MT,               //  ufMT
    Is_IE_PA,               //  ufPA
    Is_IE_PB,               //  ufPB
    Is_IE_PE,               //  ufPE
    Is_IE_PI,               //  ufPI
    Is_IE_PR,               //  ufPR
    Is_IE_RJ,               //  ufRJ
    Is_IE_RN,               //  ufRN
    Is_IE_RO,               //  ufRO
    Is_IE_RR,               //  ufRR
    Is_IE_RS,               //  ufRS
    Is_IE_SC,               //  ufSC
    Is_IE_SE,               //  ufSE
    Is_IE_SP,               //  ufSP
    Is_IE_TO                //  ufTO
  );

function TryGetUF(const S: UString; var AUF: TcrUF): Boolean;
var
  LUF: TcrUF;
  I: Integer;
begin
  if (Length(S) = 2) then
  begin
    LUF := _TrySiglaToUF(PcrUFSigla(@S[1])^);
    if (LUF <> TcrUF.ufNenhum) then
    begin
      AUF := LUF;
      Exit(True);
    end;
  end;

  if (TryStrToInt(S, I) and (Cardinal(I) <= High(UFFromIBGETable))) then
  begin
    LUF := UFFromIBGETable[I];
    if (LUF <> TcrUF.ufNenhum) then
    begin
      AUF := LUF;
      Exit(True);
    end;
  end;

  Exit(False);
end;

function TryGetUFByCStrA(S: PAnsiChar; var AUF: TcrUF): Boolean;
var
  I: Integer;
  LUF: TcrUF;
begin
  if ((UIntPtr(S) shr 16) <> 0) then
    Exit(TryGetUF(UString(S), AUF));

  I := IntPtr(S);
  if (Cardinal(I) <= High(UFFromIBGETable)) then
  begin
    LUF := UFFromIBGETable[I];
    if (LUF <> TcrUF.ufNenhum) then
    begin
      AUF := LUF;
      Exit(True);
    end;
  end;
  Exit(False);
end;

function TryGetUFByCStrW(S: PWideChar; var AUF: TcrUF): Boolean;
var
  I: Integer;
  LUF: TcrUF;
begin
  if ((UIntPtr(S) shr 16) <> 0) then
    Exit(TryGetUF(UString(S), AUF));

  I := IntPtr(S);
  if (Cardinal(I) <= High(UFFromIBGETable)) then
  begin
    LUF := UFFromIBGETable[I];
    if (LUF <> TcrUF.ufNenhum) then
    begin
      AUF := LUF;
      Exit(True);
    end;
  end;
  Exit(False);
end;

function IsValidIEByCStrA(S: PAnsiChar; const AUF: TcrUF): Boolean;
var
  T: UString;
begin
  if ((UIntPtr(S) shr 16) = 0) then
    Exit(False);

  T := UString(S);
  Exit((AUF < High(Table_fn_Is_IE_UF)) and
    Table_fn_Is_IE_UF[AUF](Pointer(T), Length(T)));
end;

function IsValidIEByCStrW(S: PWideChar; const AUF: TcrUF): Boolean;
begin
  if ((UIntPtr(S) shr 16) = 0) then
    Exit(False);

  Exit((AUF < High(Table_fn_Is_IE_UF)) and
    Table_fn_Is_IE_UF[AUF](S, Length(S)));
end;

function UFByStringA(S: PAnsiChar): TcrUF; stdcall;
begin
  if (not TryGetUFByCStrA(S, Result)) then
    Exit(TcrUF.ufNenhum);
end;

function UFByStringW(S: PWideChar): TcrUF; stdcall;
begin
  if (not TryGetUFByCStrW(S, Result)) then
    Exit(TcrUF.ufNenhum);
end;

function ConsisteInscricaoEstadual(const AIE, AUF: PAnsiChar): Integer; stdcall;
var
  LUF: TcrUF;
begin
  if (TryGetUFByCStrA(AUF, LUF) and IsValidIEByCStrA(AIE, LUF)) then
    Exit(0);

  Exit(-1);
end;

function ConsisteInscricaoEstadualW(
  const AIE, AUF: PWideChar): Integer; stdcall;
var
  LUF: TcrUF;
begin
  if (TryGetUFByCStrW(AUF, LUF) and IsValidIEByCStrW(AIE, LUF)) then
    Exit(0);

  Exit(-1);
end;

end.
