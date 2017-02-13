unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    lblGameOver: TLabel;
    lblRestart: TLabel;
    lblThanks: TLabel;
    lblScore: TLabel;
    Ball: TShape;
    PaddleBottom: TShape;
    PaddleLeft: TShape;
    PaddleRight: TShape;
    PaddleTop: TShape;
    tmrGame: TTimer;
    procedure ControlPaddle(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure lblRestartClick(Sender: TObject);
    procedure lblRestartMouseEnter(Sender: TObject);
    procedure lblRestartMouseLeave(Sender: TObject);
    procedure PaddleLeftMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaddleBottomMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure PaddleRightMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaddleTopMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tmrGameTimer(Sender: TObject);
  private
    procedure InitGame;
    procedure UpdateScore;
    procedure GameOver;
    procedure IncreaseSpeed;
  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;
  Score : Integer;
  SpeedX, SpeedY: Integer;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.ControlPaddle(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //Bottom Paddle
  PaddleBottom.Left := X - PaddleBottom.Width div 2;
  PaddleBottom.Top := ClientHeight - PaddleBottom.Height - 1;
  //Left Paddle
  PaddleLeft.Left := 1;
  PaddleLeft.Top := Y - PaddleLeft.Height div 2;
  //Right Paddle
  PaddleRight.Left := ClientWidth - PaddleRight.Width - 1;
  PaddleRight.Top := Y - PaddleRight.Height div 2;
  //Top Paddle
  PaddleTop.Left := X - PaddleTop.Width div 2;
  PaddleTop.Top := 1;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  Randomize; // Reset random function
  InitGame;
end;

procedure TfrmMain.lblRestartClick(Sender: TObject);
begin
  InitGame;
end;

procedure TfrmMain.lblRestartMouseEnter(Sender: TObject);
begin
  lblRestart.Font.Style := [fsBold];
end;

procedure TfrmMain.lblRestartMouseLeave(Sender: TObject);
begin
  lblRestart.Font.Style := [];
end;

procedure TfrmMain.PaddleLeftMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //Left Paddle
  ControlPaddle(Sender, Shift, X + PaddleLeft.Left, Y + PaddleLeft.Top);
end;

procedure TfrmMain.PaddleBottomMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //Bottom Paddle
  ControlPaddle(Sender, Shift, X + PaddleBottom.Left, Y + PaddleBottom.Top);
end;

procedure TfrmMain.PaddleRightMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //Right Paddle
  ControlPaddle(Sender, Shift, X + PaddleRight.Left, Y + PaddleRight.Top);
end;

procedure TfrmMain.PaddleTopMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //Top Paddle
  ControlPaddle(Sender, Shift, X + PaddleTop.Left, Y + PaddleTop.Top);
end;

procedure TfrmMain.tmrGameTimer(Sender: TObject);
begin

  //Move ball
  Ball.Left := Ball.Left + SpeedX;
  Ball.Top := Ball.Top + SpeedY;

  //Game over bottom
  If Ball.Top + Ball.Height >= ClientHeight Then GameOver;
  //Game over left
  If Ball.Left <= 0 Then GameOver;
  //Game over right
  If Ball.Left + Ball.Width >= ClientWidth Then GameOver;
  //Game over top
  If Ball.Top <= 0 Then GameOver;

  //Collision with bottom Paddle
  if (Ball.Left + Ball.Width >= PaddleBottom.Left) and
    (Ball.Left <= PaddleBottom.Left + PaddleBottom.Width) and
    (Ball.Top + Ball.Height >= PaddleBottom.Top) Then
  begin
    SpeedY := -SpeedY;
    Inc(Score);
    UpDateScore;
  end;

  //Collision with left Paddle
  if (Ball.Top + Ball.Height >= PaddleLeft.Top) and
    (Ball.Top <= PaddleLeft.Top + PaddleLeft.Height) and
    (Ball.Left <= PaddleLeft.Left + PaddleLeft.Width) Then
  begin
    SpeedX := -SpeedX;
    Inc(Score);
    UpDateScore;
  end;

    //Collision with right Paddle
  if (Ball.Top + Ball.Height >= PaddleRight.Top) and
    (Ball.Top <= PaddleRight.Top + PaddleRight.Height) and
    (Ball.Left + Ball.Width >= PaddleRight.Left) Then
  begin
    SpeedX := -SpeedX;
    Inc(Score);
    UpDateScore;
  end;

  //Collision with top Paddle
  if (Ball.Left + Ball.Width >= PaddleTop.Left) and
    (Ball.Left <= PaddleTop.Left + PaddleTop.Width) and
    (Ball.Top <= PaddleTop.Top + PaddleTop.Height) Then
  begin
    SpeedY := -SpeedY;
    Inc(Score);
    UpDateScore;
  end;

end;

procedure TfrmMain.InitGame;
var
  directionX, directionY : integer;
begin
  //Initialization of components
  lblGameOver.Visible := False;
  lblRestart.Visible := False;
  lblRestart.Font.Style := [];
  lblThanks.Visible := False;
  //Reset ball position
  Ball.Left := ClientWidth div 2;
  Ball.Top := ClientHeight div 2;
  //Calculate direction
  directionX := Random(2);
  if directionX = 0 then SpeedX := 4 else SpeedX := -4;
  directionY := Random(2);
  if directionY = 0 then SpeedY := 4 else SpeedY := -4;
  //Reset score
  Score := 0;
  UpdateScore;
  //Start game
  tmrGame.Enabled := True;
end;

procedure TfrmMain.UpdateScore;
begin
  lblScore.Caption:='Score: ' + IntToStr(Score);
  //Increase speed
  case Score of
    4: IncreaseSpeed;
    8: IncreaseSpeed;
    12: IncreaseSpeed;
    16: IncreaseSpeed;
    20: IncreaseSpeed;
    24: IncreaseSpeed;
    28: IncreaseSpeed;
    32: IncreaseSpeed;
    36: IncreaseSpeed;
    40: IncreaseSpeed;
    44: IncreaseSpeed;
    48: IncreaseSpeed;
  end;
end;

procedure TfrmMain.GameOver;
begin
  //Stop Timer
  tmrGame.Enabled := False;
  //Components visible
  lblGameOver.Visible := True;
  lblRestart.Visible := True;
  lblThanks.Visible := True;
end;

procedure TfrmMain.IncreaseSpeed;
begin
  If SpeedX >0 Then Inc(SpeedX) else Dec(SpeedX);
  If SpeedY >0 Then Inc(SpeedY) else Dec(SpeedY);
end;

end.

