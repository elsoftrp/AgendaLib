unit AgendaLib.Base;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.DateUtils,
  System.Math,
  Vcl.Grids,
  Vcl.Graphics,
  Winapi.Windows,
  System.Generics.Defaults,
  AgendaLib.Interfaces,
  AgendaLib.Pessoas,
  AgendaLib.Profissionais,
  AgendaLib.Entity.Profissional,
  AgendaLib.Entity.Agenda;

type
  TAgenda = AgendaLib.Entity.Agenda.TAgenda;
  TProfissional = AgendaLib.Entity.Profissional.TProfissional;
  IAgendaLib = AgendaLib.Interfaces.IAgendaLib;

  TAgendaLib = class(TInterfacedObject, IAgendaLib)
  private
    FPessoasAgenda: TList<IPessoaAgenda>;
    FProfissionaisAgenda: TList<IProfissionalAgenda>;
    FData: TDateTime;
    FHoras: TObjectList<THoraAgenda>;
    FHorarios: TObjectList<TAgenda>;
    FListaAgenda: TObjectList<TAgenda>;
    FProfissionais: TObjectList<TProfissional>;
    FGrid: TStringGrid;
    FAgendaReservadoClick: TAgendaReservadoClick;
    FAgendaDisponivelClick: TAgendaDisponivelClick;
    procedure CarregarPessoas;
    function ObjetoHora(aHora: TDateTime): THoraAgenda;
    function TemAgendamento(aDataHora: TDateTime; aProfissionalId: Integer;
      out aAgenda: TAgenda): Boolean;
    function TemIndisponivel(aDataHora: TDateTime; aProfissionalId: Integer;
      out aAgenda: TAgenda): Boolean;
    function ObjetoHorario(aHorario: TDateTime;
      aProfissionaId: Integer): TAgenda;
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure GridDblClick(Sender: TObject);
  public
    constructor Create(aStringGrid: TStringGrid);
    destructor Destroy; override;
    class function New(aStringGrid: TStringGrid) : IAgendaLib;
    function LimparAgenda: IAgendaLib;
    function AddOnClickReservado(aProcedure: TAgendaReservadoClick): IAgendaLib;
    function AddOnClickDisponivel(aProcedure: TAgendaDisponivelClick): IAgendaLib;
    function Pessoa: IPessoaAgenda;
    function Profissional: IProfissionalAgenda;
    function Data(aValue: TDateTime): IAgendaLib;
    procedure Carregar;
    function AgendamentoDisponivelOuReservado: Boolean;
    function TemAgendamentoGrid: Boolean;
    function CodigoAgendaSelecionado: Integer;
    procedure DataEProfissionalSelecionado(out aDataHora: TDateTime; out aProfissionalId: Integer);
  end;

implementation

{ TAgendaLib }

function TAgendaLib.Pessoa: IPessoaAgenda;
var
  LPessoa: IPessoaAgenda;
begin
  LPessoa := TPessoaAgenda.New(Self);
  FPessoasAgenda.Add( LPessoa );
  Result := LPessoa;
end;

function TAgendaLib.Profissional: IProfissionalAgenda;
var
  LProfissional : IProfissionalAgenda;
begin
  LProfissional := TProfissionalAgenda.New(Self);
  FProfissionaisAgenda.Add(LProfissional);
  Result := LProfissional;
end;

function TAgendaLib.AddOnClickDisponivel(
  aProcedure: TAgendaDisponivelClick): IAgendaLib;
begin
  Result := Self;
  FAgendaDisponivelClick := aProcedure;
end;

function TAgendaLib.AddOnClickReservado(
  aProcedure: TAgendaReservadoClick): IAgendaLib;
begin
  Result := Self;
  FAgendaReservadoClick := aProcedure;
end;

function TAgendaLib.AgendamentoDisponivelOuReservado: Boolean;
var
  LAgenda: TAgenda;
begin
  Result := False;
  if not Assigned(FGrid) or (FPessoasAgenda.Count = 0)  then
    exit;

  if Assigned(FGrid.Objects[FGrid.Col, FGrid.Row]) then
  begin
    LAgenda := FGrid.Objects[FGrid.Col, FGrid.Row] as TAgenda;
    Result := LAgenda.Reservado or LAgenda.Disponivel;
  end;
end;

procedure TAgendaLib.Carregar;
var
  LHorario : TAgenda;
  LHora: THoraAgenda;
  LTamanhoCol: Integer;
  LHoraInicial, LHoraFinal: TDateTime;
  LRow: Integer;
  LHorasDia: TList<TDateTime>;
