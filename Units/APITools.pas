unit APITools;

interface

uses
  System.SysUtils, System.Classes, IPPeerClient, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Types, FMX.Dialogs,DataSetConverter4D,
  DataSetConverter4D.Impl, System.JSON, Datasnap.DBClient;


type

  TApiEnum = (dsJson, dsWWWForm);


  TApi = class
    private
      { Fields }
      FRequest : TRestRequest;
      FClient  : TRestClient;
      FResponse : TRestResponse;
      FResponseDataSet : TRestResponseDataSetAdapter;
    public
      { Constructor }
      constructor create; overload;
      { Destructor }
      destructor destroy;
      { Class Function }
      class function new : TApi;
      { Procedures }
      procedure RequestExecute();
      { Function }
      function  JSONtoDataset : TFDMemTable;
      function GetContentType(pType : TApiEnum) : string;
      function Setting(baseURL:string; Resource:string; pContentType : TApiEnum) : TApi;
      { Property }
      property Request  : TRestRequest  read FRequest  write FRequest;
      property Client   : TRestClient   read FClient   write FClient;
      property Response : TRestResponse read FResponse write FResponse;
      property ResponseDataSet : TRestResponseDataSetAdapter read FResponseDataSet write FResponseDataSet;
  end;

  TProdutos = class
    public
      FApi : TApi;
      constructor create ;
      function GetItems : TFDMemTable;
      class function new : TProdutos;
  end;

implementation



{ TApi}


constructor TApi.create;
begin
  FClient := TRestClient.Create(nil);

  FRequest := TRestRequest.Create(nil);

  FResponse := TRestResponse.Create(nil);

  FResponseDataSet := TRestResponseDataSetAdapter.Create(nil);

end;

class function TApi.new: TApi;
begin
  result :=  self.create();
end;

procedure TApi.RequestExecute();
begin
  FRequest.Execute;
end;

function TApi.Setting(baseURL:string; Resource:string; pContentType : TApiEnum) : TApi;
begin

  FClient.BaseURL := baseURL;
  FRequest.Resource := resource;
  FRequest.Client := client;
  FRequest.Response := response;

  FResponse.ContentType := GetContentType(pContentType);

  FResponseDataSet.Response := response;

  result := self;
end;


destructor TApi.destroy;
begin

  if System.Assigned(FClient) then
    FClient.Free;

  if System.Assigned(FRequest) then
    FRequest.Free;

  if System.Assigned(FResponse) then
    FResponse.Free;

  if System.Assigned(FResponseDataSet) then
    FResponseDataSet.Free;

end;

function TApi.GetContentType(pType: TApiEnum): string;
begin
  case pType  of
    dsJson : result := 'Application/json';
    dsWWWForm : result := 'application/x-www-form-urlencoded';
  end;
end;

function TApi.JSONtoDataset : TFDMemTable;
var
  LTable : TFDMemTable;
begin
  LTable := TFDMemTable.Create(nil);

  FResponseDataSet.Dataset := LTable;

  RequestExecute();

  result := LTable;

end;

{ TProdutos }

constructor TProdutos.create;
begin
  FApi := TApi.new.Setting('https://makeup-api.herokuapp.com', 'api/v1/products.json', dsJson);
  FApi.FRequest.Method := rmGet;
end;

function TProdutos.GetItems: TFDMemTable;
begin
  result := FApi.JSONtoDataset();

  if System.Assigned(FApi) then
    FApi.Free;
end;

class function TProdutos.new: TProdutos;
begin
  result := self.create;
end;

end.
