unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    EditRoverMovement: TEdit;
    LabelRoverTag: TLabel;
    Image31: TImage;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    Image23: TImage;
    Image24: TImage;
    Image25: TImage;
    Image26: TImage;
    Image27: TImage;
    Image28: TImage;
    Image29: TImage;
    Image30: TImage;
    Image32: TImage;
    Image33: TImage;
    Image34: TImage;
    Image35: TImage;
    Image36: TImage;
    LabelSelectedRover: TLabel;
    Label2: TLabel;
    ButtonDeployRover: TButton;
    ImageBlueRover: TImage;
    ImageRedRover: TImage;
    ImageGreenRover: TImage;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Memo1: TMemo;

    procedure ButtonDeployRoverClick(Sender: TObject);
    procedure Image31Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditRoverMovementKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Image30Click(Sender: TObject);
  private
    { Private declarations }
    function getRover: TImage;
    procedure MoveRover(Input: string);
    procedure MoveRoverToNewlocation(moveto: integer);
    procedure PrepareImageForRoation(RotateDegree: Integer; RoverImage: TImage);

    Procedure RotateImage(SourceBitmap : TBitmap; out DestBitmap : TBitmap;
                               Center : TPoint; Angle : Double);
  public
    { Public declarations }

  Const PixelMax = 32768;
  Type
   pPixelArray = ^TPixelArray;
   TPixelArray = Array[0..PixelMax-1] Of TRGBTriple;


  end;

var
  Form1: TForm1;
  GlobalRoverImage : TImage;
  Xmoved, Ymoved: Boolean;

implementation

{$R *.dfm}

procedure TForm1.ButtonDeployRoverClick(Sender: TObject);
var
  p : Integer;
  PlateauImage : TImage;
  RoverImage: TImage;
  ThisPicture: TPicture;
begin
  RoverImage := getRover;
  ThisPicture := TPicture.Create;

  try
    if Assigned(RoverImage) then
    begin
      for p := 0 to ComponentCount - 1 do
      begin
        if (Components[p] is TImage) and (Components[p].Tag = 11)then
        begin
          PlateauImage := TImage(Components[p]);
          if (PlateauImage.Picture.Graphic = nil) then
          begin
            RoverImage.Visible := False;
            ThisPicture.LoadFromFile('123.bmp');
            PlateauImage.Picture.Assign(ThisPicture);
            LabelRoverTag.Caption := '';
            LabelSelectedRover.Caption := 'No rover is selected';
            break;
          end
          else
            MessageDlg('There is already a rover depolyed on the base.', mtInformation,[mbOk], 0, mbOk);
        end;
      end;
    end
  finally
    FreeAndNil(ThisPicture)
  end

end;

procedure TForm1.EditRoverMovementKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Input: string;
begin
  Input := EditRoverMovement.Text;
  Input := copy(Input, Input.Length - 1 , Input.Length);
  Input := Input.Trim;
  if key = VK_SPACE then
  begin
    //process input after pressing spacebar
    MoveRover(Input);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  EditRoverMovement.Clear;
end;

function TForm1.getRover: TImage;
var
  p : Integer;
  RoverImage : TImage;
  RoverImageTag : Integer;
begin
  Result := nil;
  try
    RoverImageTag := StrToInt(LabelRoverTag.Caption);
    for p := 0 to ComponentCount - 1 do
    begin
      if (Components[p] is TImage) and (Components[p].Tag = RoverImageTag) then
      begin
        RoverImage := TImage(Components[p]);
        RoverImage.Picture.SaveToFile('123.bmp');

        break;
      end;
    end;
    Result := RoverImage;
  except
    MessageDlg('Please select a rover to deploy.', mtInformation,[mbOk], 0, mbOk);
  end;
end;

procedure TForm1.Image30Click(Sender: TObject);
begin
  GlobalRoverImage := TImage(Sender);

  //Reset Moves for new rover
  Ymoved := False;
  Xmoved := False;
  EditRoverMovement.SetFocus;
  EditRoverMovement.Clear;
  LabelSelectedRover.Caption := 'Rover is selected';
  //Check if Rover has been selected
  if (GlobalRoverImage.Picture.Graphic = nil) then
  begin
    GlobalRoverImage := nil;
    MessageDlg('Please select a rover to move.', mtInformation,[mbOk], 0, mbOk);
    LabelSelectedRover.Caption := 'No Rover is selected';
  end;

