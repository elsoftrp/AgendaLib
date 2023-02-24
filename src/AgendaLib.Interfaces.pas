unit AgendaLib.Interfaces;

interface

type

  TAgendaReservadoClick = procedure(aId: Integer; aNome, aTelefone: string; aProfissionalId: Integer; aDataHora: TDateTime) of object;
  TAgendaDisponivelClick = procedure(aProfissionalId: Integer; aDataHora: TDateTime ) of object;

  IAgendaLib = interface;

  IPessoaAgenda = interface
    ['{23AACB09-D80A-47EB-A718-452F1F30FF81}']
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

  IProfissionalAgenda = interface
    ['{F6228764-73AC-46BD-8C3C-4984ECF1D17F}']
    function Id(aValue: Integer): IProfissionalAgenda; overload;
    function Nome(aValue: string): IProfissionalAgenda; overload;
    function Add: IAgendaLib;
    function Id: Integer; overload;
    function Nome: string; overload;
  end;

  IAgendaLib = interface
    ['{2B87D1F1-C2F5-466D-8816-F0BF6823B474}']
    function Data(aValue: TDateTime): IAgendaLib;
    function LimparAgenda: IAgendaLib;
    function AddOnClickReservado(aProcedure: TAgendaReservadoClick): IAgendaLib;
    function AddOnClickDisponivel(aProcedure: TAgendaDisponivelClick): IAgendaLib;
    function Pessoa:  IPessoaAgenda;
    function Profissional: IProfissionalAgenda;
    function AgendamentoDisponivelOuReservado: Boolean;
    function TemAgendamentoGrid: Boolean;
    function CodigoAgendaSelecionado: Integer;
    procedure DataEProfissionalSelecionado(out aDataHora: TDateTime; out aProfissionalId: Integer);
    procedure Carregar;
  end;

implementation

end.
