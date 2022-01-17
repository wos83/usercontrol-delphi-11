{ **************************************************************************** }
{ Projeto: Componentes User Control ShowDelphi Edition }
{ Biblioteca multiplataforma de componentes Delphi para o controle de usu�rios }
{ }
{ Baseado nos pacotes Open Source User Control 2.31 RC1 }
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

  ******************************************************************************* }
{ Vers�o ShowDelphi Edition }
{ }
{ Direitos Autorais Reservados (c) 2015   Giovani Da Cruz }
{ }
{ Colaboradores nesse arquivo: }
{ }
{ Voc� pode obter a �ltima vers�o desse arquivo na pagina do projeto }
{ User Control ShowDelphi Edition }
{ Componentes localizado em http://infussolucoes.github.io/usercontrol-sd/ }
{ }
{ Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior. }
{ }
{ Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor }
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT) }
{ }
{ Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto }
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc., }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA. }
{ Voc� tamb�m pode obter uma copia da licen�a em: }
{ http://www.opensource.org/licenses/lgpl-license.php }
{ }
{ }
{ Comunidade Show Delphi - www.showdelphi.com.br }
{ }
{ Giovani Da Cruz  -  giovani@infus.inf.br  -  www.infus.inf.br }
{ }
{ ****************************************************************************** }

{ ******************************************************************************
  |* Historico
  |*
  |* 01/07/2015: Giovani Da Cruz
  |*  - Cria��o e distribui��o da Primeira Versao ShowDelphi
  ******************************************************************************* }
unit UCHistDataset;

interface

uses SysUtils, Classes, UCHist_Type, UCHist_Base, Forms,
  Db, UCConsts_Language;

Type
  TUCHist_DataSet = class(TComponent)
  private
    fDataSet: TDataSet;
    fOnNewRecord, fOnBeforeDelete, fOnBeforeEdit, fOnAfterPost
      : TDataSetNotifyEvent;
    fOptions: TUCHistOptions;
    fControl: TUCControlHistorico;
    procedure SetDataSet(const Value: TDataSet);
    procedure SetfControl(const Value: TUCControlHistorico);
    { Private declarations }
  protected
    DataSetInEdit: Boolean;
    AFields: Array of Variant;
    procedure NewRecord(DataSet: TDataSet);
    procedure BeforeDelete(DataSet: TDataSet);
    procedure BeforeEdit(DataSet: TDataSet);
    procedure AfterPost(DataSet: TDataSet);
    procedure AddHistory(AppID, Form, FormCaption, Event, Obs,
      TableName: String; UserId: Integer);
    Function GetValueFields: String;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    { Public declarations }
  published
    { Published declarations }
    Property DataSet: TDataSet Read fDataSet Write SetDataSet;
    Property ControlHistorico: TUCControlHistorico read fControl
      write SetfControl;
  end;

implementation

procedure TUCHist_DataSet.AddHistory(AppID, Form, FormCaption, Event, Obs,
  TableName: String; UserId: Integer);
begin
  If fControl.Active then
    fControl.UserControl.DataConnector.UCExecSQL
      (Format('INSERT INTO %s VALUES( %s, %d , %s , %s , %s , %s ,%s ,%s , %s )',
      [fControl.TableHistory.TableName, QuotedStr(AppID), UserId,
      QuotedStr(FormatDateTime('dd/mm/yyyy', date)),
      QuotedStr(FormatDateTime('hh:mm:ss', time)), QuotedStr(Form),
      QuotedStr(FormCaption), QuotedStr(Event), QuotedStr(Obs),
      QuotedStr(TableName)]));
end;

procedure TUCHist_DataSet.AfterPost(DataSet: TDataSet);
begin
  If Assigned(fOnAfterPost) then
    fOnAfterPost(DataSet);

  If ((DataSetInEdit = False) and (fControl.Options.SavePostInsert)) then
    // quando inserindo
    AddHistory(fControl.UserControl.ApplicationID, Screen.ActiveCustomForm.Name,
      Screen.ActiveCustomForm.Caption, fControl.HistoryMsg.Evento_Insert,
      GetValueFields, DataSet.Name, fControl.UserControl.CurrentUser.UserId);

  If ((DataSetInEdit = True) and (fControl.Options.SavePostEdit)) then
    // quando editando
    AddHistory(fControl.UserControl.ApplicationID, Screen.ActiveCustomForm.Name,
      Screen.ActiveCustomForm.Caption, fControl.HistoryMsg.Evento_Edit,
      GetValueFields, DataSet.Name, fControl.UserControl.CurrentUser.UserId);

  DataSetInEdit := False;
  SetLength(AFields, 0);
end;

procedure TUCHist_DataSet.Assign(Source: TPersistent);
begin
  if Source is TUCHist_DataSet then
  begin
    Self.DataSet := TUCHist_DataSet(Source).DataSet;
    Self.ControlHistorico := TUCHist_DataSet(Source).ControlHistorico;
  end
  else
    inherited;
end;

procedure TUCHist_DataSet.BeforeDelete(DataSet: TDataSet);
begin
  If Assigned(fOnBeforeDelete) then
    fOnBeforeDelete(DataSet);

  DataSetInEdit := False;
  SetLength(AFields, 0);

  If fControl.Options.SaveDelete then
    AddHistory(fControl.UserControl.ApplicationID, Screen.ActiveCustomForm.Name,
      Screen.ActiveCustomForm.Caption, fControl.HistoryMsg.Evento_Delete,
      GetValueFields, DataSet.Name, fControl.UserControl.CurrentUser.UserId);
end;

procedure TUCHist_DataSet.BeforeEdit(DataSet: TDataSet);
Var
  I: Integer;
begin
  // Antes de Editar
  If Assigned(fOnBeforeEdit) then
    fOnBeforeEdit(DataSet);

  DataSetInEdit := True;

  SetLength(AFields, DataSet.FieldCount);
  For I := 0 to DataSet.FieldCount - 1 do
  Begin
    If DataSet.Fields[I].IsBlob = False then
      AFields[I] := DataSet.Fields[I].Value
    else
      AFields[I] := 'Blob';
  End;
end;

constructor TUCHist_DataSet.Create(AOwner: TComponent);
begin
  inherited;
  DataSetInEdit := False;
  fOptions := TUCHistOptions.Create(Self);
  fDataSet := Nil;
  fControl := Nil;
end;

destructor TUCHist_DataSet.Destroy;
begin
  FreeAndNil(fOptions);
  inherited;
end;

function TUCHist_DataSet.GetValueFields: String;
Var
  Aux: Integer;
begin
  Result := '';

  for Aux := 0 to DataSet.FieldCount - 1 do
  begin
    if DataSet.Fields[Aux].IsBlob = False then
    begin
      if DataSet.Fields[Aux].FieldKind = fkData then
      begin
        with DataSet.Fields[Aux] do
        begin
          if DataSetInEdit = False then // inserindo ou deletando
            try
              Result := Result + Format('%-20s = %s ',
                [FieldName, AsString]) + #13#10;
            except
            end
          else
          begin // editando
            if fControl.Options.TypeSavePostEdit = tpSaveModifiedFields then
            begin
              if Value <> AFields[Aux] then
                try
                  Result := Result + Format('%s||%s||%s',
                    [FieldName, AFields[Aux], Value]) + #13#10;
                except
                end;
            end
            else
              try
                Result := Result + Format(' %s | | %s | | %s ',
                  [FieldName, AFields[Aux], Value]) + #13#10;
              except
              end;
          end;
        end;
      end;
    end;
  end; // for
end;

procedure TUCHist_DataSet.Loaded;
begin
  inherited;
  if not(csDesigning in ComponentState) then
  begin
    if not Assigned(ControlHistorico) then
      raise Exception.Create(Format(RetornaLingua(ucPortuguesBr,
        'Const_Hist_MsgExceptPropr'), ['ControlHistorico']));

    If fControl.Active = False then
      exit;

    if not Assigned(DataSet) then
      raise Exception.Create(Format(RetornaLingua(fControl.UserControl.Language,
        'Const_Hist_MsgExceptPropr'), ['DataSet']));

    fOnNewRecord := Nil;
    fOnBeforeDelete := Nil;
    fOnBeforeEdit := Nil;
    fOnAfterPost := Nil;

    If Assigned(DataSet.OnNewRecord) then
      fOnNewRecord := DataSet.OnNewRecord;

    If Assigned(DataSet.BeforeDelete) then
      fOnBeforeDelete := DataSet.BeforeDelete;

    If Assigned(DataSet.AfterPost) then
      fOnAfterPost := DataSet.AfterPost;

    If Assigned(DataSet.BeforeEdit) then
      fOnBeforeEdit := DataSet.BeforeEdit;

    DataSet.OnNewRecord := NewRecord;
    DataSet.BeforeDelete := BeforeDelete;
    DataSet.AfterPost := AfterPost;
    DataSet.BeforeEdit := BeforeEdit;
  end;
end;

procedure TUCHist_DataSet.NewRecord(DataSet: TDataSet);
begin
  If Assigned(fOnNewRecord) then
    fOnNewRecord(DataSet);

  DataSetInEdit := False; // Inserindo novo registro
  SetLength(AFields, 0);

  If fControl.Options.SaveNewRecord then
    AddHistory(fControl.UserControl.ApplicationID, Screen.ActiveCustomForm.Name,
      Screen.ActiveCustomForm.Caption, fControl.HistoryMsg.Evento_NewRecord,
      Format(RetornaLingua(fControl.UserControl.Language,
      'Const_Msg_NewRecord'), [fControl.UserControl.CurrentUser.UserName]),
      DataSet.Name, fControl.UserControl.CurrentUser.UserId);
end;

procedure TUCHist_DataSet.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) then
  begin
    If AComponent = fControl then
      fControl := Nil;

    if AComponent = fDataSet then
      fDataSet := Nil;
  end;

  inherited Notification(AComponent, AOperation);
end;

procedure TUCHist_DataSet.SetDataSet(const Value: TDataSet);
begin
  fDataSet := Value;
  if Assigned(Value) then
    Value.FreeNotification(Self);
end;

procedure TUCHist_DataSet.SetfControl(const Value: TUCControlHistorico);
begin
  fControl := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

end.
