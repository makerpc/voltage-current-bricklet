program ExampleCallback;

{$ifdef MSWINDOWS}{$apptype CONSOLE}{$endif}
{$ifdef FPC}{$mode OBJFPC}{$H+}{$endif}

uses
  SysUtils, IPConnection, BrickletVoltageCurrent;

type
  TExample = class
  private
    ipcon: TIPConnection;
    vc: TBrickletVoltageCurrent;
  public
    procedure CurrentCB(sender: TBrickletVoltageCurrent; const current: longint);
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'ABC'; { Change to your UID }

var
  e: TExample;

{ Callback function for current callback (parameter has unit mA) }
procedure TExample.CurrentCB(sender: TBrickletVoltageCurrent; const current: longint);
begin
  WriteLn(Format('Current: %f A', [current/1000.0]));
end;

procedure TExample.Execute;
begin
  { Create IP connection }
  ipcon := TIPConnection.Create;

  { Create device object }
  vc := TBrickletVoltageCurrent.Create(UID, ipcon);

  { Connect to brickd }
  ipcon.Connect(HOST, PORT);
  { Don't use device before ipcon is connected }


  { Set Period for current callback to 1s (1000ms)
    Note: The current callback is only called every second if the
          current has changed since the last call! }
  vc.SetCurrentCallbackPeriod(1000);

  { Register current callback to procedure CurrentCB }
  vc.OnCurrent := {$ifdef FPC}@{$endif}CurrentCB;

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy; { Calls ipcon.Disconnect internally }
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
