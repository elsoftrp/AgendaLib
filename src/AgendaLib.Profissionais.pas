unit AgendaLib.Profissionais;

interface

uses
  AgendaLib.Interfaces;

type
  TProfissionalAgenda = class(TInterfacedObject, IProfissionalAgenda)
  private
    [weak]
    FParent : IAgendaLib;
    FId: Integer;
    FNome: string;
  public
    constructor Create(aParent: IAgendaLib);
    destructor Destroy; override;
    class function New(aParent: IAgendaLib) : IProfissionalAgenda;
    function Id(aValue: Integer): IProfissionalAgenda; overload;
    function Nome(aValue: string): IProfissionalAgenda; overload;
    function Add: IAgendaLib;
    function Id: Integer; overload;
    function Nome: string; overload;
  end;

implementation

{ TProfissionalAgenda }

function TProfissionalAgenda.Add: IAgendaLib;
begin
  Result := FParent;
end;

constructor TProfissionalAgenda.Create(aParent: IAgendaLib);
begin
  FParent := aParent;
end;

destructor TProfissionalAgenda.Destroy;
begin

  inherited;
end;

function TProfissionalAgenda.Id(aValue: Integer): IProfissionalAgenda;
begin
  Result := Self;
  FId := aValue;
end;

function TProfissionalAgenda.Id: Integer;
begin
  Result := FId;
end;

class function TProfissionalAgenda.New(aParent: IAgendaLib): IProfissionalAgenda;
begin
  Result := Self.Create(aParent);
end;

function TProfissionalAgenda.Nome(aValue: string): IProfissionalAgenda;
begin
  Result := Self;
  FNome := aValue;
end;

function TProfissionalAgenda.Nome: string;
begin
  Result := FNome;
end;

end.
