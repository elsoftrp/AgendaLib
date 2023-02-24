unit AgendaLib.Entity.Agenda;

interface

type
  THoraAgenda = class
  private
    FHora: TDateTime;
  public
    property Hora: TDateTime read FHora write FHora;
  end;

  TAgenda = class
  private
    FId: integer;
    FDataHora: TDateTime;
    FNome:string;
    FTelefone: string;
    FProfissionalId: integer;
    FReservado: Boolean;
    FDisponivel: Boolean;
    FMensagemIndisponivel: string;
  public
    property Id: integer  read FId write FId;
    property DataHora: TDateTime read FDataHora write FDataHora;
    property Nome: string  read FNome write FNome;
    property Telefone: string  read FTelefone write FTelefone;
    property ProfissionalId: integer read FProfissionalId write FProfissionalId;
    property Reservado: Boolean read FReservado write FReservado;
    property Disponivel: Boolean read FDisponivel write FDisponivel;
    property MensagemIndisponivel: string  read FMensagemIndisponivel write FMensagemIndisponivel;
  end;

implementation

end.
