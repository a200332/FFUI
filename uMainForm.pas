unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.TlHelp32, Winapi.PsAPI, System.SysUtils, System.StrUtils, System.Variants, System.Classes, System.IniFiles, System.IOUtils, System.Types,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.ComCtrls, Vcl.Menus, Vcl.Clipbrd, Vcl.FileCtrl,
  {�������ؼ�}
  SynEdit, SynHighlighterJSON, DosCommand, uProcessAPI;

type
  { ���ļ���ʽ���ļ�/�ļ���/������Ƶ����ַ }
  TFileStyle = (fsFile, fsFolder, fsStream);

type
  TfrmFFUI = class(TForm)
    lblVideoFile: TLabel;
    pgcAll: TPageControl;
    tsInfo: TTabSheet;
    tsPlay: TTabSheet;
    pnlButtonCommand: TPanel;
    btnPlay: TButton;
    btnPause: TButton;
    btnStop: TButton;
    pnlVideo: TPanel;
    tsConv: TTabSheet;
    tsSept: TTabSheet;
    tsMerge: TTabSheet;
    tsLive: TTabSheet;
    rgWeb: TRadioGroup;
    pnlWeb: TPanel;
    srchbxSelectVideoFile: TSearchBox;
    dlgOpenVideoFile: TOpenDialog;
    tmrPlay: TTimer;
    tsConfig: TTabSheet;
    rgUI: TRadioGroup;
    rgGPU: TRadioGroup;
    statInfo: TStatusBar;
    pmOpen: TPopupMenu;
    mniOpenFile: TMenuItem;
    mniOpenFolder: TMenuItem;
    mniOpenWebStream: TMenuItem;
    pmStatCopy: TPopupMenu;
    mniCopyDosCommand: TMenuItem;
    lstFiles: TListBox;
    btnAddVideoFile: TButton;
    btnDelVideoFile: TButton;
    tmrPlayVideo: TTimer;
    btnAddFolder: TButton;
    btnVideoStartConv: TButton;
    btnVideoStopConv: TButton;
    pnlVideoConv: TPanel;
    grpVideoConv: TGroupBox;
    chkVideoSize: TCheckBox;
    lblVideoWidth: TLabel;
    lblVideoHeight: TLabel;
    edtVideoHeight: TEdit;
    edtVideoWidth: TEdit;
    chkVideoSavePath: TCheckBox;
    lblSaveVideoPath: TLabel;
    lblConvTip: TLabel;
    cbbConv: TComboBox;
    btnVideoConvParam: TButton;
    lblTitle: TLabel;
    lblArtist: TLabel;
    lblGenre: TLabel;
    lblComment: TLabel;
    edtTitle: TEdit;
    edtArtist: TEdit;
    edtGenre: TEdit;
    edtComment: TEdit;
    lbl1: TLabel;
    btnSaveConvParam: TButton;
    btnSaveConvParamAndStartConv: TButton;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lstDepartVideo: TListBox;
    lstDepartAudio: TListBox;
    lstDepartSubTitle: TListBox;
    btnDepart: TButton;
    lbl5: TLabel;
    grpDepartPath: TGroupBox;
    chkDepartPath: TCheckBox;
    lblDepartPath: TLabel;
    srchbxVideoConvSavePath: TSearchBox;
    srchbxDepartVideoSavePath: TSearchBox;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure srchbxSelectVideoFileInvokeSearch(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mniOpenFileClick(Sender: TObject);
    procedure mniOpenFolderClick(Sender: TObject);
    procedure mniOpenWebStreamClick(Sender: TObject);
    procedure mniCopyDosCommandClick(Sender: TObject);
    procedure rgUIClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnAddVideoFileClick(Sender: TObject);
    procedure btnDelVideoFileClick(Sender: TObject);
    procedure tmrPlayVideoTimer(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnAddFolderClick(Sender: TObject);
    procedure chkVideoSizeClick(Sender: TObject);
    procedure chkVideoSavePathClick(Sender: TObject);
    procedure btnVideoStartConvClick(Sender: TObject);
    procedure btnVideoStopConvClick(Sender: TObject);
    procedure btnVideoConvParamClick(Sender: TObject);
    procedure btnSaveConvParamClick(Sender: TObject);
    procedure btnSaveConvParamAndStartConvClick(Sender: TObject);
    procedure btnSaveVideoPathClick(Sender: TObject);
    procedure chkDepartPathClick(Sender: TObject);
    procedure btnDepartPathClick(Sender: TObject);
  private
    FDOSCommand       : TDosCommand;
    FSynEdit_VideoInfo: TSynEdit;
    FSynEdit_VideoConv: TSynEdit;
    FJSONHL           : TSynJSONSyn;
    FFileStyle        : TFileStyle;
    FhPlayVideoWnd    : HWND;
    FbVideoConv       : Boolean;
    { �����﷨������ SynEdit �ؼ� }
    procedure CreateSynEdit;
    { ����ϵͳ���� }
    procedure LoadConfig;
    { ����ϵͳ���� }
    procedure SaveConfigProc;
    function SaveConfig: Boolean;
    { ��ȡ��Ƶ�ļ���ʽ��Ϣ }
    procedure GetVideoFileInfo(const strFileName: string);
    { ��Ƶת������ }
    procedure DosCommandTerminated(Sender: TObject);
    { Dos ���������з��ص��ַ��� }
    procedure DosCommandLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
    { ��ѯĿ¼�µ�������Ƶ�ļ� }
    procedure FindVideoFile(const strFolder: string);
    { ������Ƶ }
    procedure PlayVideoFile(const strVideoFileName: String);
    { �� ffplay/mpv ���������ͼ������� }
    procedure SendPlayUIKey(H: HWND; Key: Char);
    { �� vlc ���������ͼ������� }
    procedure SendPlayUIKey_vlc(H: HWND; Key: Char);
    { TDosCommand.Stop �޷�ֹͣ CMD ���̣����ֶ�ɱ������ }
    procedure KillProcessOfName(const strProcessName: string);
  end;

var
  frmFFUI: TfrmFFUI;

implementation

{$R *.dfm}

const
  c_strMsgTitle: PChar = 'ϵͳ��ʾ��';

  { ����ϵͳ���� }
procedure TfrmFFUI.LoadConfig;
var
  strIniFileName: String;
begin
  strIniFileName := ExtractFilePath(ParamStr(0)) + 'config.ini';
  with TIniFile.Create(strIniFileName) do
  begin
    rgUI.ItemIndex := ReadInteger('Main', 'PlayUI', 0);

    { ��Ƶת������ }
    cbbConv.ItemIndex        := ReadInteger('Conv', 'Format', 0);
    chkVideoSize.Checked     := ReadBool('Conv', 'SameSize', True);
    chkVideoSavePath.Checked := ReadBool('COnv', 'SamePath', True);
    if not chkVideoSize.Checked then
    begin
      edtVideoWidth.Text  := ReadString('Conv', 'SizeWidth', '800');
      edtVideoHeight.Text := ReadString('Conv', 'SizeHeight', '600');
    end;
    if not chkVideoSavePath.Checked then
    begin
      srchbxVideoConvSavePath.Text := ReadString('Conv', 'SavePath', 'D:\');
    end;

    { ��Ƶ������Ϣ }
    edtTitle.Text   := ReadString('Conv', 'Title', 'dbyoung');
    edtArtist.Text  := ReadString('Conv', 'Artist', 'FFUI 2.0');
    edtGenre.Text   := ReadString('Conv', 'Genre', 'Video');
    edtComment.Text := ReadString('Conv', 'Comment', 'dbyoung@sina.com');

    { ��Ƶ����·�� }
    chkDepartPath.Checked := ReadBool('Depart', 'SamePath', True);
    if not chkDepartPath.Checked then
      srchbxDepartVideoSavePath.Text := ReadString('Depart', 'SavePath', 'D:\');

    Free;
  end;

{$IF Defined(CPUX86)}
  rgGPU.ItemIndex := 1;
  rgGPU.Enabled   := False;
{$ELSE}
  with TIniFile.Create(strIniFileName) do
  begin
    rgGPU.ItemIndex := ReadInteger('Main', 'UseGPU', 0);
    rgGPU.Enabled   := True;
    Free;
  end;
{$ENDIF}
end;

{ ����ϵͳ���� }
procedure TfrmFFUI.SaveConfigProc;
var
  strIniFileName: String;
begin
  strIniFileName := ExtractFilePath(ParamStr(0)) + 'config.ini';
  with TIniFile.Create(strIniFileName) do
  begin
    WriteInteger('Main', 'PlayUI', rgUI.ItemIndex);
    WriteInteger('Main', 'UseGPU', rgGPU.ItemIndex);
    WriteInteger('Conv', 'Format', cbbConv.ItemIndex);
    WriteBool('Conv', 'SameSize', chkVideoSize.Checked);
    WriteBool('Conv', 'SamePath', chkVideoSavePath.Checked);

    { ��Ƶ�ֱ��ʴ�С }
    if not chkVideoSize.Checked then
    begin
      WriteString('Conv', 'SizeWidth', edtVideoWidth.Text);
      WriteString('Conv', 'SizeHeight', edtVideoHeight.Text);
    end
    else
    begin
      DeleteKey('Conv', 'SizeWidth');
      DeleteKey('Conv', 'SizeHeight');
    end;

    { ��Ƶ����·�� }
    if not chkVideoSavePath.Checked then
      WriteString('Conv', 'SavePath', srchbxVideoConvSavePath.Text)
    else
      DeleteKey('Conv', 'SavePath');

    { ��Ƶ������Ϣ }
    WriteString('Conv', 'Title', edtTitle.Text);
    WriteString('Conv', 'Artist', edtArtist.Text);
    WriteString('Conv', 'Genre', edtGenre.Text);
    WriteString('Conv', 'Comment', edtComment.Text);

    { ���뱣��·�� }
    WriteBool('Depart', 'SamePath', chkDepartPath.Checked);
    if not chkDepartPath.Checked then
      WriteString('Depart', 'SavePath', srchbxDepartVideoSavePath.Text)
    else
      DeleteKey('Depart', 'SavePath');

    Free;
  end;
end;

{ ����ϵͳ���� }
function TfrmFFUI.SaveConfig: Boolean;
begin
  Result := False;

  if (Trim(edtTitle.Text) = '') or (Trim(edtArtist.Text) = '') or (Trim(edtGenre.Text) = '') or (Trim(edtComment.Text) = '') then
  begin
    MessageBox(Handle, '��Ƶ������Ϣ������Ϊ�գ���������ȷ��ֵ', c_strMsgTitle, MB_OK or MB_ICONWARNING);
    Exit;
  end;

  if not chkVideoSize.Checked then
  begin
    if (Trim(edtVideoWidth.Text) = '') or (Trim(edtVideoHeight.Text) = '') or (edtVideoWidth.Text = '0') or (edtVideoHeight.Text = '0') then
    begin
      MessageBox(Handle, '����������ȷ��Ƶ�Ŀ�͸�', c_strMsgTitle, MB_OK or MB_ICONWARNING);
      edtVideoWidth.SetFocus;
      Exit;
    end;
  end;

  if not chkVideoSavePath.Checked then
  begin
    if Trim(srchbxVideoConvSavePath.Text) = '' then
    begin
      MessageBox(Handle, '����ѡ��һ��Ŀ¼��������ת�������Ƶ', c_strMsgTitle, MB_OK or MB_ICONWARNING);
      Exit;
    end;
  end;

  if not chkDepartPath.Checked then
  begin
    if Trim(srchbxDepartVideoSavePath.Text) = '' then
    begin
      MessageBox(Handle, '����ѡ��һ��Ŀ¼��������������Ƶ', c_strMsgTitle, MB_OK or MB_ICONWARNING);
      Exit;
    end;
  end;

  Result := True;
  SaveConfigProc;
end;

procedure TfrmFFUI.rgUIClick(Sender: TObject);
begin
  SaveConfig;
end;

procedure TfrmFFUI.btnSaveConvParamAndStartConvClick(Sender: TObject);
begin
  if not SaveConfig then
    Exit;

  pgcAll.ActivePage := tsConv;
  btnVideoStartConv.Click;
end;

procedure TfrmFFUI.btnSaveConvParamClick(Sender: TObject);
begin
  SaveConfig;
end;

procedure TfrmFFUI.btnSaveVideoPathClick(Sender: TObject);
var
  strSelectedFolder: String;
begin
  if not SelectDirectory('ѡ�񱣴���Ƶת�����Ŀ¼��', 'ѡ��Ŀ¼��', strSelectedFolder) then
    Exit;

  srchbxVideoConvSavePath.Text := strSelectedFolder;
end;

procedure TfrmFFUI.chkVideoSizeClick(Sender: TObject);
begin
  lblVideoWidth.Visible  := not chkVideoSize.Checked;
  lblVideoHeight.Visible := not chkVideoSize.Checked;
  edtVideoWidth.Visible  := not chkVideoSize.Checked;
  edtVideoHeight.Visible := not chkVideoSize.Checked;
end;

procedure TfrmFFUI.chkDepartPathClick(Sender: TObject);
begin
  lblDepartPath.Visible             := not chkDepartPath.Checked;
  srchbxDepartVideoSavePath.Visible := not chkDepartPath.Checked;
end;

procedure TfrmFFUI.chkVideoSavePathClick(Sender: TObject);
begin
  lblSaveVideoPath.Visible        := not chkVideoSavePath.Checked;
  srchbxVideoConvSavePath.Visible := not chkVideoSavePath.Checked;
end;

{ �����﷨������ SynEdit �ؼ� }
procedure TfrmFFUI.CreateSynEdit;
begin
  FJSONHL := TSynJSONSyn.Create(Self);

  FSynEdit_VideoInfo                := TSynEdit.Create(tsInfo);
  FSynEdit_VideoInfo.Parent         := tsInfo;
  FSynEdit_VideoInfo.Align          := alClient;
  FSynEdit_VideoInfo.BorderStyle    := bsNone;
  FSynEdit_VideoInfo.Gutter.Visible := False;
  FSynEdit_VideoInfo.Font.Name      := '����';
  FSynEdit_VideoInfo.Font.Size      := 12;
  FSynEdit_VideoInfo.RightEdge      := tsInfo.Width;
  FSynEdit_VideoInfo.ScrollBars     := ssVertical;
  FSynEdit_VideoInfo.Highlighter    := FJSONHL;
  FSynEdit_VideoInfo.ReadOnly       := True;

  FSynEdit_VideoConv                := TSynEdit.Create(pnlVideoConv);
  FSynEdit_VideoConv.Parent         := pnlVideoConv;
  FSynEdit_VideoConv.Align          := alClient;
  FSynEdit_VideoConv.BorderStyle    := bsNone;
  FSynEdit_VideoConv.Gutter.Visible := False;
  FSynEdit_VideoConv.Font.Name      := '����';
  FSynEdit_VideoConv.Font.Size      := 12;
  FSynEdit_VideoConv.RightEdge      := pnlVideoConv.Width;
  FSynEdit_VideoConv.ScrollBars     := ssVertical;
  FSynEdit_VideoConv.Highlighter    := FJSONHL;
  FSynEdit_VideoConv.ReadOnly       := True;
end;

procedure TfrmFFUI.FormCreate(Sender: TObject);
begin
  { �����������ؼ� }
  FDOSCommand              := TDosCommand.Create(nil);
  FDOSCommand.OnNewLine    := DosCommandLine;
  FDOSCommand.OnTerminated := DosCommandTerminated;
  CreateSynEdit;

  { ��ʼ������ }
  FbVideoConv            := False;
  FhPlayVideoWnd         := 0;
  pgcAll.ActivePageIndex := 0;

  { ����ϵͳ���� }
  LoadConfig;
end;

procedure TfrmFFUI.FormDestroy(Sender: TObject);
begin
  { ����ϵͳ���� }
  SaveConfig;

  { ���ٴ����ĵ������ؼ� }
  FDOSCommand.Free;
  FJSONHL.Free;
  FSynEdit_VideoConv.Free;
  FSynEdit_VideoInfo.Free;
end;

procedure TfrmFFUI.FormResize(Sender: TObject);
begin
  pgcAll.TabWidth := (Width - 35) div 7;

  if FhPlayVideoWnd <> 0 then
  begin
    SetWindowLong(FhPlayVideoWnd, GWL_STYLE, NativeInt($96000000));
    SetWindowLong(FhPlayVideoWnd, GWL_EXSTYLE, $00050000);
    SetWindowPos(FhPlayVideoWnd, pnlVideo.Handle, 0, 0, pnlVideo.Width, pnlVideo.Height, SWP_NOZORDER OR SWP_NOACTIVATE);
  end;
end;

{ Dos ���������з��ص��ַ��� }
procedure TfrmFFUI.DosCommandLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
begin
  if FbVideoConv then
  begin
    FSynEdit_VideoConv.Lines.Insert(0, ANewLine);
  end
  else
  begin
    FSynEdit_VideoInfo.Lines.Add(ANewLine);
  end;
end;

{ ��Ƶת������ }
procedure TfrmFFUI.DosCommandTerminated(Sender: TObject);
begin
  if FbVideoConv then
  begin
    FbVideoConv               := False;
    btnVideoStartConv.Enabled := True;
    btnVideoStopConv.Enabled  := False;
  end;
end;

{ Dos �����в������Ƶ����а� }
procedure TfrmFFUI.mniCopyDosCommandClick(Sender: TObject);
begin
  Clipboard.AsText := statInfo.SimpleText;
end;

{ ��ȡ��Ƶ�ļ���ʽ��Ϣ }
procedure TfrmFFUI.GetVideoFileInfo(const strFileName: string);
var
  strFFMPEGPath: string;
begin
  strFFMPEGPath := ExtractFilePath(ParamStr(0)) + 'video\ffmpeg';
  SetDllDirectory(PChar(strFFMPEGPath));
  FSynEdit_VideoInfo.Lines.Clear;
  FDOSCommand.CommandLine := Format('"%s\ffprobe.exe" -hide_banner -v quiet -show_streams -print_format json "%s"', [strFFMPEGPath, strFileName]);
  FDOSCommand.Execute;
  statInfo.SimpleText := FDOSCommand.CommandLine;
end;

{ ��ѯĿ¼�µ�������Ƶ�ļ� }
procedure TfrmFFUI.FindVideoFile(const strFolder: string);
var
  gfs        : TStringDynArray;
  strFileName: String;
begin
  gfs := TDirectory.GetFiles(strFolder, '*.avi');
  for strFileName in gfs do
    lstFiles.Items.Add(strFileName);

  gfs := TDirectory.GetFiles(strFolder, '*.mp4');
  for strFileName in gfs do
    lstFiles.Items.Add(strFileName);

  gfs := TDirectory.GetFiles(strFolder, '*.mkv');
  for strFileName in gfs do
    lstFiles.Items.Add(strFileName);

  gfs := TDirectory.GetFiles(strFolder, '*.mov');
  for strFileName in gfs do
    lstFiles.Items.Add(strFileName);

  gfs := TDirectory.GetFiles(strFolder, '*.rmvb');
  for strFileName in gfs do
    lstFiles.Items.Add(strFileName);

  gfs := TDirectory.GetFiles(strFolder, '*.vob');
  for strFileName in gfs do
    lstFiles.Items.Add(strFileName);

  if lstFiles.Count > 0 then
  begin
    pgcAll.ActivePage := tsInfo;
    GetVideoFileInfo(lstFiles.Items.Strings[0]);
  end;
end;

{ ���ļ� }
procedure TfrmFFUI.mniOpenFileClick(Sender: TObject);
begin
  if not dlgOpenVideoFile.Execute then
    Exit;

  FFileStyle                 := fsFile;
  srchbxSelectVideoFile.Text := dlgOpenVideoFile.FileName;
  pgcAll.ActivePage          := tsInfo;
  GetVideoFileInfo(dlgOpenVideoFile.FileName);
  lstFiles.Items.Add(dlgOpenVideoFile.FileName);
end;

{ ���ļ��� }
procedure TfrmFFUI.mniOpenFolderClick(Sender: TObject);
var
  strFolder: String;
begin
  if not SelectDirectory('ѡ��һ��Ŀ¼��Ŀ¼�°�����Ƶ�ļ�', 'Ŀ¼���ƣ�', strFolder) then
    Exit;

  srchbxSelectVideoFile.Text := strFolder;
  FindVideoFile(strFolder);
  FFileStyle := fsFolder;
end;

{ ��������Ƶ����ַ }
procedure TfrmFFUI.mniOpenWebStreamClick(Sender: TObject);
var
  strWebStreamAddr: String;
begin
  if not InputQuery('������Ƶ��ַ��', '��ַ��', strWebStreamAddr) then
    Exit;

  srchbxSelectVideoFile.Text := strWebStreamAddr;
  FFileStyle                 := fsStream;
  pgcAll.ActivePage          := tsPlay;
  btnPlay.Click;
end;

procedure TfrmFFUI.srchbxSelectVideoFileInvokeSearch(Sender: TObject);
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  pmOpen.Popup(pt.x, pt.y);
end;

{$REGION 'PlayVideo'}

procedure TfrmFFUI.tmrPlayVideoTimer(Sender: TObject);
begin
  if rgUI.ItemIndex = 0 then
    FhPlayVideoWnd := FindWindow('SDL_app', 'ffplay')
  else if rgUI.ItemIndex = 1 then
    FhPlayVideoWnd := FindWindow('mpv', 'mpv')
  else if rgUI.ItemIndex = 2 then
    FhPlayVideoWnd := FindWindow('Qt5QWindowIcon', 'VLC media player');

  if FhPlayVideoWnd <> 0 then
  begin
    tmrPlayVideo.Enabled := False;
    SetWindowLong(FhPlayVideoWnd, GWL_STYLE, NativeInt($96000000));
    SetWindowLong(FhPlayVideoWnd, GWL_EXSTYLE, $00050000);
    Winapi.Windows.SetParent(FhPlayVideoWnd, pnlVideo.Handle);
    SetWindowPos(FhPlayVideoWnd, pnlVideo.Handle, 0, 0, pnlVideo.Width, pnlVideo.Height, SWP_NOZORDER OR SWP_NOACTIVATE);
    ShowWindow(FhPlayVideoWnd, SW_SHOWNORMAL);
  end;
end;

{ ������Ƶ }
procedure TfrmFFUI.PlayVideoFile(const strVideoFileName: String);
var
  strPlayProgramPath: String;
begin
  case rgUI.ItemIndex of
    0:
      begin
        strPlayProgramPath      := ExtractFilePath(ParamStr(0)) + 'video\ffmpeg';
        FDOSCommand.CommandLine := Format('"%s\ffplay.exe" -hide_banner -window_title ffplay "%s"', [strPlayProgramPath, strVideoFileName]);
      end;
    1:
      begin
        strPlayProgramPath      := ExtractFilePath(ParamStr(0)) + 'video\mpv';
        FDOSCommand.CommandLine := Format('"%s\mpv.exe" --title=mpv "%s"', [strPlayProgramPath, strVideoFileName]);
      end;
    2:
      begin
        strPlayProgramPath      := ExtractFilePath(ParamStr(0)) + 'video\vlc';
        FDOSCommand.CommandLine := Format('"%s\vlc.exe" --no-qt-name-in-title --qt-minimal-view --no-qt-system-tray "%s"', [strPlayProgramPath, strVideoFileName]);
      end;
  end;
  SetDllDirectory(PChar(strPlayProgramPath));
  FDOSCommand.Execute;
  statInfo.SimpleText  := FDOSCommand.CommandLine;
  tmrPlayVideo.Enabled := True;
  btnPlay.Enabled      := False;
  btnPause.Enabled     := True;
  btnStop.Enabled      := True;
end;

procedure TfrmFFUI.btnPlayClick(Sender: TObject);
begin
  if srchbxSelectVideoFile.Text = '' then
  begin
    MessageBox(Handle, '����ѡ���һ����Ƶ�ļ����ٲ���', c_strMsgTitle, MB_OK or MB_ICONWARNING);
    srchbxSelectVideoFile.SetFocus;
    Exit;
  end;

  if FhPlayVideoWnd <> 0 then
  begin
    MessageBox(Handle, '��Ƶ���ڲ��ţ���ֹͣ���ٴβ���', c_strMsgTitle, MB_OK or MB_ICONWARNING);
    Exit;
  end;

  if FFileStyle = fsFile then
    PlayVideoFile(srchbxSelectVideoFile.Text)
  else if FFileStyle = fsFolder then
    PlayVideoFile(lstFiles.Items.Strings[0])
  else if FFileStyle = fsStream then
    PlayVideoFile(srchbxSelectVideoFile.Text);
end;

{ �� ffplay/mpv ���������ͼ������� }
procedure TfrmFFUI.SendPlayUIKey(H: HWND; Key: Char);
var
  vKey, ScanCode : Word;
  lParam, ConvKey: LongInt;
begin
  ConvKey  := OemKeyScan(ord(Key));
  ScanCode := ConvKey and $000000FF or $FF00;
  vKey     := ord(Key);
  lParam   := LongInt(ScanCode) shl 16 or 1;
  SendMessage(H, WM_KEYDOWN, vKey, lParam);
  SendMessage(H, WM_CHAR, vKey, lParam);
  lParam := lParam or LongInt($C0000000);
  SendMessage(H, WM_KEYUP, vKey, lParam);
end;

{ �� vlc ���������ͼ������� }
procedure TfrmFFUI.SendPlayUIKey_vlc(H: HWND; Key: Char);
begin
  //
end;

procedure TfrmFFUI.btnPauseClick(Sender: TObject);
begin
  if FhPlayVideoWnd = 0 then
    Exit;

  if rgUI.ItemIndex <> 2 then
    SendPlayUIKey(FhPlayVideoWnd, 'p')
  else
    SendPlayUIKey_vlc(FhPlayVideoWnd, Char(VK_SPACE));
end;

procedure TfrmFFUI.btnStopClick(Sender: TObject);
begin
  if FhPlayVideoWnd = 0 then
    Exit;

  if rgUI.ItemIndex <> 2 then
    SendPlayUIKey(FhPlayVideoWnd, 'q')
  else
    SendPlayUIKey_vlc(FhPlayVideoWnd, 's');

  btnPlay.Enabled  := True;
  btnPause.Enabled := False;
  btnStop.Enabled  := False;
  FhPlayVideoWnd   := 0;
end;
{$ENDREGION}
{$REGION 'VideoConvertor'}

procedure TfrmFFUI.btnAddFolderClick(Sender: TObject);
var
  strFolder: String;
begin
  if not SelectDirectory('ѡ��һ��Ŀ¼��Ŀ¼�°�����Ƶ�ļ�', 'Ŀ¼���ƣ�', strFolder) then
    Exit;

  FindVideoFile(strFolder);
end;

procedure TfrmFFUI.btnAddVideoFileClick(Sender: TObject);
begin
  if not dlgOpenVideoFile.Execute then
    Exit;

  lstFiles.Items.Add(dlgOpenVideoFile.FileName);
end;

procedure TfrmFFUI.btnDelVideoFileClick(Sender: TObject);
begin
  if lstFiles.ItemIndex <> -1 then
    lstFiles.DeleteSelected;
end;

procedure TfrmFFUI.btnDepartPathClick(Sender: TObject);
var
  strSelectedFolder: String;
begin
  if not SelectDirectory('ѡ�񱣴���Ƶת�����Ŀ¼��', 'ѡ��Ŀ¼��', strSelectedFolder) then
    Exit;

  srchbxDepartVideoSavePath.Text := strSelectedFolder;
end;

procedure TfrmFFUI.btnVideoConvParamClick(Sender: TObject);
begin
  pgcAll.ActivePage := tsConfig;
end;

{ ��ʼ��Ƶת�� }
procedure TfrmFFUI.btnVideoStartConvClick(Sender: TObject);
const
  c_strVideoSize           = ' -s %sx%s ';
  c_strVideoInfo           = ' -metadata "title=%s" -metadata "artist=%s" -metadata "genre=%s" -metadata "comment=%s" ';
  c_strFFMPEGConv_CPU_H264 = '"%s\ffmpeg" -hide_banner -i "%s" -c:v libx264    %s %s -y "%s"';
  c_strFFMPEGConv_GPU_H264 = '"%s\ffmpeg" -hide_banner -i "%s" -c:v h264_nvenc %s %s -y "%s"';
  c_strFFMPEGConv_CPU_FFLV = '"%s\ffmpeg" -hide_banner -i "%s" -c:v libx264    %s %s -y "%s"';
  c_strFFMPEGConv_CPU_H265 = '"%s\ffmpeg" -hide_banner -i "%s" -c:v libx265    %s %s -y "%s"';
  c_strFFMPEGConv_GPU_H265 = '"%s\ffmpeg" -hide_banner -i "%s" -c:v h265_nvenc %s %s -y "%s"';
  c_strFFMPEGConv_GPU_FFLV = '"%s\ffmpeg" -hide_banner -i "%s" -c:v h264_nvenc %s %s -y "%s"';
var
  strFFMPEGPath      : String;
  strFFMPGCommandLine: String;
  strInputFile       : string;
  strOutPutFile      : string;
  I                  : Integer;
  strTempCMDFileName : String;
  lstCMD             : TStringList;
  strExtFileName     : String;
  strVideoSize       : String;
  strVideoInfo       : String;
  procedure X86_CPU;
  begin
    case cbbConv.ItemIndex of
      0:
        strFFMPGCommandLine := Format(c_strFFMPEGConv_CPU_H264, [strFFMPEGPath, strInputFile, strVideoSize, strVideoInfo, strOutPutFile]);
      1:
        strFFMPGCommandLine := Format(c_strFFMPEGConv_CPU_H265, [strFFMPEGPath, strInputFile, strVideoSize, strVideoInfo, strOutPutFile]);
      2:
        strFFMPGCommandLine := Format(c_strFFMPEGConv_CPU_FFLV, [strFFMPEGPath, strInputFile, strVideoSize, strVideoInfo, strOutPutFile]);
    end;
  end;

  procedure X64_CPU;
  begin
    X86_CPU;
  end;

  procedure X64_GPU;
  begin
    case cbbConv.ItemIndex of
      0:
        strFFMPGCommandLine := Format(c_strFFMPEGConv_GPU_H264, [strFFMPEGPath, strInputFile, strVideoSize, strVideoInfo, strOutPutFile]);
      1:
        strFFMPGCommandLine := Format(c_strFFMPEGConv_GPU_H265, [strFFMPEGPath, strInputFile, strVideoSize, strVideoInfo, strOutPutFile]);
      2:
        strFFMPGCommandLine := Format(c_strFFMPEGConv_GPU_FFLV, [strFFMPEGPath, strInputFile, strVideoSize, strVideoInfo, strOutPutFile]);
    end;
  end;

begin
  if lstFiles.Count <= 0 then
  begin
    MessageBox(Handle, '�����������Ƶ�ļ���ת��', c_strMsgTitle, MB_OK or MB_ICONWARNING);
    Exit;
  end;

  strVideoInfo := Format(c_strVideoInfo, [edtTitle.Text, edtArtist.Text, edtGenre.Text, edtComment.Text]);
  if chkVideoSize.Checked then
    strVideoSize := ''
  else
    strVideoSize := Format(c_strVideoSize, [edtVideoWidth.Text, edtVideoHeight.Text]);

  strExtFileName := Ifthen(cbbConv.ItemIndex <> 2, '.mkv', '.flv');
  strFFMPEGPath  := ExtractFilePath(ParamStr(0)) + 'video\ffmpeg';
  lstCMD         := TStringList.Create;
  try
    for I := 0 to lstFiles.Count - 1 do
    begin
      Application.ProcessMessages;
      strInputFile := lstFiles.Items.Strings[I];
      if chkVideoSavePath.Checked then
      begin
        strOutPutFile := ChangeFileExt(strInputFile, strExtFileName);
        if SameText(strOutPutFile, strInputFile) then
          strOutPutFile := strInputFile + strExtFileName;
      end
      else
      begin
        strOutPutFile := srchbxVideoConvSavePath.Text + ChangeFileExt(ExtractFileName(strInputFile), strExtFileName);
        if not System.SysUtils.DirectoryExists(ExtractFileDir(strOutPutFile)) then
          System.SysUtils.ForceDirectories(ExtractFileDir(strOutPutFile));
      end;

{$IF Defined(CPUX86)}
      X86_CPU;
{$ELSE}
      if rgGPU.ItemIndex = 0 then
        X64_GPU
      else
        X64_CPU;
{$ENDIF}
      lstCMD.Add(strFFMPGCommandLine);
    end;

    strTempCMDFileName := TPath.GetTempPath + 'conv.cmd';
    lstCMD.SaveToFile(strTempCMDFileName);
    FDOSCommand.CommandLine := strTempCMDFileName;
    FDOSCommand.Execute;
    FbVideoConv := True;
    FSynEdit_VideoConv.Lines.Clear;
    btnVideoStartConv.Enabled := False;
    btnVideoStopConv.Enabled  := True;
    statInfo.SimpleText       := lstCMD.Strings[0];
  finally
    lstCMD.Free;
  end;
end;

{ ��ȡ����·�� }
function GetProcessName(dwProcessID: LongInt; bFullPath: Bool): String;
var
  pinfo: PROCESS_INFO;
begin
  GetProcessInfo(dwProcessID, pinfo);
  Result := String(pinfo.ImagePathName);
end;

{ TDosCommand.Stop �޷�ֹͣ CMD ���̣����ֶ�ɱ������ }
procedure TfrmFFUI.KillProcessOfName(const strProcessName: string);
var
  hSnapshot    : THandle;
  lppe         : TProcessEntry32;
  bFound       : Boolean;
  strModulePath: string;
begin
  hSnapshot   := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  lppe.dwSize := SizeOf(TProcessEntry32);
  bFound      := Process32First(hSnapshot, lppe);
  while bFound do
  begin
    strModulePath := GetProcessName(lppe.th32ProcessID, True);
    if SameText(strModulePath, strProcessName) then
    begin
      TerminateProcess(OpenProcess(PROCESS_TERMINATE, Bool(0), lppe.th32ProcessID), 0);
      Break;
    end;
    bFound := Process32Next(hSnapshot, lppe);
  end;
end;

procedure TfrmFFUI.btnVideoStopConvClick(Sender: TObject);
begin
  { TDosCommand.Stop �޷�ֹͣ CMD ���̣����ֶ�ɱ������ }
  KillProcessOfName(ExtractFilePath(ParamStr(0)) + 'video\ffmpeg\ffmpeg.exe');

  FbVideoConv               := False;
  btnVideoStartConv.Enabled := True;
  btnVideoStopConv.Enabled  := False;
  FDOSCommand.Stop;
end;

{$ENDREGION}

end.