begin
  CarregarPessoas;

  FHoras.Clear;
  LHoraInicial := IncHour(FData, 5); // StrToDateTime('24/01/2023 05:00');
  LHoraFinal := IncHour(FData, 23); // StrToDateTime('24/01/2023 23:30');
  LHorasDia := TList<TDateTime>.Create;

  while (LHoraInicial <= LHoraFinal) do
  begin
    LHorasDia.Add(LHoraInicial);
    LHoraInicial := IncMinute( LHoraInicial, 30);
  end;

  for LHorario in FListaAgenda do
  begin
    if not LHorasDia.Contains(LHorario.DataHora) then
      LHorasDia.Add(LHorario.DataHora);
  end;

  LHorasDia.Sort;
  FGrid.ColCount := FProfissionais.Count + 1;
  FGrid.RowCount := LHorasDia.Count + 1;
  FGrid.FixedCols := 1;
  FGrid.FixedRows := 1;
//  lblTitulo.Caption := FormatDateTime('dddd, dd "de" mmmm ', LHoraInicial);

  LTamanhoCol := Trunc((FGrid.Width-FGrid.ColWidths[0]) / FProfissionais.Count)-3;

  for var Item := 1 to FProfissionais.Count  do
  begin
    FGrid.Cols[Item].Text := FProfissionais.Items[Item-1].Nome;
    FGrid.ColWidths[Item] := LTamanhoCol;
  end;

  LRow := 1;
  for var I := 1 to LHorasDia.Count do
  begin
    LHoraInicial := LHorasDia.Items[I-1];
    if Format('%s',[ FormatDateTime('HH MM', LHoraInicial)]).EndsWith('00') then
      FGrid.Rows[LRow].Text := Format('%s',[ FormatDateTime('HH', LHoraInicial)]) + ' ⁰⁰';
    LHora := ObjetoHora(LHoraInicial);
    FGrid.Objects[ 0, LRow] := LHora;
    FHoras.Add(LHora);

    for var LCol := 1 to FProfissionais.Count do
    begin
      if TemAgendamento(LHoraInicial, FProfissionais.Items[LCol-1].Id, LHorario) then
      begin
        FGrid.Cells[LCol, LRow] := Format('%s - %s',[ Format('%s',[ FormatDateTime('HH:MM', LHorario.DataHora)]), LHorario.Nome ]);
        FGrid.Objects[ LCol, LRow] := LHorario;
      end
      else if TemIndisponivel(LHoraInicial, FProfissionais.Items[LCol-1].Id, LHorario) then
      begin
        FGrid.Cells[LCol, LRow] := Format('%s - %s',[ Format('%s',[ FormatDateTime('HH:MM', LHorario.DataHora)]), LHorario.MensagemIndisponivel ]);
        FGrid.Objects[ LCol, LRow] := LHorario;
      end
      else
      begin
        LHorario := ObjetoHorario( LHoraInicial, FProfissionais.Items[LCol-1].Id);
        FHorarios.Add(LHorario);
        FGrid.Objects[ LCol, LRow] := LHorario;
      end;
    end;

    Inc(LRow);
  end;

  LHorasDia.Free;
  LHora := nil;
  for LRow := 1 to FGrid.RowCount do
  begin
    if Assigned(FGrid.Objects[0, LRow]) then
    begin
      LHora := FGrid.Objects[0, LRow] as THoraAgenda;
    end;
    if  Assigned(LHora) and (HourOf(LHora.Hora) = HourOf(Now))  then
    begin
      FGrid.Col := 1;
      FGrid.TopRow := LRow;
      FGrid.SetFocus;
      Break;
    end;
  end;

end;

function TAgendaLib.ObjetoHora(aHora:TDateTime): THoraAgenda;
begin
  Result := THoraAgenda.Create;
  Result.Hora := aHora;
end;

function TAgendaLib.ObjetoHorario(aHorario: TDateTime; aProfissionaId: Integer): TAgenda;
begin
  Result := TAgenda.Create;
  Result.ProfissionalId := aProfissionaId;
  Result.DataHora := aHorario;
  Result.Reservado := False;
  Result.Disponivel := True;
end;

function TAgendaLib.TemAgendamento(aDataHora: TDateTime;
  aProfissionalId: Integer; out aAgenda: TAgenda): Boolean;
begin
  Result := False;
  for var agenda in FListaAgenda do
  begin
    if (agenda.DataHora = aDataHora) and (agenda.ProfissionalId = aProfissionalId) and (agenda.Reservado) then
    begin
      aAgenda := agenda;
      Result := True;
      Break;
    end;
  end;
end;

function TAgendaLib.TemAgendamentoGrid: Boolean;
var
  LAgenda: TAgenda;
