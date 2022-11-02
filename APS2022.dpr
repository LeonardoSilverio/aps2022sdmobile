program APS2022;

uses
  System.StartUpCopy,
  FMX.Forms,
  U_frminicio in 'Forms\U_frminicio.pas' {frminicio},
  U_frmPesqProdutosListView10_4 in 'Forms\U_frmPesqProdutosListView10_4.pas' {frmPesqProdutosListView10_4},
  Frame_produtos in 'Frames\Frame_produtos.pas' {FrameProduto: TFrame},
  AnonThread in 'Units\AnonThread.pas',
  DataSetConverter4D.Helper in 'Units\DataSetConverter4D.Helper.pas',
  DataSetConverter4D.Impl in 'Units\DataSetConverter4D.Impl.pas',
  DataSetConverter4D in 'Units\DataSetConverter4D.pas',
  DataSetConverter4D.Util in 'Units\DataSetConverter4D.Util.pas',
  FMX.BitmapHelper in 'Units\FMX.BitmapHelper.pas',
  Loading in 'Units\Loading.pas',
  APITools in 'Units\APITools.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrminicio, frminicio);
  Application.Run;
end.
