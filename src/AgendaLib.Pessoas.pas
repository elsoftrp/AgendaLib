unit AgendaLib.Pessoas;

interface

uses
  AgendaLib.Interfaces;

type
  TPessoaAgenda = class(TInterfacedObject, IPessoaAgenda)
  private
    [weak]
    FParent : IAgendaLib;
    FId: Integer;
    FNome: string;
    FTelefone: string;
    FDataHora: TDateTime;
    FProfissionalId: Integer;
    FReservado : Boolean;
    FDisponivel: Boolean;
    FMensagemIndisponivel: string;
  public
    constructor Create(aParent: IAgendaLib);
    destructor Destroy; override;
    class function New(aParent: IAgendaLib) : IPessoaAgenda;
    function Id(aValue: Integer): IPessoaAgenda; overload;
    function Nome(aValue: string): IPessoaAgenda; overload;
    function Telefone(aValue: string): IPessoaAgenda; overload;
    function DataHora(aValue: TDateTime): IPessoaAgenda; overload;
    function ProfissionalId(aValue: Integer): IPessoaAgenda; overload;
    function Reservado(aValue: Boolean): IPessoaAgenda; overload;
    function Disponivel(aValue: Boolean): IPessoaAgenda; overload;
    function MensagemIndisponivel(aValue: string): IPessoaAgenda; overload;
    function Add: IAgendaLib;
    function Id: Integer; overload;
    function Nome: string; overload;
    function Telefone: string; overload;
    function DataHora: TDateTime; overload;
    function ProfissionalId: Integer; overload;
    function Reservado: Boolean; overload;
    function Disponivel: Boolean; overload;
    function MensagemIndisponivel: string; overload;
  end;

implementation

{ TPessoaAgenda }

function TPessoaAgenda.Add: IAgendaLib;
begin
  Result := FParent;
end;

function TPessoaAgenda.Id: Integer;
begin
  Result := FId;
end;

function TPessoaAgenda.MensagemIndisponivel: string;
begin
  Result := FMensagemIndisponivel;
end;

function TPessoaAgenda.MensagemIndisponivel(aValue: string): IPessoaAgenda;
begin
  Result := Self;
  FMensagemIndisponivel := aValue;
end;

function TPessoaAgenda.Id(aValue: Integer): IPessoaAgenda;
begin
  Result := Self;
  FId:= aValue;
end;

constructor TPessoaAgenda.Create(aParent: IAgendaLib);
begin
  FParent := aParent;
end;

function TPessoaAgenda.DataHora(aValue: TDateTime): IPessoaAgenda;
begin
  Result := Self;
  FDataHora := aValue;
end;

function TPessoaAgenda.DataHora: TDateTime;
begin
  Result := FDataHora;
end;

destructor TPessoaAgenda.Destroy;
begin

  inherited;
end;

function TPessoaAgenda.Disponivel: Boolean;
begin
  Result := FDisponivel;
end;

function TPessoaAgenda.Disponivel(aValue: Boolean): IPessoaAgenda;
begin
  Result := Self;
  FDisponivel := aValue;
end;

class function TPessoaAgenda.New(aParent: IAgendaLib): IPessoaAgenda;
begin
  Result := Self.Create(aParent);
end;

function TPessoaAgenda.Nome: string;
begin
  Result := FNome;
end;

function TPessoaAgenda.Nome(aValue: string): IPessoaAgenda;
begin
  Result := Self;
  FNome := aValue;
end;

function TPessoaAgenda.ProfissionalId(aValue: Integer): IPessoaAgenda;
begin
  Result := Self;
  FProfissionalId := aValue;
end;

function TPessoaAgenda.Reservado(aValue: Boolean): IPessoaAgenda;
begin
  Result := Self;
  FReservado := aValue;
end;

function TPessoaAgenda.Telefone(aValue: string): IPessoaAgenda;
begin
  Result := Self;
  FTelefone := aValue;
end;

function TPessoaAgenda.ProfissionalId: Integer;
begin
  Result := FProfissionalId;
end;

function TPessoaAgenda.Reservado: Boolean;
begin
  Result := FReservado;
end;

function TPessoaAgenda.Telefone: string;
begin
  Result := FTelefone;
end;

end.
