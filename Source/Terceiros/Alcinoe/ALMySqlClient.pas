{ *************************************************************
  www:          http://sourceforge.net/projects/alcinoe/
  svn:          svn checkout svn://svn.code.sf.net/p/alcinoe/code/ alcinoe-code
  Author(s):    St?phane Vander Clock (alcinoe@arkadia.com)
  Sponsor(s):   Arkadia SA (http://www.arkadia.com)

  product:      ALMySqlClient
  Version:      4.00

  Description:  An Object to query MySql Server Version 5 and get
  the Result In Xml Stream

  Legal issues: Copyright (C) 1999-2013 by Arkadia Software Engineering

  This software is provided 'as-is', without any express
  or implied warranty.  In no event will the author be
  held liable for any  damages arising from the use of
  this software.

  Permission is granted to anyone to use this software
  for any purpose, including commercial applications,
  and to alter it and redistribute it freely, subject
  to the following restrictions:

  1. The origin of this software must not be
  misrepresented, you must not claim that you wrote
  the original software. If you use this software in
  a product, an acknowledgment in the product
  documentation would be appreciated but is not
  required.

  2. Altered source versions must be plainly marked as
  such, and must not be misrepresented as being the
  original software.

  3. This notice may not be removed or altered from any
  source distribution.

  4. You must register this software by sending a picture
  postcard to the author. Use a nice stamp and mention
  your name, street address, EMail address and any
  comment you like to say.

  Know bug :    30/01/2008: Correct memory leak bug.

  History :     26/06/2012: Add xe2 support

  Link :        http://dev.mysql.com/doc/refman/5.0/en/
  http://dev.mysql.com/doc/refman/5.0/en/string-syntax.html

  * Please send all your feedback to alcinoe@arkadia.com
  * If you have downloaded this source from a website different from
  sourceforge.net, please get the last version on http://sourceforge.net/projects/alcinoe/
  * Please, help us to keep the development of these components free by
  promoting the sponsor on http://static.arkadia.com/html/alcinoe_like.html
  ************************************************************** }
unit AlMySqlClient;

interface

{$IF CompilerVersion >= 25} { Delphi XE4 }
{$LEGACYIFEND ON} // http://docwiki.embarcadero.com/RADStudio/XE4/en/Legacy_IFEND_(Delphi)
{$IFEND}

uses {$IF CompilerVersion >= 23} {Delphi XE2}
  Winapi.Windows,
  System.Contnrs,
  System.SyncObjs,
{$ELSE}
  Windows,
  Contnrs,
  SyncObjs,
{$IFEND}
  AlXmlDoc,
  ALStringList,
  ALString,
  AlMySqlWrapper;

Type

  { -------------------------------------- }
{$IF CompilerVersion >= 23} { Delphi XE2 }
  TalMySqlClientSelectDataOnNewRowFunct = reference to Procedure
    (XMLRowData: TalXmlNode; ViewTag: AnsiString; ExtData: Pointer;
    Var Continue: Boolean);
{$ELSE}
  TalMySqlClientSelectDataOnNewRowFunct = Procedure(XMLRowData: TalXmlNode;
    ViewTag: AnsiString; ExtData: Pointer; Var Continue: Boolean);
{$IFEND}

  { --------------------------------- }
  EALMySqlError = class(EALException)
  private
    FErrorCode: Integer;
    FSQLstate: AnsiString;
  public
    constructor Create(aErrorMsg: AnsiString; aErrorCode: Integer;
      aSqlState: AnsiString); overload;
    property ErrorCode: Integer read FErrorCode;
    property SQLState: AnsiString read FSQLstate;
  end;

  { ------------------------------------ }
  TalMySqlClientSelectDataQUERY = record
    SQL: AnsiString;
    RowTag: AnsiString;
    ViewTag: AnsiString;
    Skip: Integer; // used only if value is > 0
    First: Integer; // used only if value is > 0
    CacheThreshold: Integer;
    // The threshold value (in ms) determine whether we will use
    // cache or not. Values <= 0 deactivate the cache
    class function Create: TalMySqlClientSelectDataQUERY; static;
    {$IF CompilerVersion >= 17.0}inline; {$IFEND}
  end;

  TalMySqlClientSelectDataQUERIES = array of TalMySqlClientSelectDataQUERY;

  { ------------------------------------ }
  TalMySqlClientUpdateDataQUERY = record
    SQL: AnsiString;
    class function Create: TalMySqlClientUpdateDataQUERY; static;
    {$IF CompilerVersion >= 17.0}inline; {$IFEND}
  end;

  TalMySqlClientUpdateDataQUERIES = array of TalMySqlClientUpdateDataQUERY;

  { --------------------- }
  TALMySQLOption = record
    Option: TMySqlOption;
    Value: PANSIChar;
  end;

  TALMySQLOptions = array of TALMySQLOption;

  { ----------------------------- }
  TalMySqlClient = Class(Tobject)
  Private
    fLibrary: TALMySqlLibrary;
    FownLibrary: Boolean;
    fMySql: PMySql;
    fNullString: AnsiString;
    finTransaction: Boolean;
    fMySQLFormatSettings: TALFormatSettings;
    function GetConnected: Boolean;
    function GetInTransaction: Boolean;
  Protected
    procedure CheckAPIError(Error: Boolean);
    Function GetFieldValue(aFieldValue: PANSIChar; aFieldType: TMysqlFieldTypes;
      aFieldLength: Integer; aFormatSettings: TALFormatSettings): AnsiString;
    procedure initObject; virtual;
    procedure OnSelectDataDone(Query: TalMySqlClientSelectDataQUERY;
      TimeTaken: Integer); virtual;
    procedure OnUpdateDataDone(Query: TalMySqlClientUpdateDataQUERY;
      TimeTaken: Integer); virtual;
  Public
    Constructor Create(ApiVer: TALMySqlVersion_API;
      const lib: AnsiString = 'libmysql.dll'); overload; virtual;
    Constructor Create(lib: TALMySqlLibrary); overload; virtual;
    Destructor Destroy; Override;
    Procedure Connect(Host: AnsiString; Port: Integer;
      DataBaseName, Login, Password, CharSet: AnsiString;
      Const ClientFlag: Cardinal = 0;
      Const Options: TALMySQLOptions = nil); virtual;
    Procedure Disconnect;
    Procedure TransactionStart;
    Procedure TransactionCommit;
    Procedure TransactionRollback;
    Procedure SelectData(Queries: TalMySqlClientSelectDataQUERIES;
      XMLDATA: TalXmlNode; OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct;
      ExtData: Pointer; FormatSettings: TALFormatSettings); overload; virtual;
    Procedure SelectData(Query: TalMySqlClientSelectDataQUERY;
      OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct; ExtData: Pointer;
      FormatSettings: TALFormatSettings); overload; virtual;
    Procedure SelectData(SQL: AnsiString; Skip: Integer; First: Integer;
      OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct; ExtData: Pointer;
      FormatSettings: TALFormatSettings); overload; virtual;
    Procedure SelectData(SQL: AnsiString;
      OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct; ExtData: Pointer;
      FormatSettings: TALFormatSettings); overload; virtual;
    Procedure SelectData(Queries: TalMySqlClientSelectDataQUERIES;
      XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings);
      overload; virtual;
    Procedure SelectData(Query: TalMySqlClientSelectDataQUERY;
      XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings);
      overload; virtual;
    Procedure SelectData(SQL: AnsiString; RowTag: AnsiString; Skip: Integer;
      First: Integer; XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings);
      overload; virtual;
    Procedure SelectData(SQL: AnsiString; RowTag: AnsiString;
      XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings);
      overload; virtual;
    Procedure SelectData(SQL: AnsiString; XMLDATA: TalXmlNode;
      FormatSettings: TALFormatSettings); overload; virtual;
    procedure UpdateData(Queries: TalMySqlClientUpdateDataQUERIES);
      overload; virtual;
    procedure UpdateData(Query: TalMySqlClientUpdateDataQUERY);
      overload; virtual;
    procedure UpdateData(SQLs: TALStrings); overload; virtual;
    procedure UpdateData(SQL: AnsiString); overload; virtual;
    procedure UpdateData(SQLs: array of AnsiString); overload; virtual;
    function insert_id(SQL: AnsiString): ULongLong;
    Property Connected: Boolean Read GetConnected;
    Property InTransaction: Boolean read GetInTransaction;
    Property NullString: AnsiString Read fNullString Write fNullString;
    property lib: TALMySqlLibrary read fLibrary;
  end;

  { ---------------------------------------------- }
  TalMySqlConnectionPoolContainer = Class(Tobject)
    ConnectionHandle: PMySql;
    LastAccessDate: int64;
  End;

  { ------------------------------------------- }
  TalMySqlConnectionPoolClient = Class(Tobject)
  Private
    fLibrary: TALMySqlLibrary;
    FownLibrary: Boolean;
    FConnectionPool: TObjectList;
    FConnectionPoolCS: TCriticalSection;
    FWorkingConnectionCount: Integer;
    FReleasingAllconnections: Boolean;
    FLastConnectionGarbage: int64;
    FConnectionMaxIdleTime: Integer;
    FHost: AnsiString;
    FPort: Integer;
    FDataBaseName: AnsiString;
    fLogin: AnsiString;
    fPassword: AnsiString;
    fCharset: AnsiString;
    fOpenConnectionClientFlag: Cardinal;
    FOpenConnectionOptions: TALMySQLOptions;
    fNullString: AnsiString;
    fMySQLFormatSettings: TALFormatSettings;
  Protected
    procedure CheckAPIError(ConnectionHandle: PMySql; Error: Boolean);
    function GetDataBaseName: AnsiString; virtual;
    function GetHost: AnsiString; virtual;
    function GetPort: Integer; virtual;
    Function GetFieldValue(aFieldValue: PANSIChar; aFieldType: TMysqlFieldTypes;
      aFieldLength: Integer; aFormatSettings: TALFormatSettings): AnsiString;
    Function AcquireConnection: PMySql; virtual;
    Procedure ReleaseConnection(var ConnectionHandle: PMySql;
      const CloseConnection: Boolean = False); virtual;
    procedure initObject(aHost: AnsiString; aPort: Integer;
      aDataBaseName, aLogin, aPassword, aCharSet: AnsiString;
      Const aOpenConnectionClientFlag: Cardinal = 0;
      Const aOpenConnectionOptions: TALMySQLOptions = nil); virtual;
    procedure OnSelectDataDone(Query: TalMySqlClientSelectDataQUERY;
      TimeTaken: Integer); virtual;
    procedure OnUpdateDataDone(Query: TalMySqlClientUpdateDataQUERY;
      TimeTaken: Integer); virtual;
  Public
    Constructor Create(aHost: AnsiString; aPort: Integer;
      aDataBaseName, aLogin, aPassword, aCharSet: AnsiString;
      aApiVer: TALMySqlVersion_API; Const alib: AnsiString = 'libmysql.dll';
      Const aOpenConnectionClientFlag: Cardinal = 0;
      Const aOpenConnectionOptions: TALMySQLOptions = nil); overload; virtual;
    Constructor Create(aHost: AnsiString; aPort: Integer;
      aDataBaseName, aLogin, aPassword, aCharSet: AnsiString;
      alib: TALMySqlLibrary; Const aOpenConnectionClientFlag: Cardinal = 0;
      Const aOpenConnectionOptions: TALMySQLOptions = nil); overload; virtual;
    Destructor Destroy; Override;
    Procedure ReleaseAllConnections(Const WaitWorkingConnections
      : Boolean = True); virtual;
    Procedure TransactionStart(Var ConnectionHandle: PMySql); virtual;
    Procedure TransactionCommit(var ConnectionHandle: PMySql;
      const CloseConnection: Boolean = False); virtual;
    Procedure TransactionRollback(var ConnectionHandle: PMySql;
      const CloseConnection: Boolean = False); virtual;
    Procedure SelectData(Queries: TalMySqlClientSelectDataQUERIES;
      XMLDATA: TalXmlNode; OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct;
      ExtData: Pointer; FormatSettings: TALFormatSettings;
      const ConnectionHandle: PMySql = nil); overload; virtual;
    Procedure SelectData(Query: TalMySqlClientSelectDataQUERY;
      OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct; ExtData: Pointer;
      FormatSettings: TALFormatSettings; const ConnectionHandle: PMySql = nil);
      overload; virtual;
    Procedure SelectData(SQL: AnsiString; Skip: Integer; First: Integer;
      OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct; ExtData: Pointer;
      FormatSettings: TALFormatSettings; const ConnectionHandle: PMySql = nil);
      overload; virtual;
    Procedure SelectData(SQL: AnsiString;
      OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct; ExtData: Pointer;
      FormatSettings: TALFormatSettings; const ConnectionHandle: PMySql = nil);
      overload; virtual;
    Procedure SelectData(Queries: TalMySqlClientSelectDataQUERIES;
      XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings;
      const ConnectionHandle: PMySql = nil); overload; virtual;
    Procedure SelectData(Query: TalMySqlClientSelectDataQUERY;
      XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings;
      const ConnectionHandle: PMySql = nil); overload; virtual;
    Procedure SelectData(SQL: AnsiString; RowTag: AnsiString; Skip: Integer;
      First: Integer; XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings;
      const ConnectionHandle: PMySql = nil); overload; virtual;
    Procedure SelectData(SQL: AnsiString; RowTag: AnsiString;
      XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings;
      const ConnectionHandle: PMySql = nil); overload; virtual;
    Procedure SelectData(SQL: AnsiString; XMLDATA: TalXmlNode;
      FormatSettings: TALFormatSettings; const ConnectionHandle: PMySql = nil);
      overload; virtual;
    procedure UpdateData(Queries: TalMySqlClientUpdateDataQUERIES;
      const ConnectionHandle: PMySql = nil); overload; virtual;
    procedure UpdateData(Query: TalMySqlClientUpdateDataQUERY;
      const ConnectionHandle: PMySql = nil); overload; virtual;
    procedure UpdateData(SQLs: TALStrings;
      const ConnectionHandle: PMySql = nil); overload; virtual;
    procedure UpdateData(SQL: AnsiString; const ConnectionHandle: PMySql = nil);
      overload; virtual;
    procedure UpdateData(SQLs: array of AnsiString;
      const ConnectionHandle: PMySql = nil); overload; virtual;
    Function insert_id(SQL: AnsiString; const ConnectionHandle: PMySql = nil)
      : ULongLong; virtual;
    Function ConnectionCount: Integer;
    Function WorkingConnectionCount: Integer;
    property DataBaseName: AnsiString read GetDataBaseName;
    property Host: AnsiString read GetHost;
    property Port: Integer read GetPort;
    property ConnectionMaxIdleTime: Integer read FConnectionMaxIdleTime
      write FConnectionMaxIdleTime;
    Property NullString: AnsiString Read fNullString Write fNullString;
    property lib: TALMySqlLibrary read fLibrary;
  end;

Function AlMySqlClientSlashedStr(Const Str: AnsiString): AnsiString;

implementation

uses {$IF CompilerVersion >= 23} {Delphi XE2}
  System.Classes,
  System.SysUtils,
  System.Diagnostics,
{$ELSE}
  Classes,
  SysUtils,
  Diagnostics,
{$IFEND}
  ALWindows;

{ ********************************************************************************* }
class function TalMySqlClientSelectDataQUERY.Create
  : TalMySqlClientSelectDataQUERY;
begin
  with result do
  begin
    SQL := '';
    RowTag := '';
    ViewTag := '';
    Skip := -1;
    First := -1;
    CacheThreshold := -1;
  end;
end;

{ ********************************************************************************* }
class function TalMySqlClientUpdateDataQUERY.Create
  : TalMySqlClientUpdateDataQUERY;
begin
  with result do
  begin
    SQL := '';
  end;
end;

{ ****************************************************************** }
Function AlMySqlClientSlashedStr(Const Str: AnsiString): AnsiString;
var
  I: Integer;
begin
  result := Str;
  for I := Length(result) downto 1 do
    if result[I] in ['''', '"', '\', #0] then
      Insert('\', result, I);
  result := '''' + result + '''';
end;

{ ***************************************************** }
constructor EALMySqlError.Create(aErrorMsg: AnsiString; aErrorCode: Integer;
  aSqlState: AnsiString);
begin
  FErrorCode := aErrorCode;
  FSQLstate := aSqlState;
  inherited Create(aErrorMsg);
end;

{ ******************************************** }
function TalMySqlClient.GetConnected: Boolean;
begin
  result := assigned(fMySql);
end;

{ ************************************************ }
function TalMySqlClient.GetInTransaction: Boolean;
begin
  result := finTransaction;
end;

{ ***************************************************** }
procedure TalMySqlClient.CheckAPIError(Error: Boolean);
Begin
  if Error then
  begin
    if assigned(fMySql) then
      raise EALMySqlError.Create(fLibrary.mysql_error(fMySql),
        fLibrary.mysql_errno(fMySql), fLibrary.mysql_SqlState(fMySql))
    else
      raise EALMySqlError.Create('MySql error', -1, 'HY000');
    // The value 'HY000' (general error) is used for unmapped error numbers.
  end;
end;

{ *********************************************************** }
function TalMySqlClient.GetFieldValue(aFieldValue: PANSIChar;
  aFieldType: TMysqlFieldTypes; aFieldLength: Integer;
  aFormatSettings: TALFormatSettings): AnsiString;
begin
  // The lengths of the field values in the row may be obtained by calling mysql_fetch_lengths().
  // Empty fields and fields containing NULL both have length 0; you can distinguish these
  // by checking the pointer for the field value. If the pointer is NULL, the field
  // is NULL; otherwise, the field is empty.
  IF aFieldValue = nil then
    result := fNullString
  else
  begin
    Case aFieldType of
      FIELD_TYPE_DECIMAL, FIELD_TYPE_NEWDECIMAL, FIELD_TYPE_FLOAT,
        FIELD_TYPE_DOUBLE:
        result := ALFloatToStr(ALStrToFloat(aFieldValue, fMySQLFormatSettings),
          aFormatSettings);
      FIELD_TYPE_DATETIME:
        result := ALDateTimeToStr(ALStrToDateTime(aFieldValue,
          fMySQLFormatSettings), aFormatSettings);
      FIELD_TYPE_DATE, FIELD_TYPE_NEWDATE:
        result := ALDateToStr(ALStrToDate(aFieldValue, fMySQLFormatSettings),
          aFormatSettings);
      FIELD_TYPE_TIME:
        result := ALTimeToStr(ALStrToTime(aFieldValue, fMySQLFormatSettings),
          aFormatSettings);
      FIELD_TYPE_TIMESTAMP:
        result := ALDateTimeToStr(ALStrToDateTime(aFieldValue,
          fMySQLFormatSettings), aFormatSettings);
      FIELD_TYPE_NULL:
        result := fNullString; // Example: SELECT NULL FROM DUAL
    Else
      SetString(result, aFieldValue, aFieldLength);
    end;
  end;
end;

{ ********************************** }
procedure TalMySqlClient.initObject;
begin
  fMySql := nil;
  finTransaction := False;
  fNullString := '';
  ALGetLocaleFormatSettings(1033, fMySQLFormatSettings);
  fMySQLFormatSettings.DecimalSeparator := '.';
  fMySQLFormatSettings.ThousandSeparator := ',';
  fMySQLFormatSettings.DateSeparator := '-';
  fMySQLFormatSettings.TimeSeparator := ':';
  fMySQLFormatSettings.ShortDateFormat := 'yyyy/mm/dd';
  fMySQLFormatSettings.ShortTimeFormat := 'hh:nn:ss';
end;

{ ************************************************************ }
constructor TalMySqlClient.Create(ApiVer: TALMySqlVersion_API;
  const lib: AnsiString = 'libmysql.dll');
begin
  fLibrary := TALMySqlLibrary.Create(ApiVer);
  try
    fLibrary.Load(lib);
    FownLibrary := True;
    initObject;
  Except
    fLibrary.free;
    raise;
  end;
end;

{ ****************************************************** }
constructor TalMySqlClient.Create(lib: TALMySqlLibrary);
begin
  fLibrary := lib;
  FownLibrary := False;
  initObject;
end;

{ ******************************** }
destructor TalMySqlClient.Destroy;
begin
  If Connected then
    Disconnect;
  if FownLibrary then
    fLibrary.free;
  inherited;
end;

{ *************************************************************
  http://dev.mysql.com/doc/refman/5.1/en/mysql-real-connect.html }
procedure TalMySqlClient.Connect(Host: AnsiString; Port: Integer;
  DataBaseName, Login, Password, CharSet: AnsiString;
  Const ClientFlag: Cardinal = 0; const Options: TALMySQLOptions = nil);
var
  I: Integer;
begin
  if Connected then
    raise Exception.Create('Already connected');

  // This function must be called early within each
  // created thread to initialize thread-specific variables
  // this look very important because if we comment this and
  // the mysql_thread_end then the Flibrary.unload can take several seconds
  // you can see this in the ALSQLBenchmark.exe project with the loop update button
  CheckAPIError(fLibrary.mysql_thread_init <> 0);
  Try

    // Allocates or initializes a MYSQL object suitable for mysql_real_connect()
    fMySql := fLibrary.mysql_init(nil);
    CheckAPIError(fMySql = nil);

    // set the The name of the character set to use as the default character set.
    If (CharSet <> '') then
      CheckAPIError(fLibrary.mysql_options(fMySql, MYSQL_SET_CHARSET_NAME,
        PANSIChar(CharSet)) <> 0);

    // set the options if they are existing
    for I := 0 to Length(Options) - 1 do
      CheckAPIError(fLibrary.mysql_options(fMySql, Options[I].Option,
        Options[I].Value) <> 0);

    // attempts to establish a connection to a MySQL database engine running on host
    CheckAPIError(fLibrary.mysql_real_connect(fMySql, PANSIChar(Host),
      PANSIChar(Login), PANSIChar(Password), PANSIChar(DataBaseName), Port, nil,
      ClientFlag) = nil);

  Except

    // close the FMySql and free memory allocated by mysql_thread_init().
    if assigned(fMySql) then
      fLibrary.MySql_close(fMySql);
    fLibrary.mysql_thread_end;
    fMySql := nil;
    Raise;

  End;
end;

{ ********************************** }
procedure TalMySqlClient.Disconnect;
begin
  If not Connected then
    exit;
  if InTransaction then
    TransactionRollback;
  try

    // close the FMySql and free memory allocated by mysql_thread_init().
    fLibrary.MySql_close(fMySql);
    fLibrary.mysql_thread_end;

  Except
    // Disconnect must be a "safe" procedure because it's mostly called in
    // finalization part of the code that it is not protected
  End;
  fMySql := Nil;
end;

{ **************************************** }
procedure TalMySqlClient.TransactionStart;
begin

  // Error if we are not connected
  If not Connected then
    raise Exception.Create('Not connected');
  if InTransaction then
    raise Exception.Create('Another transaction is active');

  // execute the query
  UpdateData('START TRANSACTION');
  finTransaction := True;

end;

{ ***************************************** }
procedure TalMySqlClient.TransactionCommit;
begin

  // Error if we are not connected
  if not InTransaction then
    raise Exception.Create('No active transaction to commit');

  // Execute the Query
  UpdateData('COMMIT');
  finTransaction := False;

end;

{ ******************************************* }
procedure TalMySqlClient.TransactionRollback;
begin

  // Error if we are not connected
  if not InTransaction then
    raise Exception.Create('No active transaction to rollback');

  // Execute the Query
  Try
    UpdateData('ROLLBACK');
  Except
    // some error can happen if the network go down for exemple
    // i don't really know what to do in this case of error
    // but what else we can do ? commit => exept => rollback => except ???
  End;
  finTransaction := False;

end;

{ ***************************************************************************** }
procedure TalMySqlClient.OnSelectDataDone(Query: TalMySqlClientSelectDataQUERY;
  TimeTaken: Integer);
begin
  // virtual
end;

{ ***************************************************************************** }
procedure TalMySqlClient.OnUpdateDataDone(Query: TalMySqlClientUpdateDataQUERY;
  TimeTaken: Integer);
begin
  // virtual
end;

{ *************************************************************************** }
procedure TalMySqlClient.SelectData(Queries: TalMySqlClientSelectDataQUERIES;
  XMLDATA: TalXmlNode; OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct;
  ExtData: Pointer; FormatSettings: TALFormatSettings);
Var
  aMySqlRes: PMYSQL_RES;
  aMySqlRow: PMYSQL_ROW;
  aMySqlFields: array of PMYSQL_FIELD;
  aMySqlFieldLengths: PMYSQL_LENGTHS;
  aColumnCount: Integer;
  aColumnIndex: Integer;
  aNewRec: TalXmlNode;
  aValueRec: TalXmlNode;
  aViewRec: TalXmlNode;
  aQueriesIndex: Integer;
  aRecIndex: Integer;
  aRecAdded: Integer;
  aContinue: Boolean;
  aXmlDocument: TalXmlDocument;
  aUpdateRowTagByFieldValue: Boolean;
  aStopWatch: TStopWatch;

begin

  // exit if no SQL
  if Length(Queries) = 0 then
    exit;

  // Error if we are not connected
  If not Connected then
    raise Exception.Create('Not connected');

  // only OnNewRowFunct / XMLDATA can be used
  if assigned(OnNewRowFunct) then
    XMLDATA := nil;

  // clear the XMLDATA
  if assigned(XMLDATA) then
    aXmlDocument := Nil
  else
  begin
    aXmlDocument := TalXmlDocument.Create('root');
    XMLDATA := aXmlDocument.DocumentElement;
  end;

  Try

    // init the TstopWatch
    aStopWatch := TStopWatch.Create;

    { loop on all the SQL }
    For aQueriesIndex := 0 to Length(Queries) - 1 do
    begin

      // start the TstopWatch
      aStopWatch.Reset;
      aStopWatch.Start;

      // prepare the query
      CheckAPIError(fLibrary.mysql_real_query(fMySql,
        PANSIChar(Queries[aQueriesIndex].SQL),
        Length(Queries[aQueriesIndex].SQL)) <> 0);
      aMySqlRes := fLibrary.mysql_use_result(fMySql);
      CheckAPIError(aMySqlRes = nil);
      Try

        // Returns the number of columns in a result set.
        aColumnCount := fLibrary.mysql_num_fields(aMySqlRes);

        // init the aMySqlFields array
        // this not work anymore in MYSQL5.5, i don't know why so i use mysql_fetch_field instead
        // aMySqlFields := fLibrary.mysql_fetch_fields(aMySqlRes);
        setlength(aMySqlFields, aColumnCount);
        for aColumnIndex := 0 to aColumnCount - 1 do
          aMySqlFields[aColumnIndex] := fLibrary.mysql_fetch_field(aMySqlRes);

        // init the aViewRec
        if (Queries[aQueriesIndex].ViewTag <> '') and
          (not assigned(aXmlDocument)) then
          aViewRec := XMLDATA.AddChild(Queries[aQueriesIndex].ViewTag)
        else
          aViewRec := XMLDATA;

        // init aUpdateRowTagByFieldValue
        if AlPos('&>', Queries[aQueriesIndex].RowTag) = 1 then
        begin
          delete(Queries[aQueriesIndex].RowTag, 1, 2);
          aUpdateRowTagByFieldValue := Queries[aQueriesIndex].RowTag <> '';
        end
        else
          aUpdateRowTagByFieldValue := False;

        // loop throught all row
        aRecIndex := 0;
        aRecAdded := 0;
        while True do
        begin

          // retrieve the next row. return A MYSQL_ROW structure for the next row.
          // NULL if there are no more rows to retrieve or if an error occurred.
          aMySqlRow := fLibrary.mysql_fetch_row(aMySqlRes);

          // break if no more row
          if aMySqlRow = nil then
          begin
            CheckAPIError(fLibrary.mysql_errno(fMySql) <> 0);
            break;
          end

          // download the row
          else
          begin

            // process if > Skip
            inc(aRecIndex);
            If aRecIndex > Queries[aQueriesIndex].Skip then
            begin

              // init NewRec
              if (Queries[aQueriesIndex].RowTag <> '') and
                (not assigned(aXmlDocument)) then
                aNewRec := aViewRec.AddChild(Queries[aQueriesIndex].RowTag)
              Else
                aNewRec := aViewRec;

              // init aMySqlFieldLengths
              aMySqlFieldLengths := fLibrary.mysql_fetch_lengths(aMySqlRes);
              CheckAPIError(aMySqlFieldLengths = nil);

              // loop throught all column
              For aColumnIndex := 0 to aColumnCount - 1 do
              begin
                aValueRec := aNewRec.AddChild
                  (ALlowercase(aMySqlFields[aColumnIndex].name));
                if (aMySqlFields[aColumnIndex]._type in [FIELD_TYPE_TINY_BLOB,
                  FIELD_TYPE_MEDIUM_BLOB, FIELD_TYPE_LONG_BLOB, FIELD_TYPE_BLOB])
                then
                  aValueRec.ChildNodes.Add
                    (aValueRec.OwnerDocument.CreateNode
                    (GetFieldValue(aMySqlRow[aColumnIndex],
                    aMySqlFields[aColumnIndex]._type,
                    aMySqlFieldLengths[aColumnIndex], FormatSettings), ntCData))
                else
                  aValueRec.Text := GetFieldValue(aMySqlRow[aColumnIndex],
                    aMySqlFields[aColumnIndex]._type,
                    aMySqlFieldLengths[aColumnIndex], FormatSettings);
                if aUpdateRowTagByFieldValue and
                  (aValueRec.NodeName = aNewRec.NodeName) then
                  aNewRec.NodeName := ALlowercase(aValueRec.Text);
              end;

              // handle OnNewRowFunct
              if assigned(OnNewRowFunct) then
              begin
                aContinue := True;
                OnNewRowFunct(aNewRec, Queries[aQueriesIndex].ViewTag, ExtData,
                  aContinue);
                if Not aContinue then
                  break;
              end;

              // free the node if aXmlDocument
              if assigned(aXmlDocument) then
                aXmlDocument.DocumentElement.ChildNodes.Clear;

              // handle the First
              inc(aRecAdded);
              If (Queries[aQueriesIndex].First > 0) and
                (aRecAdded >= Queries[aQueriesIndex].First) then
                break;

            end;

          end;

        end;

      Finally
        // Frees the memory allocated to aMySqlRes
        fLibrary.mysql_free_result(aMySqlRes);
      End;

      // do the OnSelectDataDone
      aStopWatch.Stop;
      OnSelectDataDone(Queries[aQueriesIndex], aStopWatch.ElapsedMilliseconds);

    End;

  Finally
    if assigned(aXmlDocument) then
      aXmlDocument.free;
  End;

end;

{ *********************************************************************** }
procedure TalMySqlClient.SelectData(Query: TalMySqlClientSelectDataQUERY;
  OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct; ExtData: Pointer;
  FormatSettings: TALFormatSettings);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := Query;
  SelectData(aSelectDataQUERIES, nil, OnNewRowFunct, ExtData, FormatSettings);
end;

{ ************************************************** }
procedure TalMySqlClient.SelectData(SQL: AnsiString; Skip: Integer;
  First: Integer; OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct;
  ExtData: Pointer; FormatSettings: TALFormatSettings);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := TalMySqlClientSelectDataQUERY.Create;
  aSelectDataQUERIES[0].SQL := SQL;
  aSelectDataQUERIES[0].Skip := Skip;
  aSelectDataQUERIES[0].First := First;
  SelectData(aSelectDataQUERIES, nil, OnNewRowFunct, ExtData, FormatSettings);
end;

{ ************************************************** }
procedure TalMySqlClient.SelectData(SQL: AnsiString;
  OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct; ExtData: Pointer;
  FormatSettings: TALFormatSettings);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := TalMySqlClientSelectDataQUERY.Create;
  aSelectDataQUERIES[0].SQL := SQL;
  SelectData(aSelectDataQUERIES, nil, OnNewRowFunct, ExtData, FormatSettings);
end;

{ *************************************************************************** }
procedure TalMySqlClient.SelectData(Queries: TalMySqlClientSelectDataQUERIES;
  XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings);
begin

  SelectData(Queries, XMLDATA, nil, nil, FormatSettings);

end;

{ *********************************************************************** }
procedure TalMySqlClient.SelectData(Query: TalMySqlClientSelectDataQUERY;
  XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := Query;
  SelectData(aSelectDataQUERIES, XMLDATA, nil, nil, FormatSettings);
end;

{ ************************************************** }
procedure TalMySqlClient.SelectData(SQL: AnsiString; RowTag: AnsiString;
  Skip: Integer; First: Integer; XMLDATA: TalXmlNode;
  FormatSettings: TALFormatSettings);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := TalMySqlClientSelectDataQUERY.Create;
  aSelectDataQUERIES[0].SQL := SQL;
  aSelectDataQUERIES[0].RowTag := RowTag;
  aSelectDataQUERIES[0].Skip := Skip;
  aSelectDataQUERIES[0].First := First;
  SelectData(aSelectDataQUERIES, XMLDATA, nil, nil, FormatSettings);
end;

{ ************************************************** }
procedure TalMySqlClient.SelectData(SQL: AnsiString; RowTag: AnsiString;
  XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := TalMySqlClientSelectDataQUERY.Create;
  aSelectDataQUERIES[0].SQL := SQL;
  aSelectDataQUERIES[0].RowTag := RowTag;
  SelectData(aSelectDataQUERIES, XMLDATA, nil, nil, FormatSettings);
end;

{ ************************************************** }
procedure TalMySqlClient.SelectData(SQL: AnsiString; XMLDATA: TalXmlNode;
  FormatSettings: TALFormatSettings);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := TalMySqlClientSelectDataQUERY.Create;
  aSelectDataQUERIES[0].SQL := SQL;
  SelectData(aSelectDataQUERIES, XMLDATA, nil, nil, FormatSettings);
end;

{ **************************************************************************** }
procedure TalMySqlClient.UpdateData(Queries: TalMySqlClientUpdateDataQUERIES);
Var
  aQueriesIndex: Integer;
  aStopWatch: TStopWatch;
begin

  // exit if no SQL
  if Length(Queries) = 0 then
    exit;

  // Error if we are not connected
  If not Connected then
    raise Exception.Create('Not connected');

  // init the TstopWatch
  aStopWatch := TStopWatch.Create;

  // loop on all the SQL
  For aQueriesIndex := 0 to Length(Queries) - 1 do
  begin

    // start the TstopWatch
    aStopWatch.Reset;
    aStopWatch.Start;

    // do the query
    CheckAPIError(fLibrary.mysql_real_query(fMySql,
      PANSIChar(Queries[aQueriesIndex].SQL),
      Length(Queries[aQueriesIndex].SQL)) <> 0);

    // do the OnUpdateDataDone
    aStopWatch.Stop;
    OnUpdateDataDone(Queries[aQueriesIndex], aStopWatch.ElapsedMilliseconds);

  end;

end;

{ ************************************************************************ }
procedure TalMySqlClient.UpdateData(Query: TalMySqlClientUpdateDataQUERY);
Var
  aUpdateDataQUERIES: TalMySqlClientUpdateDataQUERIES;
begin
  setlength(aUpdateDataQUERIES, 1);
  aUpdateDataQUERIES[0] := Query;
  UpdateData(aUpdateDataQUERIES);
end;

{ **************************************************** }
procedure TalMySqlClient.UpdateData(SQLs: TALStrings);
Var
  aSQLsIndex: Integer;
  aUpdateDataQUERIES: TalMySqlClientUpdateDataQUERIES;
begin
  setlength(aUpdateDataQUERIES, SQLs.Count);
  For aSQLsIndex := 0 to SQLs.Count - 1 do
  begin
    aUpdateDataQUERIES[aSQLsIndex] := TalMySqlClientUpdateDataQUERY.Create;
    aUpdateDataQUERIES[aSQLsIndex].SQL := SQLs[aSQLsIndex];
  end;
  UpdateData(aUpdateDataQUERIES);
end;

{ *************************************************** }
procedure TalMySqlClient.UpdateData(SQL: AnsiString);
Var
  aUpdateDataQUERIES: TalMySqlClientUpdateDataQUERIES;
begin
  setlength(aUpdateDataQUERIES, 1);
  aUpdateDataQUERIES[0] := TalMySqlClientUpdateDataQUERY.Create;
  aUpdateDataQUERIES[0].SQL := SQL;
  UpdateData(aUpdateDataQUERIES);
end;

{ ************************************************************* }
procedure TalMySqlClient.UpdateData(SQLs: array of AnsiString);
Var
  aUpdateDataQUERIES: TalMySqlClientUpdateDataQUERIES;
  I: Integer;
begin
  setlength(aUpdateDataQUERIES, Length(SQLs));
  for I := 0 to Length(SQLs) - 1 do
  begin
    aUpdateDataQUERIES[I] := TalMySqlClientUpdateDataQUERY.Create;
    aUpdateDataQUERIES[I].SQL := SQLs[I];
  end;
  UpdateData(aUpdateDataQUERIES);
end;

{ ************************************************************ }
function TalMySqlClient.insert_id(SQL: AnsiString): ULongLong;
begin

  // if the SQL is not empty
  if SQL <> '' then
  begin

    // Execute the Query
    UpdateData(SQL);

    // Returns the value generated for an AUTO_INCREMENT column
    // by the previous INSERT or UPDATE statement
    result := fLibrary.mysql_insert_id(fMySql);

  end

  // else simply gave an 0 result
  else
    result := 0;

end;

{ ******* }
ThreadVar vAlMySqlConnectionPoolClientThreadInitRefCount: Integer;

{ ********************************************************************************************* }
procedure TalMySqlConnectionPoolClient.CheckAPIError(ConnectionHandle: PMySql;
  Error: Boolean);
begin
  if Error then
  begin
    if assigned(ConnectionHandle) then
      raise EALMySqlError.Create(fLibrary.mysql_error(ConnectionHandle),
        fLibrary.mysql_errno(ConnectionHandle),
        fLibrary.mysql_SqlState(ConnectionHandle))
    else
      raise EALMySqlError.Create('MySql error', -1, 'HY000');
    // The value 'HY000' (general error) is used for unmapped error numbers.
  end;
end;

{ **************************************************************** }
function TalMySqlConnectionPoolClient.GetDataBaseName: AnsiString;
begin
  result := FDataBaseName;
end;

{ ******************************************************** }
function TalMySqlConnectionPoolClient.GetHost: AnsiString;
begin
  result := FHost;
end;

{ ***************************************************** }
function TalMySqlConnectionPoolClient.GetPort: Integer;
begin
  result := FPort;
end;

{ ************************************************************************* }
function TalMySqlConnectionPoolClient.GetFieldValue(aFieldValue: PANSIChar;
  aFieldType: TMysqlFieldTypes; aFieldLength: Integer;
  aFormatSettings: TALFormatSettings): AnsiString;
begin
  // The lengths of the field values in the row may be obtained by calling mysql_fetch_lengths().
  // Empty fields and fields containing NULL both have length 0; you can distinguish these
  // by checking the pointer for the field value. If the pointer is NULL, the field
  // is NULL; otherwise, the field is empty.
  IF aFieldValue = nil then
    result := fNullString
  else
  begin
    Case aFieldType of
      FIELD_TYPE_DECIMAL, FIELD_TYPE_NEWDECIMAL, FIELD_TYPE_FLOAT,
        FIELD_TYPE_DOUBLE:
        result := ALFloatToStr(ALStrToFloat(aFieldValue, fMySQLFormatSettings),
          aFormatSettings);
      FIELD_TYPE_DATETIME:
        result := ALDateTimeToStr(ALStrToDateTime(aFieldValue,
          fMySQLFormatSettings), aFormatSettings);
      FIELD_TYPE_DATE, FIELD_TYPE_NEWDATE:
        result := ALDateToStr(ALStrToDate(aFieldValue, fMySQLFormatSettings),
          aFormatSettings);
      FIELD_TYPE_TIME:
        result := ALTimeToStr(ALStrToTime(aFieldValue, fMySQLFormatSettings),
          aFormatSettings);
      FIELD_TYPE_TIMESTAMP:
        result := ALDateTimeToStr(ALStrToDateTime(aFieldValue,
          fMySQLFormatSettings), aFormatSettings);
      FIELD_TYPE_NULL:
        result := fNullString; // Example: SELECT NULL FROM DUAL
    Else
      SetString(result, aFieldValue, aFieldLength);
    end;
  end;
end;

{ ****************************************************************** }
procedure TalMySqlConnectionPoolClient.initObject(aHost: AnsiString;
  aPort: Integer; aDataBaseName, aLogin, aPassword, aCharSet: AnsiString;
  Const aOpenConnectionClientFlag: Cardinal = 0;
  Const aOpenConnectionOptions: TALMySQLOptions = nil);
begin
  FHost := aHost;
  FPort := aPort;
  FDataBaseName := aDataBaseName;
  fLogin := aLogin;
  fPassword := aPassword;
  fCharset := aCharSet;
  fOpenConnectionClientFlag := aOpenConnectionClientFlag;
  FOpenConnectionOptions := aOpenConnectionOptions;
  FConnectionPool := TObjectList.Create(True);
  FConnectionPoolCS := TCriticalSection.Create;
  FWorkingConnectionCount := 0;
  FReleasingAllconnections := False;
  FLastConnectionGarbage := ALGettickCount64;
  FConnectionMaxIdleTime := 1200000; // 1000 * 60 * 20 = 20 min
  fNullString := '';
  ALGetLocaleFormatSettings(1033, fMySQLFormatSettings);
  fMySQLFormatSettings.DecimalSeparator := '.';
  fMySQLFormatSettings.ThousandSeparator := ',';
  fMySQLFormatSettings.DateSeparator := '-';
  fMySQLFormatSettings.TimeSeparator := ':';
  fMySQLFormatSettings.ShortDateFormat := 'yyyy/mm/dd';
  fMySQLFormatSettings.ShortTimeFormat := 'hh:nn:ss';
end;

{ **************************************************************** }
constructor TalMySqlConnectionPoolClient.Create(aHost: AnsiString;
  aPort: Integer; aDataBaseName, aLogin, aPassword, aCharSet: AnsiString;
  aApiVer: TALMySqlVersion_API; Const alib: AnsiString = 'libmysql.dll';
  Const aOpenConnectionClientFlag: Cardinal = 0;
  Const aOpenConnectionOptions: TALMySQLOptions = nil);
begin
  fLibrary := TALMySqlLibrary.Create(aApiVer);
  Try
    fLibrary.Load(alib);
    FownLibrary := True;
    initObject(aHost, aPort, aDataBaseName, aLogin, aPassword, aCharSet,
      aOpenConnectionClientFlag, aOpenConnectionOptions);
  except
    fLibrary.free;
    raise;
  End;
end;

{ **************************************************************** }
constructor TalMySqlConnectionPoolClient.Create(aHost: AnsiString;
  aPort: Integer; aDataBaseName, aLogin, aPassword, aCharSet: AnsiString;
  alib: TALMySqlLibrary; Const aOpenConnectionClientFlag: Cardinal = 0;
  Const aOpenConnectionOptions: TALMySQLOptions = nil);
begin
  fLibrary := alib;
  FownLibrary := False;
  initObject(aHost, aPort, aDataBaseName, aLogin, aPassword, aCharSet,
    aOpenConnectionClientFlag, aOpenConnectionOptions);
end;

{ ********************************************** }
destructor TalMySqlConnectionPoolClient.Destroy;
begin

  // Release all connections
  ReleaseAllConnections;

  // free object
  FConnectionPool.free;
  FConnectionPoolCS.free;
  if FownLibrary then
    fLibrary.free;

  // inherite
  inherited;

end;

{ ************************************************************** }
function TalMySqlConnectionPoolClient.AcquireConnection: PMySql;
Var
  aConnectionPoolContainer: TalMySqlConnectionPoolContainer;
  aTickCount: int64;
  I: Integer;
Begin

  // for a stupid warning
  result := nil;

  // synchronize the code
  FConnectionPoolCS.Acquire;
  Try

    // This function must be called early within each
    // created thread to initialize thread-specific variables
    // this look very important because if we comment this and
    // the mysql_thread_end then the Flibrary.unload can take several seconds
    // you can see this in the ALSQLBenchmark.exe project with the loop update button
    // http://dev.mysql.com/doc/refman/5.6/en/threaded-clients.html
    CheckAPIError(Nil, fLibrary.mysql_thread_init <> 0);
    inc(vAlMySqlConnectionPoolClientThreadInitRefCount);
    Try

      // raise an exception if currently realeasing all connection
      if FReleasingAllconnections then
        raise Exception.Create
          ('Can not acquire connection: currently releasing all connections');

      // delete the old unused connection
      aTickCount := ALGettickCount64;
      if aTickCount - FLastConnectionGarbage > (60000 { every minutes } ) then
      begin
        while FConnectionPool.Count > 0 do
        begin
          aConnectionPoolContainer := TalMySqlConnectionPoolContainer
            (FConnectionPool[0]);
          if aTickCount - aConnectionPoolContainer.LastAccessDate > FConnectionMaxIdleTime
          then
          begin
            Try
              fLibrary.MySql_close(aConnectionPoolContainer.ConnectionHandle);
            Except
              // Disconnect must be a "safe" procedure because it's mostly called in
              // finalization part of the code that it is not protected
              // that the bulsheet of MySql to answer SQLITE_BUSY instead of free
              // everything
            End;
            FConnectionPool.delete(0);
            // must be delete here because FConnectionPool free the object also
          end
          else
            break;
        end;
        FLastConnectionGarbage := aTickCount;
      end;

      // acquire the new connection from the pool
      If FConnectionPool.Count > 0 then
      begin
        aConnectionPoolContainer := TalMySqlConnectionPoolContainer
          (FConnectionPool[FConnectionPool.Count - 1]);
        result := aConnectionPoolContainer.ConnectionHandle;
        FConnectionPool.delete(FConnectionPool.Count - 1);
      end

      // create a new connection
      else
      begin
        result := nil;
        Try

          // Allocates or initializes a MYSQL object suitable for mysql_real_connect()
          result := fLibrary.mysql_init(nil);
          CheckAPIError(nil, result = nil);

          // set the The name of the character set to use as the default character set.
          If (fCharset <> '') then
            CheckAPIError(result, fLibrary.mysql_options(result,
              MYSQL_SET_CHARSET_NAME, PANSIChar(fCharset)) <> 0);

          // set the options if they are existing
          for I := 0 to Length(FOpenConnectionOptions) - 1 do
            CheckAPIError(result, fLibrary.mysql_options(result,
              FOpenConnectionOptions[I].Option,
              FOpenConnectionOptions[I].Value) <> 0);

          // attempts to establish a connection to a MySQL database engine running on host
          CheckAPIError(result, fLibrary.mysql_real_connect(result,
            PANSIChar(Host), PANSIChar(fLogin), PANSIChar(fPassword),
            PANSIChar(FDataBaseName), Port, nil,
            fOpenConnectionClientFlag) = nil);

        Except

          // close the FMySql
          if assigned(result) then
            fLibrary.MySql_close(result);
          Raise;

        End;
      end;

      // increase the connection count
      inc(FWorkingConnectionCount);

    Except

      // free memory allocated by mysql_thread_init().
      dec(vAlMySqlConnectionPoolClientThreadInitRefCount);
      if vAlMySqlConnectionPoolClientThreadInitRefCount = 0 then
        fLibrary.mysql_thread_end;
      Raise;

    End;

    // get out of the synchronization
  finally
    FConnectionPoolCS.Release;
  end;

End;

{ *************************************************************************************** }
{ Applications must finalize all prepared statements and close all BLOB handles associated
  with the MySql object prior to attempting to close the object. If MySql_close() is
  called on a database connection that still has outstanding prepared statements or
  BLOB handles, then it returns SQLITE_BUSY.
  If MySql_close() is invoked while a transaction is open, the transaction is
  automatically rolled back. }
procedure TalMySqlConnectionPoolClient.ReleaseConnection(var ConnectionHandle
  : PMySql; const CloseConnection: Boolean = False);
Var
  aConnectionPoolContainer: TalMySqlConnectionPoolContainer;
begin

  // security check
  if not assigned(ConnectionHandle) then
    raise Exception.Create('Connection handle can not be null');

  // release the connection
  FConnectionPoolCS.Acquire;
  Try

    // add the connection to the pool
    If (not CloseConnection) and (not FReleasingAllconnections) then
    begin
      aConnectionPoolContainer := TalMySqlConnectionPoolContainer.Create;
      aConnectionPoolContainer.ConnectionHandle := ConnectionHandle;
      aConnectionPoolContainer.LastAccessDate := ALGettickCount64;
      FConnectionPool.Add(aConnectionPoolContainer);
    end

    // close the connection
    else
    begin
      try
        fLibrary.MySql_close(ConnectionHandle);
      Except
        // Disconnect must be a "safe" procedure because it's mostly called in
        // finalization part of the code that it is not protected
      end;
    end;

    // set the connectionhandle to nil
    ConnectionHandle := nil;

    // dec the WorkingConnectionCount
    dec(FWorkingConnectionCount);

    // free memory allocated by mysql_thread_init().
    // http://dev.mysql.com/doc/refman/5.6/en/threaded-clients.html
    // but i see one drawback in this, if the thread is for exemple
    // using 2 connections at the same time !
    Try
      dec(vAlMySqlConnectionPoolClientThreadInitRefCount);
      if vAlMySqlConnectionPoolClientThreadInitRefCount = 0 then
        fLibrary.mysql_thread_end;
    Except
      // Disconnect must be a "safe" procedure because it's mostly called in
      // finalization part of the code that it is not protected
    End;

  finally
    FConnectionPoolCS.Release;
  end;

end;

{ ********************************************************************************************************* }
procedure TalMySqlConnectionPoolClient.ReleaseAllConnections
  (Const WaitWorkingConnections: Boolean = True);
Var
  aConnectionPoolContainer: TalMySqlConnectionPoolContainer;
begin

  // i m still not sure if the FLibrary.MySql_close
  // need the FLibrary.mysql_thread_init. the mysql doc
  // if a very true bullsheet. i think it's cost
  // nothing to call it here. but of course this mean that
  // releaseconnection could not be call inside a thread
  // that still own a connection because at the end of this
  // function we call mysql_thread_end
  try
    fLibrary.mysql_thread_init;
    inc(vAlMySqlConnectionPoolClientThreadInitRefCount);
  except
    // must be safe
  end;

  try

    { we do this to forbid any new thread to create a new transaction }
    FReleasingAllconnections := True;
    Try

      // wait that all transaction are finished
      if WaitWorkingConnections then
        while True do
        begin
          FConnectionPoolCS.Acquire;
          Try
            if FWorkingConnectionCount <= 0 then
              break;
          finally
            FConnectionPoolCS.Release;
          end;
          sleep(1);
        end;

      { free all database }
      FConnectionPoolCS.Acquire;
      Try
        while FConnectionPool.Count > 0 do
        begin
          aConnectionPoolContainer := TalMySqlConnectionPoolContainer
            (FConnectionPool[FConnectionPool.Count - 1]);
          Try
            fLibrary.MySql_close(aConnectionPoolContainer.ConnectionHandle);
          Except
            // Disconnect must be a "safe" procedure because it's mostly called in
            // finalization part of the code that it is not protected
          End;
          FConnectionPool.delete(FConnectionPool.Count - 1);
          // must be delete here because FConnectionPool free the object also
        end;
        FLastConnectionGarbage := ALGettickCount64;
      finally
        FConnectionPoolCS.Release;
      end;

    finally
      // Do not forbid anymore new thread to create a new transaction
      FReleasingAllconnections := False;
    End;

  finally
    try
      dec(vAlMySqlConnectionPoolClientThreadInitRefCount);
      if vAlMySqlConnectionPoolClientThreadInitRefCount = 0 then
        fLibrary.mysql_thread_end;
    except
      // must be safe
    end;
  end;
end;

{ ************************************************************************************ }
procedure TalMySqlConnectionPoolClient.TransactionStart
  (Var ConnectionHandle: PMySql);
begin

  // ConnectionHandle must be null
  if assigned(ConnectionHandle) then
    raise Exception.Create('Connection handle must be null');

  // init the aConnectionHandle
  ConnectionHandle := AcquireConnection;
  try

    // start the transaction
    UpdateData('START TRANSACTION', ConnectionHandle);

  except
    ReleaseConnection(ConnectionHandle, True);
    raise;
  end;

end;

{ ***************************************************************************************************************************** }
procedure TalMySqlConnectionPoolClient.TransactionCommit(var ConnectionHandle
  : PMySql; const CloseConnection: Boolean = False);
begin

  // security check
  if not assigned(ConnectionHandle) then
    raise Exception.Create('Connection handle can not be null');

  // commit the transaction
  UpdateData('COMMIT', ConnectionHandle);

  // release the connection
  ReleaseConnection(ConnectionHandle, CloseConnection);

end;

{ ******************************************************************************************************************************* }
procedure TalMySqlConnectionPoolClient.TransactionRollback(var ConnectionHandle
  : PMySql; const CloseConnection: Boolean = False);
var
  aTmpCloseConnection: Boolean;
begin

  // security check
  if not assigned(ConnectionHandle) then
    raise Exception.Create('Connection handle can not be null');

  // rollback the connection
  aTmpCloseConnection := CloseConnection;
  Try
    Try
      UpdateData('ROLLBACK', ConnectionHandle);
    except
      // to not raise an exception, most of the time TransactionRollback
      // are call inside a try ... except
      // raising the exception here will hide the first exception message
      // it's not a problem to hide the error here because closing the
      // connection will normally rollback the data
      aTmpCloseConnection := True;
    End;
  Finally

    // release the connection
    ReleaseConnection(ConnectionHandle, aTmpCloseConnection);

  End;

end;

{ ******************************************************************************************* }
procedure TalMySqlConnectionPoolClient.OnSelectDataDone
  (Query: TalMySqlClientSelectDataQUERY; TimeTaken: Integer);
begin
  // virtual
end;

{ ******************************************************************************************* }
procedure TalMySqlConnectionPoolClient.OnUpdateDataDone
  (Query: TalMySqlClientUpdateDataQUERY; TimeTaken: Integer);
begin
  // virtual
end;

{ ***************************************************************************************** }
procedure TalMySqlConnectionPoolClient.SelectData
  (Queries: TalMySqlClientSelectDataQUERIES; XMLDATA: TalXmlNode;
  OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct; ExtData: Pointer;
  FormatSettings: TALFormatSettings; const ConnectionHandle: PMySql = nil);

Var
  aMySqlRes: PMYSQL_RES;
  aMySqlRow: PMYSQL_ROW;
  aMySqlFields: array of PMYSQL_FIELD;
  aMySqlFieldLengths: PMYSQL_LENGTHS;
  aColumnCount: Integer;
  aColumnIndex: Integer;
  aNewRec: TalXmlNode;
  aValueRec: TalXmlNode;
  aViewRec: TalXmlNode;
  aQueriesIndex: Integer;
  aRecIndex: Integer;
  aRecAdded: Integer;
  aTmpConnectionHandle: PMySql;
  aOwnConnection: Boolean;
  aContinue: Boolean;
  aXmlDocument: TalXmlDocument;
  aUpdateRowTagByFieldValue: Boolean;
  aStopWatch: TStopWatch;

begin

  // exit if no SQL
  if Length(Queries) = 0 then
    exit;

  // only OnNewRowFunct / XMLDATA can be used
  if assigned(OnNewRowFunct) then
    XMLDATA := nil;

  // clear the XMLDATA
  if assigned(XMLDATA) then
    aXmlDocument := Nil
  else
  begin
    aXmlDocument := TalXmlDocument.Create('root');
    XMLDATA := aXmlDocument.DocumentElement;
  end;

  Try

    // acquire a connection and start the transaction if necessary
    aTmpConnectionHandle := ConnectionHandle;
    aOwnConnection := (not assigned(ConnectionHandle));
    if aOwnConnection then
      TransactionStart(aTmpConnectionHandle);
    Try

      // init the TstopWatch
      aStopWatch := TStopWatch.Create;

      // loop on all the SQL
      For aQueriesIndex := 0 to Length(Queries) - 1 do
      begin

        // start the TstopWatch
        aStopWatch.Reset;
        aStopWatch.Start;

        // prepare the query
        CheckAPIError(aTmpConnectionHandle,
          fLibrary.mysql_real_query(aTmpConnectionHandle,
          PANSIChar(Queries[aQueriesIndex].SQL),
          Length(Queries[aQueriesIndex].SQL)) <> 0);
        aMySqlRes := fLibrary.mysql_use_result(aTmpConnectionHandle);
        CheckAPIError(aTmpConnectionHandle, aTmpConnectionHandle = nil);
        Try

          // Returns the number of columns in a result set.
          aColumnCount := fLibrary.mysql_num_fields(aMySqlRes);

          // init the aMySqlFields array
          // this not work anymore in MYSQL5.5, i don't know why so i use mysql_fetch_field instead
          // aMySqlFields := fLibrary.mysql_fetch_fields(aMySqlRes);
          setlength(aMySqlFields, aColumnCount);
          for aColumnIndex := 0 to aColumnCount - 1 do
            aMySqlFields[aColumnIndex] := fLibrary.mysql_fetch_field(aMySqlRes);

          // init the aViewRec
          if (Queries[aQueriesIndex].ViewTag <> '') and
            (not assigned(aXmlDocument)) then
            aViewRec := XMLDATA.AddChild(Queries[aQueriesIndex].ViewTag)
          else
            aViewRec := XMLDATA;

          // init aUpdateRowTagByFieldValue
          if AlPos('&>', Queries[aQueriesIndex].RowTag) = 1 then
          begin
            delete(Queries[aQueriesIndex].RowTag, 1, 2);
            aUpdateRowTagByFieldValue := Queries[aQueriesIndex].RowTag <> '';
          end
          else
            aUpdateRowTagByFieldValue := False;

          // loop throught all row
          aRecIndex := 0;
          aRecAdded := 0;
          while True do
          begin

            // retrieve the next row. return A MYSQL_ROW structure for the next row.
            // NULL if there are no more rows to retrieve or if an error occurred.
            aMySqlRow := fLibrary.mysql_fetch_row(aMySqlRes);

            // break if no more row
            if aMySqlRow = nil then
            begin
              CheckAPIError(aTmpConnectionHandle,
                fLibrary.mysql_errno(aTmpConnectionHandle) <> 0);
              break;
            end

            // download the row
            else
            begin

              // process if > Skip
              inc(aRecIndex);
              If aRecIndex > Queries[aQueriesIndex].Skip then
              begin

                // init NewRec
                if (Queries[aQueriesIndex].RowTag <> '') and
                  (not assigned(aXmlDocument)) then
                  aNewRec := aViewRec.AddChild(Queries[aQueriesIndex].RowTag)
                Else
                  aNewRec := aViewRec;

                // init aMySqlFieldLengths
                aMySqlFieldLengths := fLibrary.mysql_fetch_lengths(aMySqlRes);
                CheckAPIError(aTmpConnectionHandle, aMySqlFieldLengths = nil);

                // loop throught all column
                For aColumnIndex := 0 to aColumnCount - 1 do
                begin
                  aValueRec :=
                    aNewRec.AddChild
                    (ALlowercase(aMySqlFields[aColumnIndex].name));
                  if (aMySqlFields[aColumnIndex]._type in [FIELD_TYPE_TINY_BLOB,
                    FIELD_TYPE_MEDIUM_BLOB, FIELD_TYPE_LONG_BLOB,
                    FIELD_TYPE_BLOB]) then
                    aValueRec.ChildNodes.Add
                      (aValueRec.OwnerDocument.CreateNode
                      (GetFieldValue(aMySqlRow[aColumnIndex],
                      aMySqlFields[aColumnIndex]._type,
                      aMySqlFieldLengths[aColumnIndex],
                      FormatSettings), ntCData))
                  else
                    aValueRec.Text := GetFieldValue(aMySqlRow[aColumnIndex],
                      aMySqlFields[aColumnIndex]._type,
                      aMySqlFieldLengths[aColumnIndex], FormatSettings);
                  if aUpdateRowTagByFieldValue and
                    (aValueRec.NodeName = aNewRec.NodeName) then
                    aNewRec.NodeName := ALlowercase(aValueRec.Text);
                end;

                // handle OnNewRowFunct
                if assigned(OnNewRowFunct) then
                begin
                  aContinue := True;
                  OnNewRowFunct(aNewRec, Queries[aQueriesIndex].ViewTag,
                    ExtData, aContinue);
                  if Not aContinue then
                    break;
                end;

                // free the node if aXmlDocument
                if assigned(aXmlDocument) then
                  aXmlDocument.DocumentElement.ChildNodes.Clear;

                // handle the First
                inc(aRecAdded);
                If (Queries[aQueriesIndex].First > 0) and
                  (aRecAdded >= Queries[aQueriesIndex].First) then
                  break;

              end;

            end;

          end;

        Finally
          // Frees the memory allocated to aMySqlRes
          fLibrary.mysql_free_result(aMySqlRes);
        End;

        // do the OnSelectDataDone
        aStopWatch.Stop;
        OnSelectDataDone(Queries[aQueriesIndex],
          aStopWatch.ElapsedMilliseconds);

      End;

      // commit the transaction and release the connection if owned
      if aOwnConnection then
        TransactionCommit(aTmpConnectionHandle);

    except
      On E: Exception do
      begin

        // rollback the transaction and release the connection if owned
        // TODO
        // instead of closing the connection, it's could be better to know
        // if the error is related to the connection, or related to the
        // SQL (like we do in alFBXclient with GetCloseConnectionByErrCode
        if aOwnConnection then
          TransactionRollback(aTmpConnectionHandle, True);

        // raise the error
        raise;

      end;
    end;

  Finally
    if assigned(aXmlDocument) then
      aXmlDocument.free;
  End;

end;

{ ************************************************************************************* }
procedure TalMySqlConnectionPoolClient.SelectData
  (Query: TalMySqlClientSelectDataQUERY;
  OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct; ExtData: Pointer;
  FormatSettings: TALFormatSettings; const ConnectionHandle: PMySql = nil);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := Query;
  SelectData(aSelectDataQUERIES, nil, OnNewRowFunct, ExtData, FormatSettings,
    ConnectionHandle);
end;

{ **************************************************************** }
procedure TalMySqlConnectionPoolClient.SelectData(SQL: AnsiString;
  Skip: Integer; First: Integer;
  OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct; ExtData: Pointer;
  FormatSettings: TALFormatSettings; const ConnectionHandle: PMySql = nil);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := TalMySqlClientSelectDataQUERY.Create;
  aSelectDataQUERIES[0].SQL := SQL;
  aSelectDataQUERIES[0].Skip := Skip;
  aSelectDataQUERIES[0].First := First;
  SelectData(aSelectDataQUERIES, nil, OnNewRowFunct, ExtData, FormatSettings,
    ConnectionHandle);
end;

{ **************************************************************** }
procedure TalMySqlConnectionPoolClient.SelectData(SQL: AnsiString;
  OnNewRowFunct: TalMySqlClientSelectDataOnNewRowFunct; ExtData: Pointer;
  FormatSettings: TALFormatSettings; const ConnectionHandle: PMySql = nil);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := TalMySqlClientSelectDataQUERY.Create;
  aSelectDataQUERIES[0].SQL := SQL;
  SelectData(aSelectDataQUERIES, nil, OnNewRowFunct, ExtData, FormatSettings,
    ConnectionHandle);
end;

{ ***************************************************************************************** }
procedure TalMySqlConnectionPoolClient.SelectData
  (Queries: TalMySqlClientSelectDataQUERIES; XMLDATA: TalXmlNode;
  FormatSettings: TALFormatSettings; const ConnectionHandle: PMySql = nil);
begin

  SelectData(Queries, XMLDATA, nil, nil, FormatSettings, ConnectionHandle);

end;

{ ************************************************************************************* }
procedure TalMySqlConnectionPoolClient.SelectData
  (Query: TalMySqlClientSelectDataQUERY; XMLDATA: TalXmlNode;
  FormatSettings: TALFormatSettings; const ConnectionHandle: PMySql = nil);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := Query;
  SelectData(aSelectDataQUERIES, XMLDATA, nil, nil, FormatSettings,
    ConnectionHandle);
end;

{ **************************************************************** }
procedure TalMySqlConnectionPoolClient.SelectData(SQL: AnsiString;
  RowTag: AnsiString; Skip: Integer; First: Integer; XMLDATA: TalXmlNode;
  FormatSettings: TALFormatSettings; const ConnectionHandle: PMySql = nil);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := TalMySqlClientSelectDataQUERY.Create;
  aSelectDataQUERIES[0].SQL := SQL;
  aSelectDataQUERIES[0].RowTag := RowTag;
  aSelectDataQUERIES[0].Skip := Skip;
  aSelectDataQUERIES[0].First := First;
  SelectData(aSelectDataQUERIES, XMLDATA, nil, nil, FormatSettings,
    ConnectionHandle);
end;

{ **************************************************************** }
procedure TalMySqlConnectionPoolClient.SelectData(SQL: AnsiString;
  RowTag: AnsiString; XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings;
  const ConnectionHandle: PMySql = nil);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := TalMySqlClientSelectDataQUERY.Create;
  aSelectDataQUERIES[0].SQL := SQL;
  aSelectDataQUERIES[0].RowTag := RowTag;
  SelectData(aSelectDataQUERIES, XMLDATA, nil, nil, FormatSettings,
    ConnectionHandle);
end;

{ **************************************************************** }
procedure TalMySqlConnectionPoolClient.SelectData(SQL: AnsiString;
  XMLDATA: TalXmlNode; FormatSettings: TALFormatSettings;
  const ConnectionHandle: PMySql = nil);
var
  aSelectDataQUERIES: TalMySqlClientSelectDataQUERIES;
begin
  setlength(aSelectDataQUERIES, 1);
  aSelectDataQUERIES[0] := TalMySqlClientSelectDataQUERY.Create;
  aSelectDataQUERIES[0].SQL := SQL;
  SelectData(aSelectDataQUERIES, XMLDATA, nil, nil, FormatSettings,
    ConnectionHandle);
end;

{ ******************************************************************************************************************************** }
procedure TalMySqlConnectionPoolClient.UpdateData
  (Queries: TalMySqlClientUpdateDataQUERIES;
  const ConnectionHandle: PMySql = nil);
Var
  aQueriesIndex: Integer;
  aTmpConnectionHandle: PMySql;
  aOwnConnection: Boolean;
  aStopWatch: TStopWatch;
begin

  // exit if no SQL
  if Length(Queries) = 0 then
    exit;

  // acquire a connection and start the transaction if necessary
  aTmpConnectionHandle := ConnectionHandle;
  aOwnConnection := (not assigned(ConnectionHandle));
  if aOwnConnection then
    TransactionStart(aTmpConnectionHandle);
  Try

    // init the TstopWatch
    aStopWatch := TStopWatch.Create;

    // loop on all the SQL
    For aQueriesIndex := 0 to Length(Queries) - 1 do
    begin

      // start the TstopWatch
      aStopWatch.Reset;
      aStopWatch.Start;

      // do the query
      CheckAPIError(aTmpConnectionHandle,
        fLibrary.mysql_real_query(aTmpConnectionHandle,
        PANSIChar(Queries[aQueriesIndex].SQL),
        Length(Queries[aQueriesIndex].SQL)) <> 0);

      // do the OnUpdateDataDone
      aStopWatch.Stop;
      OnUpdateDataDone(Queries[aQueriesIndex], aStopWatch.ElapsedMilliseconds);

    end;

    // commit the transaction and release the connection if owned
    if aOwnConnection then
      TransactionCommit(aTmpConnectionHandle);

  except
    On E: Exception do
    begin

      // rollback the transaction and release the connection if owned
      // TODO
      // instead of closing the connection, it's could be better to know
      // if the error is related to the connection, or related to the
      // SQL (like we do in alFBXclient with GetCloseConnectionByErrCode
      if aOwnConnection then
        TransactionRollback(aTmpConnectionHandle, True);

      // raise the error
      raise;

    end;
  end;

end;

{ **************************************************************************************************************************** }
procedure TalMySqlConnectionPoolClient.UpdateData
  (Query: TalMySqlClientUpdateDataQUERY; const ConnectionHandle: PMySql = nil);
Var
  aUpdateDataQUERIES: TalMySqlClientUpdateDataQUERIES;
begin
  setlength(aUpdateDataQUERIES, 1);
  aUpdateDataQUERIES[0] := Query;
  UpdateData(aUpdateDataQUERIES, ConnectionHandle);
end;

{ ******************************************************************************************************** }
procedure TalMySqlConnectionPoolClient.UpdateData(SQLs: TALStrings;
  const ConnectionHandle: PMySql = nil);
Var
  aSQLsIndex: Integer;
  aUpdateDataQUERIES: TalMySqlClientUpdateDataQUERIES;
begin
  setlength(aUpdateDataQUERIES, SQLs.Count);
  For aSQLsIndex := 0 to SQLs.Count - 1 do
  begin
    aUpdateDataQUERIES[aSQLsIndex] := TalMySqlClientUpdateDataQUERY.Create;
    aUpdateDataQUERIES[aSQLsIndex].SQL := SQLs[aSQLsIndex];
  end;
  UpdateData(aUpdateDataQUERIES, ConnectionHandle);
end;

{ ******************************************************************************************************* }
procedure TalMySqlConnectionPoolClient.UpdateData(SQL: AnsiString;
  const ConnectionHandle: PMySql = nil);
Var
  aUpdateDataQUERIES: TalMySqlClientUpdateDataQUERIES;
begin
  setlength(aUpdateDataQUERIES, 1);
  aUpdateDataQUERIES[0] := TalMySqlClientUpdateDataQUERY.Create;
  aUpdateDataQUERIES[0].SQL := SQL;
  UpdateData(aUpdateDataQUERIES, ConnectionHandle);
end;

{ ***************************************************************************************************************** }
procedure TalMySqlConnectionPoolClient.UpdateData(SQLs: array of AnsiString;
  const ConnectionHandle: PMySql = nil);
Var
  aUpdateDataQUERIES: TalMySqlClientUpdateDataQUERIES;
  I: Integer;
begin
  setlength(aUpdateDataQUERIES, Length(SQLs));
  for I := 0 to Length(SQLs) - 1 do
  begin
    aUpdateDataQUERIES[I] := TalMySqlClientUpdateDataQUERY.Create;
    aUpdateDataQUERIES[I].SQL := SQLs[I];
  end;
  UpdateData(aUpdateDataQUERIES, ConnectionHandle);
end;

{ **************************************************************************************************************** }
function TalMySqlConnectionPoolClient.insert_id(SQL: AnsiString;
  const ConnectionHandle: PMySql = nil): ULongLong;
Var
  aTmpConnectionHandle: PMySql;
  aOwnConnection: Boolean;
begin

  // acquire a connection and start the transaction if necessary
  aTmpConnectionHandle := ConnectionHandle;
  aOwnConnection := (not assigned(ConnectionHandle));
  if aOwnConnection then
    TransactionStart(aTmpConnectionHandle);
  Try

    // if the SQL is not empty
    if SQL <> '' then
    begin

      // do the query
      UpdateData(SQL, aTmpConnectionHandle);

      // Returns the value generated for an AUTO_INCREMENT column
      // by the previous INSERT or UPDATE statement
      result := fLibrary.mysql_insert_id(aTmpConnectionHandle);

    end

    // if the SQL is empty, simply gave an 0 result
    else
      result := 0;

    // commit the transaction and release the connection if owned
    if aOwnConnection then
      TransactionCommit(aTmpConnectionHandle);

  except
    On E: Exception do
    begin

      // rollback the transaction and release the connection if owned
      // TODO
      // instead of closing the connection, it's could be better to know
      // if the error is related to the connection, or related to the
      // SQL (like we do in alFBXclient with GetCloseConnectionByErrCode
      if aOwnConnection then
        TransactionRollback(aTmpConnectionHandle, True);

      // raise the error
      raise;

    end;
  end;

end;

{ ************************************************************* }
function TalMySqlConnectionPoolClient.ConnectionCount: Integer;
begin
  FConnectionPoolCS.Acquire;
  Try
    result := FConnectionPool.Count + FWorkingConnectionCount;
  finally
    FConnectionPoolCS.Release;
  end;
end;

{ ******************************************************************** }
function TalMySqlConnectionPoolClient.WorkingConnectionCount: Integer;
begin
  FConnectionPoolCS.Acquire;
  Try
    result := FWorkingConnectionCount;
  finally
    FConnectionPoolCS.Release;
  end;
end;

end.
