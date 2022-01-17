{-----------------------------------------------------------------------------
 Unit Name: UCDBXConn
 Author:    QmD
 Date:      08-nov-2004
 Purpose:   ADO Support

 registered in UCDBXReg.pas
-----------------------------------------------------------------------------}


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
{ ****************************************************************************** }

{ ******************************************************************************
  |* Historico
  |*
  |* 01/07/2015: Giovani Da Cruz
  |*  - Cria��o e distribui��o da Primeira Versao ShowDelphi
  ******************************************************************************* }


unit UCDBXConn;

interface

uses
  Classes,
  DB,
  SimpleDS,
  SqlExpr,
  SysUtils,
  UCDataConnector;

type
  TUCDBXConn = class(TUCDataConnector)
  private
    FConnection: TSQLConnection;
    FSchema:     String;
    procedure SetSQLConnection(Value: TSQLConnection);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function GetDBObjectName: String; override;
    function GetTransObjectName: String; override;
    function UCFindDataConnection: Boolean; override;
    function UCFindTable(const Tablename: String): Boolean; override;
    function UCFindFieldTable(const Tablename: string; const FieldName: string): Boolean; override;
    function UCGetSQLDataset(FSQL: String): TDataset; override;
    procedure UCExecSQL(FSQL: String); override;
    procedure OrderBy(const DataSet: TDataSet; const FieldName: string); override;
  published
    property Connection: TSQLConnection read FConnection write SetSQLConnection;
    property SchemaName: String read FSchema write FSchema;
  end;

implementation

{ TUCDBXConn }

procedure TUCDBXConn.SetSQLConnection(Value: TSQLConnection);
begin
  if FConnection <> Value then
    FConnection := Value;
  if FConnection <> nil then
    FConnection.FreeNotification(Self);
end;

procedure TUCDBXConn.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FConnection) then
    FConnection := nil;
  inherited Notification(AComponent, Operation);
end;

procedure TUCDBXConn.OrderBy(const DataSet: TDataSet; const FieldName: string);
var
  IndexName: string;
  Index: TIndexDef;
  Found: Boolean;
begin
  inherited;
  if TSimpleDataSet(DataSet).IndexFieldNames = FieldName then
  begin
    IndexName := FieldName + ' Desc';

    try
      TSimpleDataSet(DataSet).IndexDefs.Find(IndexName);
      Found := True;
    except
      Found := False;
    end;

    if not Found then
    begin
      Index := TSimpleDataSet(DataSet).IndexDefs.AddIndexDef;
      Index.Name := IndexName;
      Index.Fields := FieldName;
      Index.Options := [ixDescending];
    end;
    TSimpleDataSet(DataSet).IndexName := IndexName;
  end
  else
    TSimpleDataSet(DataSet).IndexFieldNames := FieldName;
end;

function TUCDBXConn.UCFindTable(const TableName: String): Boolean;
var
  TempList: TStringList;
begin
  try
    TempList := TStringList.Create;
    if SchemaName <> '' then
      FConnection.GetTableNames(TempList, SchemaName)
    else
      FConnection.GetTableNames(TempList);
    TempList.Text := UpperCase(TempList.Text);
    Result        := TempList.IndexOf(UpperCase(TableName)) > -1;
  finally
    FreeAndNil(TempList);
  end;
end;

function TUCDBXConn.UCFindDataConnection: Boolean;
begin
  Result := Assigned(FConnection) and (FConnection.Connected);
end;

function TUCDBXConn.UCFindFieldTable(const Tablename, FieldName: string): Boolean;
var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  try
    {$IFDEF DELPHI2009_UP}	
	if SchemaName <> '' then
      FConnection.GetFieldNames(Tablename, SchemaName, TempList)
    else
      FConnection.GetFieldNames(Tablename, TempList);
	{$ELSE}
    FConnection.GetFieldNames(Tablename, TempList);
    {$ENDIF}	
    TempList.Text := UpperCase(TempList.Text);
    Result := TempList.IndexOf(UpperCase(FieldName)) > -1;
  finally
    FreeAndNil(TempList);
  end;
end;

function TUCDBXConn.GetDBObjectName: String;
begin
  if Assigned(FConnection) then
  begin
    if Owner = FConnection.Owner then
      Result := FConnection.Name
    else
    begin
      Result := FConnection.Owner.Name + '.' + FConnection.Name;
    end;
  end
  else
    Result := '';
end;

function TUCDBXConn.GetTransObjectName: String;
begin
  Result := '';
end;

procedure TUCDBXConn.UCExecSQL(FSQL: String);
begin
//  FConnection.Execute(FSQL, nil);    // by vicente barros leonel
  FConnection.ExecuteDirect(FSQL);
end;

function TUCDBXConn.UCGetSQLDataset(FSQL: String): TDataset;
begin
  Result := TSimpleDataSet.Create(nil);
  with Result as TSimpleDataSet do
  begin
    Connection          := FConnection;
    DataSet.CommandText := FSQL;
    SchemaName          := FSchema;
    Open;
  end;
end;

end.

