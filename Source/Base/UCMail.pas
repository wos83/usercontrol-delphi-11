{ -----------------------------------------------------------------------------
  Unit Name: UCMail
  Author:    QmD
  Date:      09-nov-2004
  Purpose: Send Mail messages (forget password, user add/change/password force/etc)
  History: included indy 10 support
  ----------------------------------------------------------------------------- }
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
unit UCMail;

interface

{$I 'UserControl.inc'}

uses
  Classes,
  StdCtrls,
  Dialogs,
  SysUtils,

{$IFDEF DELPHIXE2_UP}
  System.UITypes,
  ALSMTPClient,
  ALInternetMessages,
  ALStringList,
{$ELSE}
  {$IFNDEF FPC}
  UCALSMTPClient,
  {$ENDIF}
{$ENDIF}
  UcConsts_Language;

type
  TUCMailMessage = class(TPersistent)
  private
    FAtivo: Boolean;
    FTitulo: String;
    FLines: TStrings;
    procedure SetLines(const Value: TStrings);
  protected
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Ativo: Boolean read FAtivo write FAtivo;
    property Titulo: String read FTitulo write FTitulo;
    property Mensagem: TStrings read FLines write SetLines;
  end;

  TUCMEsqueceuSenha = class(TUCMailMessage)
  private
    FLabelLoginForm: String;
    FMailEnviado: String;
  protected
  public
  published
    property LabelLoginForm: String read FLabelLoginForm write FLabelLoginForm;
    property MensagemEmailEnviado: String read FMailEnviado write FMailEnviado;
  end;

  TMessageTag = procedure(Tag: String; var ReplaceText: String) of object;

  TMailUserControl = class(TComponent)
  private
    FPorta: Integer;
    FEmailRemetente: String;
    FUsuario: String;
    FNomeRemetente: String;
    FSenha: String;
    FSMTPServer: String;
    FAdicionaUsuario: TUCMailMessage;
    FSenhaTrocada: TUCMailMessage;
    FAlteraUsuario: TUCMailMessage;
    FSenhaForcada: TUCMailMessage;
    FEsqueceuSenha: TUCMEsqueceuSenha;
    {$IFNDEF FPC}
    fAuthType: TAlSmtpClientAuthType;
    {$ENDIF}
    function ParseMailMSG(Nome, Login, Senha, Email, Perfil,
      txt: String): AnsiString;
    {$IFNDEF FPC}
    {$IFNDEF DELPHIXE2_UP}
    procedure onStatus(Status: String);
    {$ENDIF}
    {$ENDIF}
    function TrataSenha(Senha: String; Key: Word; GerarNova: Boolean;
      IDUser: Integer): String;
  protected
    function EnviaEmailTp(Nome, Login, USenha, Email, Perfil: String;
      UCMSG: TUCMailMessage): Boolean;
  public
    fUsercontrol: TComponent;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure EnviaEmailAdicionaUsuario(Nome, Login, Senha, Email,
      Perfil: String; Key: Word);
    procedure EnviaEmailAlteraUsuario(Nome, Login, Senha, Email, Perfil: String;
      Key: Word);
    procedure EnviaEmailSenhaForcada(Nome, Login, Senha, Email, Perfil: String);
    procedure EnviaEmailSenhaTrocada(Nome, Login, Senha, Email, Perfil: String;
      Key: Word);
    procedure EnviaEsqueceuSenha(ID: Integer; Nome, Login, Senha, Email,
      Perfil: String); // Key: Word
  published
    {$IFNDEF FPC}
    property AuthType: TAlSmtpClientAuthType read fAuthType write fAuthType;
    {$ENDIF}
    property ServidorSMTP: String read FSMTPServer write FSMTPServer;
    property Usuario: String read FUsuario write FUsuario;
    property Senha: String read FSenha write FSenha;
    property Porta: Integer read FPorta write FPorta default 0;
    property NomeRemetente: String read FNomeRemetente write FNomeRemetente;
    property EmailRemetente: String read FEmailRemetente write FEmailRemetente;
    property AdicionaUsuario: TUCMailMessage read FAdicionaUsuario
      write FAdicionaUsuario;
    property AlteraUsuario: TUCMailMessage read FAlteraUsuario
      write FAlteraUsuario;
    property EsqueceuSenha: TUCMEsqueceuSenha read FEsqueceuSenha
      write FEsqueceuSenha;
    property SenhaForcada: TUCMailMessage read FSenhaForcada
      write FSenhaForcada;
    property SenhaTrocada: TUCMailMessage read FSenhaTrocada
      write FSenhaTrocada;
  end;

