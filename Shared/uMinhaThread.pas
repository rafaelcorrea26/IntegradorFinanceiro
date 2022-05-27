unit uMinhaThread;

interface

uses
  System.SysUtils, System.Classes, Vcl.StdCtrls, Vcl.ExtCtrls;

type

  TMinhaThread = class(TThread)
  private
    FtmrPainel: TTimer;

  public

    constructor Create;
    destructor destroy; override;
    procedure Execute; override;
    property tmrPainel: TTimer read FtmrPainel write FtmrPainel;

  end;

implementation

{ TMinhaThread }

constructor TMinhaThread.Create;
begin
  inherited tmrPainel := TTimer.Create(nil);
  Create(True);
end;

destructor TMinhaThread.destroy;
begin
  inherited;
  tmrPainel.Free;
end;

procedure TMinhaThread.Execute;
begin
  inherited;
  tmrPainel.Enabled := True;
end;

end.
