program UserControl_Tut01;

{$MODE Delphi}

uses
  Forms, Interfaces,
  UPrincipal in 'UPrincipal.pas' {FrmPrincipal},
  UDmUC in 'UDmUC.pas' {dmUC: TDataModule},
  UBanco in 'UBanco.pas' {FrmBanco},
  UCliente in 'UCliente.pas' {FrmCliente};

{.$R *.res}

begin
  Application.Initialize;
  Application.Title := 'UserControl - Exemplo com Zeos Connector';
  Application.CreateForm(TdmUC, dmUC);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
