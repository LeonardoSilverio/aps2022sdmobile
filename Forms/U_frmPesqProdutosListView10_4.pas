unit U_frmPesqProdutosListView10_4;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView, FMX.Objects, FMX.Controls.Presentation,
  FMX.Edit, FMX.Layouts, FMX.StdCtrls, Data.DB, Datasnap.DBClient,
  Frame_produtos, IPPeerClient, Data.Cloud.CloudAPI, Data.Cloud.AmazonAPI,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  FMX.BitmapHelper, FMX.Effects, FMX.Filter.Effects, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Loading,
  AnonThread, FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.Ani,
  System.ImageList, FMX.ImgList, APITools,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.TabControl,
  Data.SqlExpr;

type
  TfrmPesqProdutosListView10_4 = class(TForm)
    Layout1: TLayout;
    Panel1: TPanel;
    Edit1: TEdit;
    ListView1: TListView;
    RoundRect1: TRoundRect;
    Label2: TLabel;
    StyleBook1: TStyleBook;
    Image1: TImage;
    FDMemTable1: TFDMemTable;
    Circle1: TCircle;
    Image3: TImage;
    Rectangle1: TRectangle;
    Layout2: TLayout;
    RoundRect2: TRoundRect;
    Label1: TLabel;
    Label3: TLabel;
    TabControl1: TTabControl;
    tabProdutos: TTabItem;
    tabDetalhes: TTabItem;
    Label4: TLabel;
    Layout3: TLayout;
    Panel2: TPanel;
    Label5: TLabel;
    Image2: TImage;
    procedure Image1Click(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure RoundRect1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListView1PullRefresh(Sender: TObject);
    procedure ListView1ScrollViewChange(Sender: TObject);
    procedure Circle1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure RoundRect2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
  private
    procedure ThreadEnd(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    procedure AddMakeUp(id:integer; nome:string; imagemAWS:String; preco:string);
  end;

var
  frmPesqProdutosListView10_4: TfrmPesqProdutosListView10_4;

implementation

{$R *.fmx}

procedure TfrmPesqProdutosListView10_4.AddMakeUp(id:integer; nome:string; imagemAWS:String; preco:string);
var
  LItem: TListViewItem;
  fFrame : TFrameProduto;
  bImg : TBitmap;
  dValor : Double;
  dvalor2 : string;
begin

  with ListView1.Items.add do
  begin
     Height := 120;
     TListItemText(Objects.FindDrawable('Text1')).Text := nome;
     TListItemText(Objects.FindDrawable('Text2')).Text := 'Cód. ' + inttostr(id);
     TListItemText(Objects.FindDrawable('Text5')).Text := 'R$' + preco;


     if bImg <> nil then
      bImg := nil;

     bImg := TBitmap.Create;
     bImg.LoadFromUrl('https:' + imagemAWS);
     TListItemImage(Objects.FindDrawable('Image3')).Bitmap := bImg;
     TListItemImage(Objects.FindDrawable('Image3')).OwnsBitmap := True;
  end;

end;

procedure TfrmPesqProdutosListView10_4.Circle1Click(Sender: TObject);
begin
  Rectangle1.Visible := True;
end;

procedure TfrmPesqProdutosListView10_4.Edit1KeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  tProcesso : TThread;
begin

  if edit1.Text = '' then
  begin
      ListView1.Items.Clear;
      TLoading.Show(frmPesqProdutosListView10_4, 'Consultando...');
      tProcesso := TThread.CreateAnonymousThread(procedure
      begin
        FDMemTable1.Destroy;
        FDMemTable1 := TProdutos.new.GetItems();
        while FDMemTable1.RecNo <= 10 do
        begin
          TThread.Synchronize(nil, procedure
          begin
            AddMakeUp(FDMemTable1.FieldByName('id').AsInteger,
                      FDMemTable1.FieldByName('name').AsString,
                      FDMemTable1.FieldByName('api_featured_image').AsString,
                      FDMemTable1.FieldByName('price').AsString);

            TLoading.hide;
          end);


          FDMemTable1.Next;
        end;
      end);

      tProcesso.OnTerminate := ThreadEnd;
      tProcesso.Start;
  end;
end;

procedure TfrmPesqProdutosListView10_4.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmPesqProdutosListView10_4 := nil;
end;

procedure TfrmPesqProdutosListView10_4.ThreadEnd(Sender: TObject);
begin
    if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
          showMessage('A Thread Falhou: ’' + Exception(TThread(sender).FatalException).Message);
    end;
end;

procedure TfrmPesqProdutosListView10_4.Image1Click(Sender: TObject);
var
  tProcesso : TThread;
begin
  TLoading.Show(frmPesqProdutosListView10_4, 'Consultando...');

  tProcesso := TThread.CreateAnonymousThread(procedure
  var
  x : integer;
  begin
    ListView1.BeginUpdate;
    if edit1.Text = '' then
    begin
      sleep(1000);
      TThread.Synchronize(nil, procedure
      begin
         TLoading.hide;
      end);

    end
    else
    begin

      if edit1.Text.Length < 3 then
      begin
          TThread.Synchronize(nil, procedure
          begin
            TLoading.hide;
          end);

      end
      else
      begin
        ListView1.Items.Clear;
        with FDMemTable1 do
        begin
          Filtered := False;
          Filter := 'name like ' + QuotedStr(edit1.Text + '%');
          Filtered := True;
        end;

        sleep(1000);
        while not FDMemTable1.Eof do
        begin
          TThread.Synchronize(nil, procedure
          begin


              AddMakeUp(FDMemTable1.FieldByName('id').AsInteger,
                        FDMemTable1.FieldByName('name').AsString,
                        FDMemTable1.FieldByName('api_featured_image').AsString,
                        FDMemTable1.FieldByName('price').AsString);

            TLoading.hide;
          end);



          FDMemTable1.Next;
        end;

        FDMemTable1.Filtered := False;

      end;

    end;

    ListView1.EndUpdate;
  end);


  tProcesso.OnTerminate := ThreadEnd;
  tProcesso.Start;

end;

procedure TfrmPesqProdutosListView10_4.Image2Click(Sender: TObject);
begin
  tabControl1.ActiveTab := tabProdutos;
end;

procedure TfrmPesqProdutosListView10_4.Image3Click(Sender: TObject);
begin
  Rectangle1.Visible := True;
end;

procedure TfrmPesqProdutosListView10_4.ListView1PullRefresh(Sender: TObject);
begin
  TLoading.Show(frmPesqProdutosListView10_4, 'Consultando...');
end;

procedure TfrmPesqProdutosListView10_4.ListView1ScrollViewChange(
  Sender: TObject);
var
  R: TRectF;
  tProcesso : TThread;
  iCount : Integer;
begin

    if TListView(Sender).ItemCount > 0 then // Just in case...
    begin
      R := TListView(Sender).GetItemRect(TListView(Sender).ItemCount - 1);
      if R.Bottom = TListView(Sender).Height then
      begin
        sleep(500);
        tProcesso := TThread.CreateAnonymousThread(procedure
        begin

          iCount := ListView1.Items.Count;
          while (FDMemTable1.RecNo > iCount) and (FDMemTable1.RecNo <= iCount + 10) do
          begin
            TThread.Synchronize(nil, procedure
            begin

                AddMakeUp(FDMemTable1.FieldByName('id').AsInteger,
                          FDMemTable1.FieldByName('name').AsString,
                          FDMemTable1.FieldByName('api_featured_image').AsString,
                          FDMemTable1.FieldByName('price').AsString);
            end);

            FDMemTable1.Next;
          end;
        end);

        tProcesso.OnTerminate := ThreadEnd;
        tProcesso.start;
      end;
    end;



end;

procedure TfrmPesqProdutosListView10_4.RoundRect1Click(Sender: TObject);
var
  tProcesso : TThread;
begin
  RoundRect1.Visible := False;
  TLoading.Show(frmPesqProdutosListView10_4, 'Consultando...');
  tProcesso := TThread.CreateAnonymousThread(procedure
  begin

    FDMemTable1 := TProdutos.new.GetItems();

    ListView1.BeginUpdate;
    if edit1.Text = '' then
    begin
      while FDMemTable1.RecNo <= 10 do
      begin
        TThread.Synchronize(nil, procedure
        begin

            AddMakeUp(FDMemTable1.FieldByName('id').AsInteger,
                      FDMemTable1.FieldByName('name').AsString,
                      FDMemTable1.FieldByName('api_featured_image').AsString,
                      FDMemTable1.FieldByName('price').AsString);


            TLoading.Hide;
        end);

        FDMemTable1.Next;
      end;

    end
    else
    begin
      ListView1.Items.Clear;
      with FDMemTable1 do
      begin
      Filtered := False;
      Filter := 'name = ' + QuotedStr(edit1.Text);
      Filtered := True;
      end;
    end;

    ListView1.EndUpdate;
  end);

  tProcesso.OnTerminate := ThreadEnd;
  tProcesso.Start;

end;

procedure TfrmPesqProdutosListView10_4.RoundRect2Click(Sender: TObject);
begin
  Rectangle1.Visible := False;
end;

end.
