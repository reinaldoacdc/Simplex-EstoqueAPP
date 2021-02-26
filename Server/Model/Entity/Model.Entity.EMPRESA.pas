unit Model.Entity.EMPRESA;

interface

uses System.JSON,  REST.Json, REST.Json.Types, SimpleAttributes;

type
  [Tabela('CONFIG')]
  TEMPRESA = class

  private
    FCODEMPRESA: Integer;
    FNOMEFANTASIA: String;
  public
  published
    property CODEMPRESA :Integer read FCODEMPRESA write FCODEMPRESA;
    property NOMEFANTASIA :String read FNOMEFANTASIA write FNOMEFANTASIA;
end;

implementation

end.