end;

procedure TForm1.Image31Click(Sender: TObject);
var
  p : Integer;
  RoverImage : TImage;
  RoverImageTag : Integer;
begin
  GlobalRoverImage := nil;
  try
    for p := 0 to ComponentCount - 1 do
    begin
      if (Sender = ImageBlueRover) then
      begin
        LabelSelectedRover.Caption := 'Blue Rover is selected';
        LabelRoverTag.Caption := ImageBlueRover.Tag.ToString;
        break;
      end;
      if (Sender = ImageGreenRover) then
      begin
        LabelSelectedRover.Caption := 'Green Rover is selected';
        LabelRoverTag.Caption := ImageGreenRover.Tag.ToString;
        break;
      end;
      if (Sender = ImageRedRover) then
      begin
        LabelSelectedRover.Caption := 'Red Rover is selected';
        LabelRoverTag.Caption := ImageRedRover.Tag.ToString;
        break;
      end;
    end;
  except
    //
  end;
end;

procedure TForm1.MoveRover(Input: string);
var
  RotateDegree, Err: Integer;
  MoveTo, RoverCurrentPostion: Integer;
begin
  RotateDegree := 0;
  Err := 0;
  if Assigned(GlobalRoverImage) then
  begin
    //Direction
    if Err = 0 then
    begin
      if Input.ToUpper = 'L' then //to turn left
      begin
        RotateDegree := -90;
        Err := Err + 1;
      end
      else if Input.ToUpper = 'R' then
      begin
        RotateDegree := 90;
        Err := Err + 1;
      end
      else if Input.ToUpper = 'N' then //North
      begin
        //Reset image to 0
        RotateDegree := 0;
        PrepareImageForRoation(RotateDegree, GlobalRoverImage);
        RotateDegree := 90;
      end
      else if Input.ToUpper = 'E' then //East
      begin
        //Reset image to 0
        RotateDegree := 0;
        PrepareImageForRoation(RotateDegree, GlobalRoverImage);
        RotateDegree := 180;
      end
      else if Input.ToUpper = 'S' then //South
      begin
        //Reset image to 0
        RotateDegree := 0;
        PrepareImageForRoation(RotateDegree, GlobalRoverImage);
        RotateDegree := 270;
      end
      else if Input.ToUpper = 'W' then //west
      begin
        //Reset image to 0
        RotateDegree := 0;
        PrepareImageForRoation(RotateDegree, GlobalRoverImage);
        RotateDegree := 360;
      end;

      //Rotate
      if RotateDegree <> 0 then
      begin
        //Prepares to rotate the bitmap image **** Timage component doesnt just rotated the
        //bits on the image have to be rotated -> Eish
        PrepareImageForRoation(RotateDegree, GlobalRoverImage);
        Err := Err + 1;
      end;

    end;

    if Err = 0 then
    begin
      if Input.ToUpper = 'M' then
      begin
        //Move Y
        MoveTo := GlobalRoverImage.Tag + 1;
        MoveRoverToNewlocation(MoveTo);
        Err := Err + 1;
      end;
    end;

    //Move
    if Err = 0 then
    begin
      try
        MoveTo := StrToInt(Input);

        //If X moved then the next digit ented will move Y
        if Xmoved = False then
        begin
          //(X,y)
          RoverCurrentPostion := GlobalRoverImage.Tag;

          //Append a 0 at the end to change the x on the tag
          MoveTo := GlobalRoverImage.Tag + StrToInt( IntToStr(MoveTo) + '0');
          MoveRoverToNewlocation(moveto);

          Xmoved := True;
          Ymoved := False;
          Err := Err + 1;
        end
        else if Ymoved = False then
        begin
          //Move Y
          MoveTo := GlobalRoverImage.Tag + MoveTo;
          MoveRoverToNewlocation(moveto);

          Ymoved := True;
          Xmoved := False;
          Err := Err + 1;
        end;
      except

      end;
    end;



  end
  else
  begin
    MessageDlg('Select rover to move on the grid.', mtInformation,[mbOk], 0, mbOk);
    EditRoverMovement.Clear;
  end;
