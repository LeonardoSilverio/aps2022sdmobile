unit U_frminicio;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  AnonThread, FMX.BitmapHelper, Frame_produtos, Loading, FMX.Controls.Presentation, FMX.StdCtrls,
  U_frmPesqProdutosListView10_4, FMX.Objects,
  DataSetConverter4D.Helper, DataSetConverter4D.Impl, DataSetConverter4D,
  DataSetConverter4D.Util, APITools;

type
  Tfrminicio = class(TForm)
    layout1: TLayout;
    RoundRect2: TRoundRect;
    Label2: TLabel;
    Layout2: TLayout;
    Image1: TImage;
    procedure RoundRect2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frminicio: Tfrminicio;

implementation

{$R *.fmx}

procedure Tfrminicio.RoundRect2Click(Sender: TObject);
begin
  if not assigned(frmPesqProdutosListView10_4) then
  begin
    Application.CreateForm(TfrmPesqProdutosListView10_4, frmPesqProdutosListView10_4);
    frmPesqProdutosListView10_4.Show;
  end;
end;

end.