implementation

uses
  ucBase,
  UCEMailForm_U, UCDataInfo;

function GeraSenha(Digitos: Integer; Min: Boolean; Mai: Boolean;
  Num: Boolean): string;
const
  MinC = 'abcdef';
  MaiC = 'ABCDEF';
  NumC = '1234567890';
var
  p, q: Integer;
  Char, Senha: String;
begin
  Char := '';
  If Min then
    Char := Char + MinC;
  If Mai then
    Char := Char + MaiC;
  If Num then
    Char := Char + NumC;
  for p := 1 to Digitos do
  begin
    Randomize;
    q := Random(Length(Char)) + 1;
    Senha := Senha + Char[q];
  end;
  Result := Senha;
end;

{ TMailAdicUsuario }

procedure TUCMailMessage.Assign(Source: TPersistent);
begin
  if Source is TUCMailMessage then
  begin
    Self.Ativo := TUCMailMessage(Source).Ativo;
    Self.Titulo := TUCMailMessage(Source).Titulo;
    Self.Mensagem.Assign(TUCMailMessage(Source).Mensagem);
  end
  else
    inherited;
end;

constructor TUCMailMessage.Create(AOwner: TComponent);
begin
  FLines := TStringList.Create;
end;

destructor TUCMailMessage.Destroy;
begin
  SysUtils.FreeAndNil(FLines);
  inherited;
end;

procedure TUCMailMessage.SetLines(const Value: TStrings);
begin
  FLines.Assign(Value);
end;

{ TMailUserControl }

