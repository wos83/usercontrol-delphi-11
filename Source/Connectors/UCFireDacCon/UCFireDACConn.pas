{ -----------------------------------------------------------------------------
  Unit Name: UCFireDACConn
  Author:    sergio@lsisistemas.com.br
  Date:      12-Junho-2013
  Purpose:   FireDac Support

  registered in UCFireDACReg.pas
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
{ ****************************************************************************** }

{ ******************************************************************************
  |* Historico
  |*
  |* 01/07/2015: Giovani Da Cruz
  |*  - Cria��o e distribui��o da Primeira Versao ShowDelphi
  ******************************************************************************* }

unit UCFireDACConn;

interface

uses
  UCDataConnector, system.SysUtils, system.Classes, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Comp.Client, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TUCFireDACConn = class(TUCDataConnector)
  private
    FConnection: TFDConnection;
    procedure SetFConnection(Value: TFDConnection);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    function GetDBObjectName: String; override;
    function GetTransObjectName: String; override;
    function UCFindDataConnection: Boolean; override;
    function UCFindTable(const Tablename: String): Boolean; override;
    function UCFindFieldTable(const Tablename, FieldName: String): Boolean; override;
    function UCGetSQLDataset(FSQL: String): TDataset; override;
    procedure UCExecSQL(FSQL: String); override;
    procedure OrderBy(const DataSet: TDataSet; const FieldName: string); override;
  published
    property Connection: TFDConnection read FConnection write SetFConnection;
  end;

implementation

{ TUCUniDACConn }

procedure TUCFireDACConn.SetFConnection(Value: TFDConnection);
begin
  if FConnection <> Value then
    FConnection := Value;
  if FConnection <> nil then
    FConnection.FreeNotification(Self);
end;

procedure TUCFireDACConn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FConnection) then
  begin
    FConnection := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TUCFireDACConn.OrderBy(const DataSet: TDataSet; const FieldName: string);
begin
  inherited;
  if TFDQuery(DataSet).IndexFieldNames = FieldName then
    TFDQuery(DataSet).IndexFieldNames := FieldName + ':D'
  else
    TFDQuery(DataSet).IndexFieldNames := FieldName;
end;

function TUCFireDACConn.UCFindTable(const Tablename: String): Boolean;
var
  TempList: TStringList;
begin
  try
    TempList := TStringList.Create;;
    FConnection.GetTableNames('', '', '', TempList, [osMy], [tkTable], False);
    TempList.Text := UpperCase(TempList.Text);
    Result := TempList.IndexOf(UpperCase(Tablename)) > -1;
  finally
    FreeAndNil(TempList);
  end;
end;

function TUCFireDACConn.UCFindDataConnection: Boolean;
begin
  Result := Assigned(FConnection) and (FConnection.Connected);
end;

function TUCFireDACConn.UCFindFieldTable(const Tablename, FieldName: String): Boolean;
var
  TempList: TStringList;
begin
  try
    TempList := TStringList.Create;;
    FConnection.GetFieldNames('', '', Tablename, '', TempList);
    TempList.Text := UpperCase(TempList.Text);
    Result := TempList.IndexOf(UpperCase(FieldName)) > -1;
  finally
    FreeAndNil(TempList);
  end;
end;

function TUCFireDACConn.GetDBObjectName: String;
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

function TUCFireDACConn.GetTransObjectName: String;
begin
  Result := '';
end;

procedure TUCFireDACConn.UCExecSQL(FSQL: String);
begin
  if Assigned(FConnection) then
    FConnection.ExecSQL(FSQL, []);
end;

function TUCFireDACConn.UCGetSQLDataset(FSQL: String): TDataset;
begin
  Result := TFDQuery.Create(nil);
  with Result as TFDQuery do
  begin
    Connection := FConnection;
    SQL.Text := FSQL;
    Open;
  end;
end;

end.
