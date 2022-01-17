{ -----------------------------------------------------------------------------
  Unit Name: UCDataSnapConn
  Author   : Giovani Da Cruz
  Date     : 26/12/2015
  Purpose  : DataSnap Suporte
  E-mail   : giovani@infus.inf.br
  URL      : www.infus.inf.br
  UC SW    : http://infussolucoes.github.io/usercontrol-sd/

  registered in UCDataSnapConnReg.pas
  ----------------------------------------------------------------------------- }

{ **************************************************************************** }
{ Projeto: Componentes User Control ShowDelphi Edition                         }
{ Biblioteca multiplataforma de componentes Delphi para o controle de usu�rios }
{                                                                              }
{ Baseado nos pacotes Open Source User Control 2.31 RC1                        }
{
Autor da vers�o Original: Rodrigo Alves Cordeiro

Colaboradores da vers�o original
Alexandre Oliveira Campioni - alexandre.rural@netsite.com.br
Bernard Grandmougin
Carlos Guerra
Daniel Wszelaki
Everton Ramos [BS2 Internet]
Francisco Due�as - fduenas@flashmail.com
Germ�n H. Cravero
Luciano Almeida Pimenta [ClubeDelphi.net]
Luiz Benevenuto - luiz@siffra.com
Luiz Fernando Severnini
Peter van Mierlo
Rodolfo Ferezin Moreira - rodolfo.fm@bol.com.br
Rodrigo Palhano (WertherOO)
Ronald Marconi
Sergiy Sekela (Dr.Web)
Stefan Nawrath
Vicente Barros Leonel [ Fknyght ]

*******************************************************************************}
{ Vers�o ShowDelphi Edition                                                    }
{                                                                              }
{ Direitos Autorais Reservados (c) 2015   Giovani Da Cruz                      }
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
{ Comunidade Show Delphi - www.showdelphi.com.br                               }
{                                                                              }
{ Giovani Da Cruz  -  giovani@infus.inf.br  -  www.infus.inf.br                }
{                                                                              }
{ **************************************************************************** }

{ ******************************************************************************
  |* Historico
  |*
  |* 26/12/2015: Giovani Da Cruz
  |*  - Cria��o e distribui��o da Primeira deste connector
  |*
  |*
  |* 05/04/2018: Giovani Da Cruz
  |*  - Melhoria para a atualiza��o de dados
  |*
  **************************************************************************** }
unit UCRestConn;

interface

uses
  System.Classes,
  Data.DB, Datasnap.DSClientRest,
  System.SysUtils, UCRestProxy, Data.FireDACJSONReflect,
  UCDataConnector, FireDAC.Comp.Client;

type
  TFDMemTable = class(FireDAC.Comp.Client.TFDMemTable)
  private
    FSQL: TStrings;  public
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SQL : TStrings read FSQL write FSQL;
  end;

  TUCRestConn = class(TUCDataConnector)
  private
    FInstanceOwner: Boolean;
    FSchema: String;
    FDSClient: TDSUserRemote;
    FConnection: TDSRestConnection;
    procedure SetConnection(const Value: TDSRestConnection);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
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
    property Connection: TDSRestConnection read FConnection write SetConnection;
    property DSClient: TDSUserRemote read FDSClient write FDSClient;
    property SchemaName: String read FSchema write FSchema;
  end;

implementation

{ TUCRestConn }

procedure TUCRestConn.CloseDataSet(DataSet: TDataSet);
begin
  inherited;

  DataSet.Close;
end;

constructor TUCRestConn.Create(AOwner: TComponent);
begin
  inherited;
  FInstanceOwner := True;
  FSchema := '';
end;

destructor TUCRestConn.Destroy;
begin

  inherited;
end;

function TUCRestConn.GetDBObjectName: String;
begin
  if Assigned(FConnection) then
  begin
    if Owner = FConnection.Owner then
      Result := FConnection.Name
    else
      Result := FConnection.Owner.Name + '.' + FConnection.Name;
  end
  else
    Result := '';
end;

function TUCRestConn.GetTransObjectName: String;
begin
  Result := '';
end;

procedure TUCRestConn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FConnection) then
    FConnection := nil;
  inherited Notification(AComponent, Operation);
end;

procedure TUCRestConn.OpenDataSet(DataSet: TDataSet);
var
  FList: TFDJSONDataSets;
begin
  FList := DSClient.GetDataSet2((DataSet as TFDMemTable).SQL.Text, '');

  DataSet.Close;

  (DataSet as TFDMemTable).Fields.Clear;
  (DataSet as TFDMemTable).AppendData(
  TFDJSONDataSetsReader.GetListValue(FList, 0));
end;

procedure TUCRestConn.OrderBy(const DataSet: TDataSet; const FieldName: string);
begin
  inherited;
  if TFDMemTable(DataSet).IndexFieldNames = FieldName then
    TFDMemTable(DataSet).IndexFieldNames := FieldName + ':D'
  else
    TFDMemTable(DataSet).IndexFieldNames := FieldName;
end;

procedure TUCRestConn.SetConnection(const Value: TDSRestConnection);
begin
  if FConnection <> Value then
    FConnection := Value;
  if FConnection <> nil then
    FConnection.FreeNotification(Self);
end;

procedure TUCRestConn.UCExecSQL(FSQL: String);
begin
  inherited;
  DSClient.ExecuteSQL(FSQL);
end;

function TUCRestConn.UCFindDataConnection: Boolean;
begin
  Result := Assigned(FConnection);
end;

function TUCRestConn.UCFindFieldTable(const Tablename, FieldName: string): Boolean;
begin
  // precisa estar implementado no servidor

  Result := True;//DSClient.FindFieldTable(Tablename, FieldName);
end;

function TUCRestConn.UCFindTable(const Tablename: String): Boolean;
begin
  // precisa estar implementado no servidor

  Result := True;//DSClient.FindTable(Tablename, Self.SchemaName);
end;

function TUCRestConn.UCGetSQLDataset(FSQL: String): TDataset;
var
  FList: TFDJSONDataSets;
begin
  FList := DSClient.GetDataSet2(FSQL, '');

  Result := TFDMemTable.Create(Self);
  Result.Close;

  (Result as TFDMemTable).SQL.Text := FSQL;

  Result.Fields.Clear;
  TFDMemTable(Result).AppendData(
  TFDJSONDataSetsReader.GetListValue(FList, 0));
end;

{ TFDMemTable }

constructor TFDMemTable.Create(AOwner: TComponent);
begin
  inherited;
  FSQL := TStringList.Create;
end;

destructor TFDMemTable.Destroy;
begin
  FSQL.Destroy;
  inherited;
end;

end.