constructor TMailUserControl.Create(AOwner: TComponent);
begin
  inherited;
  AdicionaUsuario := TUCMailMessage.Create(Self);
  AdicionaUsuario.FLines.Add
    ('<html> <head> <title>Inclus�o de Senha</title> <style type="text/css"> <!-- body { 	margin-left: 0px; '
    + #13#10 +
    'margin-top: 0px; 	margin-right: 0px; 	margin-bottom: 0px; } --> </style></head>'
    + #13#10 + '<body> <p>Aten��o: <br>Senha criada com sucesso:</p>' + #13#10 +
    '<table width="100%" border="0" cellspacing="2" cellpadding="0"> ' + #13#10
    + '<tr> ' + #13#10 +
    ' <td width="10%" align="right"><strong>Nome ..:&nbsp;</strong></td>' +
    #13#10 + '<td>:nome</td> ' + #13#10 + '</tr> ' + #13#10 + '<tr>' +
    '  <td align="right"><strong>Login ..:&nbsp;</strong></td>' + #13#10 +
    '  <td>:login</td>' + #13#10 + '</tr>' + #13#10 + '  <tr> ' + #13#10 +
    '    <td align="right"><strong>Nova Senha ..:&nbsp;</strong></td>' + #13#10
    + '    <td>:senha</td>' + #13#10 + '  </tr> ' + #13#10 + '<tr> ' + #13#10 +
    '<td align="right"><strong>Email ..:&nbsp;</strong></td>' + #13#10 +
    '<td>:email</td>' + #13#10 + '</tr> ' + #13#10 + '<tr>' + #13#10 +
    '<td align="right"><strong>Perfil ..:&nbsp;</strong></td>' + #13#10 +
    '<td>:perfil</td> ' + #13#10 + '</tr>' + #13#10 + '</table>' + #13#10 +
    '<p>Atenciosamente,</p>' + #13#10 +
    '<p>Administrador do sistema</p></body></html>');
  AdicionaUsuario.FTitulo := 'Inclus�o de usu�rio';

  AlteraUsuario := TUCMailMessage.Create(Self);
  AlteraUsuario.FLines.Add
    ('<html> <head> <title>Altera��o de Senha</title> <style type="text/css"> <!-- body { 	margin-left: 0px; '
    + #13#10 +
    'margin-top: 0px; 	margin-right: 0px; 	margin-bottom: 0px; } --> </style></head>'
    + #13#10 +
    '<body> <p>Aten��o: <br> Voc� solicitou uma altera��o de senha do sistema, sua senha foi alterada para a senha abaixo:</p>'
    + #13#10 +
    '<table width="100%" border="0" cellspacing="2" cellpadding="0"> ' + #13#10
    + '<tr> ' + #13#10 +
    ' <td width="10%" align="right"><strong>Nome ..:&nbsp;</strong></td>' +
    #13#10 + '<td>:nome</td> ' + #13#10 + '</tr> ' + #13#10 + '<tr>' +
    '  <td align="right"><strong>Login ..:&nbsp;</strong></td>' + #13#10 +
    '  <td>:login</td>' + #13#10 + '</tr>' + #13#10 + '  <tr> ' + #13#10 +
    '    <td align="right"><strong>Nova Senha ..:&nbsp;</strong></td>' + #13#10
    + '    <td>:senha</td>' + #13#10 + '  </tr> ' + #13#10 + '<tr> ' + #13#10 +
    '<td align="right"><strong>Email ..:&nbsp;</strong></td>' + #13#10 +
    '<td>:email</td>' + #13#10 + '</tr> ' + #13#10 + '<tr>' + #13#10 +
    '<td align="right"><strong>Perfil ..:&nbsp;</strong></td>' + #13#10 +
    '<td>:perfil</td> ' + #13#10 + '</tr>' + #13#10 + '</table>' + #13#10 +
    '<p>Atenciosamente,</p>' + #13#10 +
    '<p>Administrador do sistema</p></body></html>');
  AlteraUsuario.FTitulo := 'Altera��o de usu�rio';

  EsqueceuSenha := TUCMEsqueceuSenha.Create(Self);
  EsqueceuSenha.FLines.Add
    ('<html> <head> <title>Altera��o de Senha</title> <style type="text/css"> <!-- body { 	margin-left: 0px; '
    + #13#10 +
    'margin-top: 0px; 	margin-right: 0px; 	margin-bottom: 0px; } --> </style></head>'
    + #13#10 +
    '<body> <p>Aten��o: <br> Voc� solicitou um lembrete de senha do sistema, sua senha foi alterada para a senha abaixo:</p>'
    + #13#10 +
    '<table width="100%" border="0" cellspacing="2" cellpadding="0"> ' + #13#10
    + '<tr> ' + #13#10 +
    ' <td width="10%" align="right"><strong>Nome ..:&nbsp;</strong></td>' +
    #13#10 + '<td>:nome</td> ' + #13#10 + '</tr> ' + #13#10 + '<tr>' +
    '  <td align="right"><strong>Login ..:&nbsp;</strong></td>' + #13#10 +
    '  <td>:login</td>' + #13#10 + '</tr>' + #13#10 + '  <tr> ' + #13#10 +
    '    <td align="right"><strong>Nova Senha ..:&nbsp;</strong></td>' + #13#10
    + '    <td>:senha</td>' + #13#10 + '  </tr> ' + #13#10 + '<tr> ' + #13#10 +
    '<td align="right"><strong>Email ..:&nbsp;</strong></td>' + #13#10 +
    '<td>:email</td>' + #13#10 + '</tr> ' + #13#10 + '<tr>' + #13#10 +
    '<td align="right"><strong>Perfil ..:&nbsp;</strong></td>' + #13#10 +
    '<td>:perfil</td> ' + #13#10 + '</tr>' + #13#10 + '</table>' + #13#10 +
    '<p>Atenciosamente,</p>' + #13#10 +
    '<p>Administrador do sistema</p></body></html>');
  EsqueceuSenha.FTitulo := 'Altera��o de Senha';

  SenhaForcada := TUCMailMessage.Create(Self);
  SenhaForcada.FLines.Add
    ('<html> <head> <title>Altera��o de Senha For�ada</title> <style type="text/css"> <!-- body { 	margin-left: 0px; '
    + #13#10 +
    'margin-top: 0px; 	margin-right: 0px; 	margin-bottom: 0px; } --> </style></head>'
    + #13#10 +
    '<body> <p>Aten��o: <br> Voc� ou um administrador for�ou a troca de sua senha do sistema, sua senha foi alterada para a senha abaixo:</p>'
    + #13#10 +
    '<table width="100%" border="0" cellspacing="2" cellpadding="0"> ' + #13#10
    + '<tr> ' + #13#10 +
    ' <td width="10%" align="right"><strong>Nome ..:&nbsp;</strong></td>' +
    #13#10 + '<td>:nome</td> ' + #13#10 + '</tr> ' + #13#10 + '<tr>' +
    '  <td align="right"><strong>Login ..:&nbsp;</strong></td>' + #13#10 +
    '  <td>:login</td>' + #13#10 + '</tr>' + #13#10 + '  <tr> ' + #13#10 +
    '    <td align="right"><strong>Nova Senha ..:&nbsp;</strong></td>' + #13#10
    + '    <td>:senha</td>' + #13#10 + '  </tr> ' + #13#10 + '<tr> ' + #13#10 +
    '<td align="right"><strong>Email ..:&nbsp;</strong></td>' + #13#10 +
    '<td>:email</td>' + #13#10 + '</tr> ' + #13#10 + '<tr>' + #13#10 +
    '<td align="right"><strong>Perfil ..:&nbsp;</strong></td>' + #13#10 +
    '<td>:perfil</td> ' + #13#10 + '</tr>' + #13#10 + '</table>' + #13#10 +
    '<p>Atenciosamente,</p>' + #13#10 +
    '<p>Administrador do sistema</p></body></html>');
  SenhaForcada.FTitulo := 'Troca de senha for�ada';

  SenhaTrocada := TUCMailMessage.Create(Self);
  SenhaTrocada.FLines.Add
    ('<html> <head> <title>Altera��o de Senha</title> <style type="text/css"> <!-- body { 	margin-left: 0px; '
    + #13#10 +
    'margin-top: 0px; 	margin-right: 0px; 	margin-bottom: 0px; } --> </style></head>'
    + #13#10 +
    '<body> <p>Aten��o: <br> Voc� alterou sua senha do sistema, sua senha foi alterada para a senha abaixo:</p>'
    + #13#10 +
    '<table width="100%" border="0" cellspacing="2" cellpadding="0"> ' + #13#10
    + '<tr> ' + #13#10 +
    ' <td width="10%" align="right"><strong>Nome ..:&nbsp;</strong></td>' +
    #13#10 + '<td>:nome</td> ' + #13#10 + '</tr> ' + #13#10 + '<tr>' +
    '  <td align="right"><strong>Login ..:&nbsp;</strong></td>' + #13#10 +
    '  <td>:login</td>' + #13#10 + '</tr>' + #13#10 + '  <tr> ' + #13#10 +
    '    <td align="right"><strong>Nova Senha ..:&nbsp;</strong></td>' + #13#10
    + '    <td>:senha</td>' + #13#10 + '  </tr> ' + #13#10 + '<tr> ' + #13#10 +
    '<td align="right"><strong>Email ..:&nbsp;</strong></td>' + #13#10 +
    '<td>:email</td>' + #13#10 + '</tr> ' + #13#10 + '<tr>' + #13#10 +
    '<td align="right"><strong>Perfil ..:&nbsp;</strong></td>' + #13#10 +
    '<td>:perfil</td> ' + #13#10 + '</tr>' + #13#10 + '</table>' + #13#10 +
    '<p>Atenciosamente,</p>' + #13#10 +
    '<p>Administrador do sistema</p></body></html>');
  SenhaTrocada.FTitulo := 'Altera��o de senha';

  {$IFNDEF FPC}
  fAuthType := alsmtpClientAuthPlain;
  {$ENDIF}

  if csDesigning in ComponentState then
  begin
    Porta := 25;
    AdicionaUsuario.Ativo := True;
    AlteraUsuario.Ativo := True;
    EsqueceuSenha.Ativo := True;
    SenhaForcada.Ativo := True;
    SenhaTrocada.Ativo := True;
    EsqueceuSenha.LabelLoginForm := RetornaLingua(ucPortuguesBr,
      'Const_Log_LbEsqueciSenha');
    EsqueceuSenha.MensagemEmailEnviado := RetornaLingua(ucPortuguesBr,
      'Const_Log_MsgMailSend');
  end;

