{ **************************************************************************** }
{ Projeto: Componentes User Control ShowDelphi Edition                         }
{ Biblioteca multiplataforma de componentes Delphi para o controle de usu�rios }
{                                                                              }
{ Baseado nos pacotes Open Source User Control 2.31 RC1                        }
{                                                                              }
{                                                                              }                           
{******************************************************************************}
{ Vers�o ShowDelphi Edition                                                    }
{                                                                              }
{ Direitos Autorais Reservados (c) 2019   Giovani Da Cruz                      }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{ Voc� pode obter a �ltima vers�o desse arquivo na pagina do projeto           }
{ User Control ShowDelphi Edition                                              }
{ Componentes localizado em http://infussolucoes.github.io/usercontrol-sd/     }
{                                                                              }
{ Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la  }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{ Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM    }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{ Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto }
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{                                                                              }
{ Comunidade Show Delphi - showdelphi.com.br                                   }
{                                                                              }
{ Giovani Da Cruz  -  giovani@infus.inf.br  -  www.infus.inf.br                }
{                                                                              }
{ **************************************************************************** }

{ AJUDE O PROJETO COM UMA X�CARA DE CAF� OU DUAS. CONSIDERE UMA DOA��O!        }
{                                                                              }
{ VIA PAGSEGURO: https://pag.ae/7VccpnuCN                                      }
{ APOIE COM BITCOIN: 13JUHQpT7zAU7pC1q6cQBYGpq5EF8XoLcL                        }
{

{ ******************************************************************************
  |* Historico
  |*
  |* 31/08/2019: Giovani Da Cruz
  |*  - Cria��o do Connector
  **************************************************************************** }
unit UCRestDWCoreConn;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.DB,

  uRESTDWPoolerDB,

  UCDataConnector;

type
  TUCRestDWCoreConn = class(TUCDataConnector)
  private
    FSchema: String;
    FDataBase: TRESTDWDataBase;
    function GetAbout: string;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDBObjectName: String; override;
    function GetTransObjectName: String; override;
    function UCFindDataConnection: Boolean; override;
    function UCFindTable(const Tablename: String): Boolean; override;
    function UCFindFieldTable(const Tablename: string; const FieldName: string): Boolean; override;
    function UCGetSQLDataset(FSQL: String): TDataset; override;
    procedure UCExecSQL(FSQL: String); override;
    procedure OrderBy(const DataSet: TDataSet; const FieldName: string); override;
    procedure CloseDataSet(DataSet : TDataSet); override;
    procedure OpenDataSet(DataSet : TDataSet); override;
  published
    property DataBase : TRESTDWDataBase read FDataBase write FDataBase;
    property SchemaName: String read FSchema write FSchema;
    property About : string read GetAbout;
  end;

implementation

{ TUCRestDWConn }

procedure TUCRestDWCoreConn.CloseDataSet(DataSet: TDataSet);
begin
  (DataSet as TRESTDWClientSQL).Close;
end;

constructor TUCRestDWCoreConn.Create(AOwner: TComponent);
begin
  inherited;

  FSchema := '';
end;

destructor TUCRestDWCoreConn.Destroy;
begin

  inherited;
end;

function TUCRestDWCoreConn.GetAbout: string;
begin
  Result := 'Criado por Giovani Da Cruz - showdelphi.com.br';
end;

function TUCRestDWCoreConn.GetDBObjectName: String;
begin
  if Assigned(FDataBase) then
  begin
    if Owner = FDataBase.Owner then
      Result := FDataBase.Name
    else
      Result := FDataBase.Owner.Name + '.' + FDataBase.Name;
  end
  else
    Result := EmptyStr;
end;

function TUCRestDWCoreConn.GetTransObjectName: String;
begin
  Result := EmptyStr;
end;

procedure TUCRestDWCoreConn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = DataBase) then
  begin
    FDataBase := nil;
  end;

  inherited Notification(AComponent, Operation);
end;

procedure TUCRestDWCoreConn.OpenDataSet(DataSet: TDataSet);
begin
  (DataSet as TRESTDWClientSQL).Open;
end;

procedure TUCRestDWCoreConn.OrderBy(const DataSet: TDataSet;
  const FieldName: string);
var
  IndexName: string;
  Index: TIndexDef;
  Found: Boolean;
begin
  inherited;

  if (TRESTDWClientSQL(DataSet).IndexFieldNames = FieldName) then
  begin
    IndexName := FieldName + ' Desc';

    try
      TRESTDWClientSQL(DataSet).IndexDefs.Find(IndexName);
      Found := True;
    except
      Found := False;
    end;

    if not Found then
    begin
      Index := TRESTDWClientSQL(DataSet).IndexDefs.AddIndexDef;
      Index.Name := IndexName;
      Index.Fields := FieldName;
      Index.Options := [ixDescending];
    end;

    TRESTDWClientSQL(DataSet).IndexName := IndexName;
  end
  else
  begin
    TRESTDWClientSQL(DataSet).IndexFieldNames := FieldName;
  end;
end;

procedure TUCRestDWCoreConn.UCExecSQL(FSQL: String);
var
  vDataSet : TRESTDWClientSQL;
  vError : string;
begin
  inherited;

  vError := EmptyStr;
  vDataSet := TRESTDWClientSQL.Create(Self);

  try
    vDataSet.DataBase := Self.DataBase;
    vDataSet.SQL.Text := FSQL;
    vDataSet.ExecSQL(vError);

    if vError <> EmptyStr then
    begin
      raise Exception.Create('UserControl ExeSQL: ' + vError);
    end;
  finally
    FreeAndNil(vDataSet);
  end;
end;

function TUCRestDWCoreConn.UCFindDataConnection: Boolean;
begin
  Result := Assigned(FDataBase) and (FDataBase.Connected);
end;

function TUCRestDWCoreConn.UCFindFieldTable(const Tablename,
  FieldName: string): Boolean;
var
  vList : TStringList;
begin
  vList := TStringList.Create;

  try
    Result := Self.DataBase.GetFieldNames(Tablename, vList);

    { Caso tenha obtido a lista de tabelas, procure pelo nome }
    if (Result) then
    begin
      vList.Text := UpperCase(vList.Text);

      Result := vList.IndexOf(UpperCase(FieldName)) >= 0;
    end;
  finally
    FreeAndNil(vList);
  end;
end;

function TUCRestDWCoreConn.UCFindTable(const Tablename: String): Boolean;
var
  vList : TStringList;
begin
  vList := TStringList.Create;

  try
    Result := Self.DataBase.GetTableNames(vList);

    { Caso tenha obtido a lista de tabelas, procure pelo nome }
    if (Result) then
    begin
      vList.Text := UpperCase(vList.Text);

      Result := vList.IndexOf(UpperCase(Tablename)) >= 0;
    end;
  finally
    FreeAndNil(vList);
  end;
end;

function TUCRestDWCoreConn.UCGetSQLDataset(FSQL: String): TDataset;
var
  vDataSet : TRESTDWClientSQL;
begin
  vDataSet := TRESTDWClientSQL.Create(Self);

  try
    vDataSet.Close;
    vDataSet.DataBase := Self.DataBase;
    vDataSet.SQL.Text := FSQL;
    vDataSet.Open;
  except on E: Exception do
    begin
      FreeAndNil(vDataSet);
      raise Exception.Create('UserControl GetDataSet: ' + E.Message);
    end;
  end;

  Result := vDataSet;
end;

end.