end;

procedure TForm1.MoveRoverToNewlocation(moveto: integer);
var
  p: Integer;
  moved: Boolean;
  NewLocation: TImage;
begin
  moved := False;
  for p := 0 to ComponentCount - 1 do
  begin
    if (Components[p] is TImage) and (Components[p].Tag = moveto) then
    begin
      NewLocation := TImage(Components[p]);
      if (NewLocation.Picture.Graphic = nil) then
      begin
        GlobalRoverImage.Picture.SaveToFile('123.bmp');
        GlobalRoverImage.Picture := nil;

        NewLocation.Picture.LoadFromFile('123.bmp');
        GlobalRoverImage := NewLocation;
        NewLocation := nil;

        moved := True;
      end
      else
       MessageDlg('Rover is assigned a loaction where another rover is already investigating.', mtInformation,[mbOk], 0, mbOk);

      break;

    end;
  end;

  if moved = False then
   MessageDlg('Rover falls outside the plateau. Please enter proper co-ordinates.', mtInformation,[mbOk], 0, mbOk);

end;

procedure TForm1.PrepareImageForRoation(RotateDegree: Integer; RoverImage: TImage);
var
   Center : TPoint;
   Bitmap : TBitmap;
   Angle : Double;
begin
   Bitmap := TBitmap.Create;
   Angle := 0;
   //Saving the image to file as it is -> orientationally
   RoverImage.Picture.SaveToFile('123.bmp');
   //Read from the same location
   Bitmap.LoadFromFile('123.bmp');
   Try
     Center.y := (Bitmap.Height div 2) + 20;
     Center.x := (Bitmap.Width div 2) + 20;

     Angle := Angle + RotateDegree;
     RotateImage(Bitmap, Bitmap, Center, Angle) ;

     RoverImage.Picture.Bitmap.Assign(Bitmap) ;
     RoverImage.Refresh;
   Finally
     Bitmap.Free;
   End;
end;

procedure TForm1.RotateImage(SourceBitmap: TBitmap; out DestBitmap: TBitmap;
                              Center: TPoint; Angle: Double);
Var
   cosRadians : Double;
   inX : Integer;
   inXOriginal : Integer;
   inXPrime : Integer;
   inXPrimeRotated : Integer;
   inY : Integer;
   inYOriginal : Integer;
   inYPrime : Integer;
   inYPrimeRotated : Integer;
   OriginalRow : pPixelArray;
   Radians : Double;
   RotatedRow : pPixelArray;
   sinRadians : Double;
begin
   DestBitmap.Width := SourceBitmap.Width;
   DestBitmap.Height := SourceBitmap.Height;
   DestBitmap.PixelFormat := pf24bit;
   Radians := -(Angle) * PI / 180;
   sinRadians := Sin(Radians) ;
   cosRadians := Cos(Radians) ;
   For inX := DestBitmap.Height-1 Downto 0 Do
   Begin
     RotatedRow := DestBitmap.Scanline[inX];
     inXPrime := 2*(inX - Center.y) + 1;
     For inY := DestBitmap.Width-1 Downto 0 Do
     Begin
       inYPrime := 2*(inY - Center.x) + 1;
       inYPrimeRotated := Round(inYPrime * CosRadians - inXPrime * sinRadians) ;
       inXPrimeRotated := Round(inYPrime * sinRadians + inXPrime * cosRadians) ;
       inYOriginal := (inYPrimeRotated - 1) Div 2 + Center.x;
       inXOriginal := (inXPrimeRotated - 1) Div 2 + Center.y;
       If
         (inYOriginal >= 0) And
         (inYOriginal <= SourceBitmap.Width-1) And
         (inXOriginal >= 0) And
         (inXOriginal <= SourceBitmap.Height-1)
       Then
       Begin
         OriginalRow := SourceBitmap.Scanline[inXOriginal];
         RotatedRow[inY] := OriginalRow[inYOriginal]
       End
       Else
       Begin
         RotatedRow[inY].rgbtBlue := 255;
         RotatedRow[inY].rgbtGreen := 0;
         RotatedRow[inY].rgbtRed := 0
       End;
     End;
   End;
end;

end.
