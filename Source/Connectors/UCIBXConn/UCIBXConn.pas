{-----------------------------------------------------------------------------
 Unit Name: UCIBXConn
 Author:    QmD
 Date:      08-nov-2004
 Purpose:   IBX Support

 registered in UCReg.pas
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
unit UCIBXConn;

interface

uses
  Classes,
  DB,
  IBDataBase,
  IBQuery,
  SysUtils,
  UCDataConnector;

type
  TUCIBXConn = class(TUCDataConnector)
  private
    FConnection:  TIBDatabase;
    FTransaction: TIBTransaction;
    procedure SetTransaction(const Value: TIBTransaction);
    procedure SetConnection(const Value: TIBDatabase);
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
  published
    property Connection: TIBDatabase read FConnection write SetConnection;
    property Transaction: TIBTransaction read FTransaction write SetTransaction;
  end;

implementation

{ TUCIBXConn }

procedure TUCIBXConn.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FConnection) then
    FConnection := nil;
  if (Operation = opRemove) and (AComponent = FTransaction) then
    FTransaction := nil;
  inherited Notification(AComponent, Operation);
end;

function TUCIBXConn.UCFindTable(const TableName: String): Boolean;
var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  try
    FConnection.GetTableNames(TempList, False);
    TempList.Text := UpperCase(TempList.Text);
    Result        := TempList.IndexOf(UpperCase(TableName)) > -1;
  finally
    SysUtils.FreeAndNil(TempList);
  end;
end;

function TUCIBXConn.UCFindDataConnection: Boolean;
begin
  Result := Assigned(FConnection) and (FConnection.Connected);
end;

function TUCIBXConn.UCFindFieldTable(const Tablename, FieldName: string): Boolean;
var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  try
    FConnection.GetFieldNames(Tablename, TempList);
    TempList.Text := UpperCase(TempList.Text);
    Result := TempList.IndexOf(UpperCase(FieldName)) > -1;
  finally
    SysUtils.FreeAndNil(TempList);
  end;
end;

function TUCIBXConn.GetDBObjectName: String;
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

function TUCIBXConn.GetTransObjectName: String;
begin
  if Assigned(FTransaction) then
  begin
    if Owner = FTransaction.Owner then
      Result := FTransaction.Name
    else
    begin
      Result := FTransaction.Owner.Name + '.' + FTransaction.Name;
    end;
  end
  else
    Result := '';
end;

procedure TUCIBXConn.UCExecSQL(FSQL: String);
var
  Qry: TIBQuery;
begin
  Qry := TIBQuery.Create(nil);
  try
    Qry.Database    := FConnection;
    Qry.Transaction := FTransaction;
    if not Qry.Transaction.Active then
      Qry.Transaction.Active := True;
    Qry.SQL.Text := FSQL;
    Qry.ExecSQL;
    Qry.Transaction.Commit;
  finally
    Qry.Free;
  end;
end;

function TUCIBXConn.UCGetSQLDataset(FSQL: String): TDataset;
begin
  Result := TIBQuery.Create(nil);
  with Result as TIBQuery do
  begin
    Database    := FConnection;
    Transaction := FTransaction;
    SQL.Text    := FSQL;
    Open;
  end;
end;


procedure TUCIBXConn.SetTransaction(const Value: TIBTransaction);
begin
  FTransaction := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TUCIBXConn.SetConnection(const Value: TIBDatabase);
begin
  if FConnection <> Value then
    FConnection := Value;
  if FConnection <> nil then
    FConnection.FreeNotification(Self);
end;

end.