end;

destructor TMailUserControl.Destroy;
begin
  SysUtils.FreeAndNil(FAdicionaUsuario);
  SysUtils.FreeAndNil(FAlteraUsuario);
  SysUtils.FreeAndNil(FEsqueceuSenha);
  SysUtils.FreeAndNil(FSenhaForcada);
  SysUtils.FreeAndNil(FSenhaTrocada);

  inherited;
end;

procedure TMailUserControl.EnviaEmailAdicionaUsuario(Nome, Login, Senha, Email,
  Perfil: String; Key: Word);
begin
  Senha := TrataSenha(Senha, Key, False, 0);
  EnviaEmailTp(Nome, Login, Senha, Email, Perfil, AdicionaUsuario);
end;

procedure TMailUserControl.EnviaEmailAlteraUsuario(Nome, Login, Senha, Email,
  Perfil: String; Key: Word);
begin
  Senha := TrataSenha(Senha, Key, False, 0);
  EnviaEmailTp(Nome, Login, Senha, Email, Perfil, AlteraUsuario);
end;

procedure TMailUserControl.EnviaEmailSenhaForcada(Nome, Login, Senha, Email,
  Perfil: String);
begin
  EnviaEmailTp(Nome, Login, Senha, Email, Perfil, SenhaForcada);
