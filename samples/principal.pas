unit principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Generics.Collections, System.DateUtils, System.Math, System.Generics.Defaults,
  Vcl.Menus, AgendaLib.Base;

type
  TfrmPrincipal = class(TForm)
    GridAgenda: TStringGrid;
    popAgenda: TPopupMenu;
    Agendar1: TMenuItem;
    ConsultarAgenda1: TMenuItem;
    AlterarAgenda1: TMenuItem;
    MarcarcomoAtendido1: TMenuItem;
    CancelarAgendamento1: TMenuItem;
    Buscarporagendamento1: TMenuItem;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    procedure Agendar1Click(Sender: TObject);
    procedure ConsultarAgenda1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure popAgendaPopup(Sender: TObject);
  private
    FAgendaLib: IAgendaLib;
    procedure OrdernarAgenda;
    procedure EventoClickReservado(aId: Integer; aNome, aTelefone: string;
      aProfissionalId: Integer; aDataHora: TDateTime);
    procedure EventoClickDisponivel(aProfissionalId: Integer;
      aDataHora: TDateTime);
  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.Agendar1Click(Sender: TObject);
var
  LData: TDateTime;
  LProfissional: Integer;
begin
  FAgendalib.DataEProfissionalSelecionado(LData, LProfissional);
  if (LData > 0) and (LProfissional <> -1) then
  begin
    //Chama o formulaio para cadastrar agenda
  end;
end;

procedure TfrmPrincipal.ConsultarAgenda1Click(Sender: TObject);
begin
  if FAgendaLib.CodigoAgendaSelecionado > -1 then
  begin
    // abrir a agenda para consulta ou alterar
  end;
end;

procedure TfrmPrincipal.OrdernarAgenda;
begin
//  FListaAgenda.Sort(TComparer<TAgenda>.Construct(
//        function (const L, R: TAgenda): integer
//        begin
//           Result := CompareDate(L.DataHora, R.DataHora);
//        end
//  ));
end;

procedure TfrmPrincipal.EventoClickReservado(aId: Integer; aNome, aTelefone: string; aProfissionalId: Integer; aDataHora: TDateTime);
begin
  ShowMessage('Horario agenda para '+ aNome);
end;

procedure TfrmPrincipal.EventoClickDisponivel(aProfissionalId: Integer; aDataHora: TDateTime );
begin
  ShowMessage('Deseja agendar horario ?');
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  FAgendaLib := TAgendaLib.New(GridAgenda)
    .Data(StrToDateTime('24/01/2023'))
    .AddOnClickReservado(EventoClickReservado)
    .AddOnClickDisponivel(EventoClickDisponivel)
    .LimparAgenda;

  FAgendaLib.Pessoa.Id(1).Nome('Edson Ramos').Telefone('98989898').DataHora(StrToDateTime('24/01/2023  14:00')).ProfissionalId(1).Reservado(True).Disponivel(False).Add
    .Pessoa.Id(2).Nome('João da Silva').Telefone('98989898').DataHora(StrToDateTime('24/01/2023  14:15')).ProfissionalId(2).Reservado(True).Disponivel(False).Add
    .Pessoa.Id(3).Nome('Vitor Hugo Ramos').Telefone('98989898').DataHora(StrToDateTime('24/01/2023  15:00')).ProfissionalId(2).Reservado(True).Disponivel(False).Add
    .Pessoa.Id(4).Nome('Maria das Graças').Telefone('98989898').DataHora(StrToDateTime('24/01/2023  15:30')).ProfissionalId(1).Reservado(True).Disponivel(False).Add
    .Pessoa.Id(5).MensagemIndisponivel('Folga').DataHora(StrToDateTime('24/01/2023  16:30')).ProfissionalId(1).Reservado(False).Disponivel(False).Add;

  FAgendaLib.Profissional.Id(1).Nome('Dentista').Add;
  FAgendaLib.Profissional.Id(2).Nome('Terapeuta').Add;

  FAgendaLib.Carregar;
  lblTitulo.Caption := FormatDateTime('dddd, dd "de" mmmm ', StrToDateTime('24/01/2023'));
end;

procedure TfrmPrincipal.popAgendaPopup(Sender: TObject);
var
  LTemAgendamento: Boolean;
  LDisponivelOuReservado: Boolean;
begin
  LDisponivelOuReservado := FAgendaLib.AgendamentoDisponivelOuReservado;
  LTemAgendamento := LDisponivelOuReservado and FAgendaLib.TemAgendamentoGrid;

  Agendar1.Visible := LDisponivelOuReservado and not LTemAgendamento;
  Buscarporagendamento1.Visible := LDisponivelOuReservado and not LTemAgendamento;
  ConsultarAgenda1.Visible := LDisponivelOuReservado and LTemAgendamento;
  AlterarAgenda1.Visible := LDisponivelOuReservado and LTemAgendamento;
  MarcarcomoAtendido1.Visible := LDisponivelOuReservado and LTemAgendamento;
  CancelarAgendamento1.Visible := LDisponivelOuReservado and LTemAgendamento;

end;

end.
