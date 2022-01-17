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
unit UCIdle;

interface

uses Classes, UCBase, Dialogs,
{$IFDEF FPC}
  {$IFDEF WINDOWS}Windows,{$ELSE}LCLType,{$ENDIF}
  {$ELSE}
  Windows,
  {$ENDIF}
Forms, ExtCtrls, Messages, SysUtils;

type

  TUCIdle = class;
  TUCIdleTimeLeft = procedure(TimeLeft: Integer) of Object;

  TThUCIdle = class(TThread)
  private
    procedure DoIdle;
    procedure TimeLeftSinc;
  protected
    procedure Execute; override;
  public
    CurrentMilisec: Integer;
    UCIdle: TUCIdle;
  end;

  TUCIdle = class(TComponent)
  private
    FThIdle: TThUCIdle;
    FTimeOut: Integer;
    FOnIdle: TNotifyEvent;
    FUserControl: TUserControl; // changed from FUCComp to FUserControl
    {$IFNDEF FPC}
    FOnAppMessage: TMessageEvent;
    {$ENDIF}
    FTimeLeftNotify: TUCIdleTimeLeft;
    procedure UCAppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure SetUserControl(const Value: TUserControl);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation);
      override; // added by fduenas
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoIdle;
  published
    property UserControl: TUserControl read FUserControl write SetUserControl;
    // changed by fduenas
    property OnIdle: TNotifyEvent read FOnIdle write FOnIdle;
    property OnTimeLeftNotify: TUCIdleTimeLeft read FTimeLeftNotify
      write FTimeLeftNotify;
    property Timeout: Integer read FTimeOut write FTimeOut;
  end;

implementation

{ TUCIdle }

constructor TUCIdle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TUCIdle.Destroy;
begin
  FreeAndNil(FThIdle);
  inherited;
end;

procedure TUCIdle.DoIdle;
begin
  if Assigned(UserControl) and (UserControl.CurrentUser.UserID <> 0) then
    UserControl.Logoff;
  if Assigned(OnIdle) then
    OnIdle(Self);
end;

procedure TUCIdle.Loaded;
begin
  inherited;
  if not(csDesigning in ComponentState) then
    if (Assigned(UserControl)) or (Assigned(OnIdle)) then
    begin
      {$IFNDEF FPC}
      if Assigned(Application.OnMessage) then
        FOnAppMessage := Application.OnMessage;
      Application.OnMessage := UCAppMessage;
      FThIdle := TThUCIdle.Create(True);
      FThIdle.CurrentMilisec := 0;
      FThIdle.UCIdle := Self;
      FThIdle.Resume;
      {$ENDIF}
    end;
end;

procedure TUCIdle.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  If AOperation = opRemove then
    If AComponent = FUserControl then
      FUserControl := nil;
  inherited Notification(AComponent, AOperation);

end;

procedure TUCIdle.SetUserControl(const Value: TUserControl);
begin
  FUserControl := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TUCIdle.UCAppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.message = wm_mousemove) or (Msg.message = wm_keydown) then
    FThIdle.CurrentMilisec := 0;

  {$IFNDEF FPC}
  if Assigned(FOnAppMessage) then
    FOnAppMessage(Msg, Handled);
  {$ENDIF}
end;

{ TThUCIdle }

procedure TThUCIdle.DoIdle;
begin
  UCIdle.DoIdle;
end;

procedure TThUCIdle.TimeLeftSinc;
begin
  if Assigned(UCIdle.OnTimeLeftNotify) then
    UCIdle.OnTimeLeftNotify(UCIdle.Timeout - CurrentMilisec);
end;

procedure TThUCIdle.Execute;
begin
  while not Terminated do
  begin
    Sleep(1000);
    if UCIdle.Timeout <= CurrentMilisec then
    begin
      CurrentMilisec := 0;
      {$IFNDEF FPC}
      Synchronize(DoIdle);
      {$ENDIF}
    end
    else
    begin
      Inc(CurrentMilisec, 1000);
      {$IFNDEF FPC}
      Synchronize(TimeLeftSinc);
      {$ENDIF}
    end;
  end;
end;

end.