end;

procedure TMailUserControl.EnviaEmailSenhaTrocada(Nome, Login, Senha, Email,
  Perfil: String; Key: Word);
begin
  EnviaEmailTp(Nome, Login, Senha, Email, Perfil, SenhaTrocada);
end;

function TMailUserControl.ParseMailMSG(Nome, Login, Senha, Email, Perfil,
  txt: String): AnsiString;
begin
  txt := StringReplace(txt, ':nome', Nome, [rfReplaceAll]);
  txt := StringReplace(txt, ':login', Login, [rfReplaceAll]);
  txt := StringReplace(txt, ':senha', Senha, [rfReplaceAll]);
  txt := StringReplace(txt, ':email', Email, [rfReplaceAll]);
  txt := StringReplace(txt, ':perfil', Perfil, [rfReplaceAll]);
  Result := AnsiString(txt);
end;

{$IFNDEF FPC}
{$IFNDEF DELPHIXE2_UP}
procedure TMailUserControl.onStatus(Status: String);
begin
  if not Assigned(UCEMailForm) then
    Exit;
  UCEMailForm.lbStatus.Caption := Status;
  UCEMailForm.Update;
end;
{$ENDIF}
{$ENDIF}

Function TMailUserControl.EnviaEmailTp(Nome, Login, USenha, Email,
  Perfil: String; UCMSG: TUCMailMessage): Boolean;
{$IFNDEF FPC}
var
  MailMsg: TAlSmtpClient;