begin
  Result := False;
  if not Assigned(FGrid) or (FPessoasAgenda.Count = 0)  then
    exit;

  if Assigned(FGrid.Objects[FGrid.Col, FGrid.Row]) then
  begin
    LAgenda := FGrid.Objects[FGrid.Col, FGrid.Row] as TAgenda;
    Result := LAgenda.Reservado and not LAgenda.Disponivel;
  end;
end;

function TAgendaLib.TemIndisponivel(aDataHora: TDateTime;
  aProfissionalId: Integer; out aAgenda: TAgenda): Boolean;
begin
  Result := False;
  for var agenda in FListaAgenda do
  begin
    if (agenda.DataHora = aDataHora) and (agenda.ProfissionalId = aProfissionalId) and (not agenda.Reservado) and (not agenda.Disponivel) then
    begin
      aAgenda := agenda;
      Result := True;
      Break;
    end;
  end;
end;

procedure TAgendaLib.CarregarPessoas;
var
  LPessoa : TAgenda;
  LProfissional: TProfissional;
begin
  FListaAgenda.Clear;

  for var PessoaAgenda in FPessoasAgenda  do
  begin
    LPessoa := TAgenda.Create;
    LPessoa.Id := PessoaAgenda.Id;
    LPessoa.Nome := PessoaAgenda.Nome;
    LPessoa.Telefone := PessoaAgenda.Telefone;
    LPessoa.DataHora := PessoaAgenda.DataHora;
    LPessoa.ProfissionalId := PessoaAgenda.ProfissionalId;
    LPessoa.Reservado := PessoaAgenda.Reservado;
    LPessoa.Disponivel := PessoaAgenda.Disponivel;
    LPessoa.MensagemIndisponivel := PessoaAgenda.MensagemIndisponivel;
    FListaAgenda.Add(LPessoa);
  end;

  FProfissionais.Clear;

  for var ProfissionalAgenda in FProfissionaisAgenda do
  begin
    LProfissional := TProfissional.Create;
    LProfissional.Id := ProfissionalAgenda.Id;
    LProfissional.Nome := ProfissionalAgenda.Nome;
    FProfissionais.Add(LProfissional);
  end;
end;

function TAgendaLib.CodigoAgendaSelecionado: Integer;
var
  LAgenda: TAgenda;
begin
  Result := -1;
  if Assigned(FGrid.Objects[FGrid.Col, FGrid.Row]) then
  begin
    LAgenda := FGrid.Objects[FGrid.Col, FGrid.Row] as TAgenda;
    if LAgenda.Reservado then
      Result := LAgenda.Id;
  end;
end;

constructor TAgendaLib.Create(aStringGrid: TStringGrid);
begin
  FData := Int(Now);
  FGrid := aStringGrid;
  if Assigned(FGrid) then
  begin
    FGrid.OnDrawCell := GridDrawCell;
    FGrid.OnDblClick := GridDblClick;
  end;

  FListaAgenda := TObjectList<TAgenda>.Create(True);
  FProfissionais := TObjectList<TProfissional>.Create(True);
  FHorarios := TObjectList<TAgenda>.Create(True);
  FHoras := TObjectList<THoraAgenda>.Create(True);

  FPessoasAgenda := TList<IPessoaAgenda>.Create;
  FProfissionaisAgenda := TList<IProfissionalAgenda>.Create;
end;

function TAgendaLib.Data(aValue: TDateTime): IAgendaLib;
begin
  Result := Self;
  FData := aValue;
end;

procedure TAgendaLib.DataEProfissionalSelecionado(out aDataHora: TDateTime;
  out aProfissionalId: Integer);
var
  LAgenda: TAgenda;
begin
  aProfissionalId := -1;
  aDataHora := 0;

  if Assigned(FGrid.Objects[FGrid.Col, FGrid.Row]) then
  begin
    LAgenda := FGrid.Objects[FGrid.Col, FGrid.Row] as TAgenda;
    if not LAgenda.Reservado and LAgenda.Disponivel then
    begin
      aProfissionalId := LAgenda.ProfissionalId;
      aDataHora := LAgenda.DataHora;
    end;
  end;
end;

destructor TAgendaLib.Destroy;
begin
  FPessoasAgenda.Free;
  FProfissionaisAgenda.Free;
  FHoras.Free;
  FHorarios.Free;
  FListaAgenda.Free;
  FProfissionais.Free;

  inherited;
end;

class function TAgendaLib.New(aStringGrid: TStringGrid): IAgendaLib;
begin
  Result := Self.Create(aStringGrid);
end;

procedure TAgendaLib.GridDblClick(Sender: TObject);
var
  LAgenda: TAgenda;
