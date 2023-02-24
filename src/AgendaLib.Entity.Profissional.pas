unit AgendaLib.Entity.Profissional;

interface

type
  TProfissional = class
  private
    FId: Integer;
    FNome:string;
  public
    property Id: integer  read FId write FId;
    property Nome: string  read FNome write FNome;
  end;

implementation

end.