{$IFDEF DELPHIXE2_UP}
  // - Ajuste de Emers0n em 01/12/2016
  MailRecipients: TALStringList;

  MailHeader: TALEmailHeader;
{$ELSE}
  MailRecipients: TStringList;
  MailHeader: TALSMTPClientHeader;
{$ENDIF}
begin
  Result := False;
  if Trim(Email) = '' then
    Exit;
  MailMsg := TAlSmtpClient.Create;

  {$IFDEF DELPHIXE2_UP}
  // MailMsg.OnStatus := OnStatus;


  MailRecipients := TALStringList.Create;
  MailHeader := TALEmailHeader.Create;
{$ELSE}
  MailMsg := TAlSmtpClient.Create;
  MailMsg.onStatus := onStatus;
  MailRecipients := TStringList.Create;
{$ENDIF}
  MailHeader.From := AnsiString(EmailRemetente);
  MailHeader.SendTo := AnsiString(Email);
  MailHeader.ContentType := 'text/html';
  MailRecipients.Append(AnsiString(Email));
  MailHeader.Subject := AnsiString(UCMSG.Titulo);

  try
    try
      UCEMailForm := TUCEMailForm.Create(Self);
      UCEMailForm.lbStatus.Caption := '';
      UCEMailForm.Show;
      UCEMailForm.Update;

      MailMsg.SendMail(AnsiString(ServidorSMTP), FPorta, AnsiString(EmailRemetente), MailRecipients,
        AnsiString(Usuario), AnsiString(Senha), fAuthType, MailHeader.RawHeaderText,
        ParseMailMSG(Nome, Login, USenha, Email, Perfil, UCMSG.Mensagem.Text));

      UCEMailForm.Update;
      Result := True;
    except
      on e: Exception do
      begin
        UCEMailForm.Close;
        MessageDlg(e.Message, mtWarning, [mbok], 0);
        raise;
      end;
    end;
  finally
    FreeAndNil(MailMsg);
    FreeAndNil(MailHeader);
    FreeAndNil(MailRecipients);
    FreeAndNil(UCEMailForm);
  end;
{$ELSE}
begin
{$ENDIF}
end;

procedure TMailUserControl.EnviaEsqueceuSenha(ID: Integer;
  Nome, Login, Senha, Email, Perfil: String);
Var
  NovaSenha: String;
begin
  if Length(Trim(Email)) <> 0 then
  Begin
    try
      NovaSenha := TrataSenha(Senha, 0, True, ID);
      If EnviaEmailTp(Nome, Login, NovaSenha, Email, Perfil, EsqueceuSenha) = True
      then
      Begin
        TUserControl(fUsercontrol).ChangePassword(ID, NovaSenha);
        MessageDlg(EsqueceuSenha.MensagemEmailEnviado, mtInformation,
          [mbok], 0);
      End
      else
        MessageDlg('N�o foi possivel enviar nova senha', mtInformation,
          [mbok], 0);
    except
    end;
  End;
end;
{$WARNINGS OFF}

function TMailUserControl.TrataSenha(Senha: String; Key: Word;
  GerarNova: Boolean; IDUser: Integer): String;
Var
  Min, Mai: Boolean;
begin
  Min := True;
  Mai := True;
  if TUserControl(fUsercontrol).Login.CharCasePass = ecLowerCase then
    Mai := False
  else if TUserControl(fUsercontrol).Login.CharCasePass = ecUpperCase then
    Min := False;

  if TUserControl(fUsercontrol).Criptografia = cPadrao then
  Begin
    if GerarNova = True then
    Begin
      // Aqui o componente irar gerar uma nova senha e enviar para o usuario
      Senha := GeraSenha(10, Min, Mai, True);
      Result := Senha;
    End
    else
      Result := Decrypt(Senha, Key);
  End
  else
  Begin
    if GerarNova = True then
    Begin
      // Aqui o componente irar gerar uma nova senha e enviar para o usuario
      Senha := GeraSenha(10, Min, Mai, True);
      Result := Senha;
    End
    else
      Result := '';
  End;
end;
{$WARNINGS ON}

end.