begin
  if Assigned(FGrid.Objects[FGrid.Col, FGrid.Row]) then
  begin
    LAgenda := FGrid.Objects[FGrid.Col, FGrid.Row] as TAgenda;
    if LAgenda.Reservado and Assigned(FAgendaReservadoClick) then
      FAgendaReservadoClick(LAgenda.Id, LAgenda.Nome, LAgenda.Telefone, LAgenda.ProfissionalId, LAgenda.DataHora)
    else if LAgenda.Disponivel and Assigned(FAgendaDisponivelClick) then
      FAgendaDisponivelClick(LAgenda.ProfissionalId, LAgenda.DataHora);
  end;
end;

procedure TAgendaLib.GridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  LAgenda: TAgenda;
  LHora: THoraAgenda;
begin
  LAgenda := nil;
  LHora := nil;
  if (ACol > 0 ) then
  begin
    if Assigned(FGrid.Objects[ACol, ARow]) then
    begin
      LAgenda := FGrid.Objects[ACol, ARow] as TAgenda;
    end;

    if gdFixed in State then
    begin
      FGrid.Canvas.Brush.Color := clBtnFace;
      FGrid.Canvas.Font.Color := clWindowText;
      FGrid.Canvas.Font.Style := [TFontStyle.fsBold];
      FGrid.Canvas.Font.Size := 12;
      FGrid.Canvas.Font.Name := 'Arial';
      FGrid.Canvas.FillRect(Rect);
      FGrid.Canvas.TextOut(Rect.Left + 10, Rect.Top + 2, FGrid.Cells[ACol, ARow]);
    end
    else if gdFocused in State then
    begin
      if Assigned(FGrid.Objects[ACol, ARow]) and Assigned(LAgenda) and not LAgenda.Nome.IsEmpty then
      begin
        FGrid.Canvas.Brush.Color := clWhite;
        FGrid.Canvas.Font.Color := clWindowText;
      end
      else
      begin
        FGrid.Canvas.Brush.Color := clNavy;
        FGrid.Canvas.Font.Color := clWhite;
      end;
      FGrid.Canvas.FillRect(Rect);
      FGrid.Canvas.TextOut(Rect.Left + 10, Rect.Top + 5, FGrid.Cells[ACol, ARow]);
    end
    else
    begin
      if Assigned(FGrid.Objects[ACol, ARow]) and Assigned(LAgenda) and LAgenda.Reservado then
      begin
        FGrid.Canvas.Brush.Color := clWhite;
        FGrid.Canvas.Font.Color := clWindowText;
      end
      else if Assigned(FGrid.Objects[ACol, ARow]) and Assigned(LAgenda) and not LAgenda.Reservado and not LAgenda.Disponivel then
      begin
        FGrid.Canvas.Brush.Color := $171BC1;
        FGrid.Canvas.Font.Color := clWhite;
      end
      else
      begin
        FGrid.Canvas.Font.Color := clWindowText;
        if Odd(ACol) then
          FGrid.Canvas.Brush.Color := $D5FFFF
        else
          FGrid.Canvas.Brush.Color := $BCECD5;
      end;

      FGrid.Canvas.FillRect(Rect);
      FGrid.Canvas.TextOut(Rect.Left + 10, Rect.Top + 5, FGrid.Cells[ACol, ARow]);
    end;
  end;

  if (ACol = 0) then
  begin
    if Assigned(FGrid.Objects[ACol, ARow]) then
    begin
      LHora := FGrid.Objects[ACol, ARow] as THoraAgenda;
    end;

    if gdFixed in State then
    begin
      if  Assigned(LHora) and (HourOf(LHora.Hora) = HourOf(Now))  then
        FGrid.Canvas.Brush.Color := $00A5FF
      else
        FGrid.Canvas.Brush.Color := clBtnFace;
      FGrid.Canvas.Font.Color := clWindowText;
      FGrid.Canvas.Font.Style := [TFontStyle.fsBold, TFontStyle.fsUnderline];
      FGrid.Canvas.Font.Size := 14;
      FGrid.Canvas.Font.Name := 'Segoe UI';
    end;

    FGrid.Canvas.FillRect(Rect);
    FGrid.Canvas.TextOut(Rect.Left + 10, Rect.Top + 2, FGrid.Cells[ACol, ARow]);
  end;
end;


function TAgendaLib.LimparAgenda: IAgendaLib;
begin
  Result := Self;
  FPessoasAgenda.Clear;
  FPessoasAgenda.TrimExcess;
  FProfissionaisAgenda.Clear;
  FProfissionaisAgenda.TrimExcess;
end;

end.
