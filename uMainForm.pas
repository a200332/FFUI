unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.TlHelp32, Winapi.PsAPI, Winapi.ShellAPI, Winapi.ShlObj, Winapi.ActiveX, System.SysUtils, System.StrUtils, System.Variants, System.Classes, System.IniFiles, System.IOUtils, System.Types, System.Math,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.ComCtrls, Vcl.Menus, Vcl.Clipbrd, Vcl.FileCtrl,
  {�������ؼ�}
  SynEdit, SynHighlighterJSON, DosCommand, uProcessAPI, System.ImageList,
  Vcl.ImgList;

type
  { ���ļ���ʽ���ļ�/�ļ���/������Ƶ����ַ }
  TFileStyle = (fsFile, fsFolder, fsStream);

  { ��Ƶ����״̬ }
  TStatStyle = (ssBlank, ssInfo, ssPaly, ssConv, ssSplit, ssMerge, ssLine);

  { ��Ƶ������Ƶ������Ļ����ת�� }
  TVideoStyle = (vsVideo, vsAudio, vsSubtitle, vsConv);

  { �������� }
  TLangUI = (lngChinese, lngEnglish);

type
  TfrmFFUI = class(TForm)
    lblVideoFile: TLabel;
    pgcAll: TPageControl;
    tsInfo: TTabSheet;
    tsPlay: TTabSheet;
    pnlButtonCommand: TPanel;
    btnVideoPlayPlay: TButton;
    btnVideoPlayPause: TButton;
    btnVideoPlayStop: TButton;
    pnlVideo: TPanel;
    tsConv: TTabSheet;
    tsSplit: TTabSheet;
    tsMerge: TTabSheet;
    tsLive: TTabSheet;
    rgLive: TRadioGroup;
    pnlWeb: TPanel;
    srchbxSelectVideoFile: TSearchBox;
    dlgOpenVideoFile: TOpenDialog;
    tsConfig: TTabSheet;
    rgPlayUI: TRadioGroup;
    rgUseGPU: TRadioGroup;
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
    chkConvSavePath: TCheckBox;
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
    lblVideoInfo: TLabel;
    btnSaveConvParam: TButton;
    btnSaveConvParamAndStartConv: TButton;
    lblVidoeSplitAudio: TLabel;
    lblVidoeSplitVideo: TLabel;
    lblVidoeSplitSubtitle: TLabel;
    lstSplitVideo: TListBox;
    lstSplitAudio: TListBox;
    lstSplitSubtitle: TListBox;
    btnVideoSplit: TButton;
    lblVideoSplitTip: TLabel;
    grpSplitPath: TGroupBox;
    chkSplitPath: TCheckBox;
    lblSplitPath: TLabel;
    srchbxVideoConvSavePath: TSearchBox;
    srchbxSplitVideoSavePath: TSearchBox;
    lnklblHelpAccelGPU: TLinkLabel;
    rgLanguageUI: TRadioGroup;
    ilpgc: TImageList;
    tsCut: TTabSheet;
    chkConvOpenSavePath: TCheckBox;
    chkSplitOpenSavePath: TCheckBox;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure srchbxSelectVideoFileInvokeSearch(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mniOpenFileClick(Sender: TObject);
    procedure mniOpenFolderClick(Sender: TObject);
    procedure mniOpenWebStreamClick(Sender: TObject);
    procedure mniCopyDosCommandClick(Sender: TObject);
    procedure rgPlayUIClick(Sender: TObject);
    procedure btnVideoPlayPlayClick(Sender: TObject);
    procedure btnAddVideoFileClick(Sender: TObject);
    procedure btnDelVideoFileClick(Sender: TObject);
    procedure tmrPlayVideoTimer(Sender: TObject);
    procedure btnVideoPlayPauseClick(Sender: TObject);
    procedure btnVideoPlayStopClick(Sender: TObject);
    procedure btnAddFolderClick(Sender: TObject);
    procedure chkVideoSizeClick(Sender: TObject);
    procedure chkConvSavePathClick(Sender: TObject);
    procedure btnVideoStartConvClick(Sender: TObject);
    procedure btnVideoStopConvClick(Sender: TObject);
    procedure btnVideoConvParamClick(Sender: TObject);
    procedure btnSaveConvParamClick(Sender: TObject);
    procedure btnSaveConvParamAndStartConvClick(Sender: TObject);
    procedure btnSaveVideoPathClick(Sender: TObject);
    procedure chkSplitPathClick(Sender: TObject);
    procedure btnSplitPathClick(Sender: TObject);
    procedure lnklblHelpAccelGPULinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
    procedure rgLanguageUIClick(Sender: TObject);
    procedure btnVideoSplitClick(Sender: TObject);
    procedure chkConvOpenSavePathClick(Sender: TObject);
  private
    FlngUI             : TLangUI;
    FDOSCommand        : TDosCommand;
    FSynEdit_VideoInfo : TSynEdit;
    FSynEdit_VideoConv : TSynEdit;
    FSynEdit_VideoSplit: TSynEdit;
    FJSONHL            : TSynJSONSyn;
    FFileStyle         : TFileStyle;
    FVideoStyle        : TVideoStyle;
    FhPlayVideoWnd     : HWND;
    FStatStyle         : TStatStyle;
    FbLoadConfig       : Boolean;
    { ���Ľ������� }
    procedure ChangeLanguageUI;
    procedure ChangeLanguageChinese;
    procedure ChangeLanguageEnglish;
    function TransUI(const strLang: string): String;
    { �����﷨������ SynEdit �ؼ� }
    procedure CreateSynEdit;
    { ����ϵͳ���� }
    procedure LoadConfig;
    { ����ϵͳ���� }
    procedure SaveConfigProc;
    function SaveConfig: Boolean;
    { ��ȡ��Ƶ�ļ���ʽ��Ϣ }
    procedure GetVideoFileInfo(const strVideoFileName: string);
    { ��ȡ��Ƶ�ļ�����Ƶ������Ƶ������Ļ����Ϣ }
    procedure GetVideoSplitInfo(const strVideoFileName: string);
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
    procedure KillProcessOfProcessName(const strProcessName: string);
    { ����Ƶת����ı���Ŀ¼ }
    procedure OpenVideoConvPath;
    { ����Ƶ�����ı���Ŀ¼ }
    procedure OpenVideoSplitPath;
  end;

var
  frmFFUI: TfrmFFUI;

implementation

{$R *.dfm}

const
  c_strMsgTitle: PChar = 'ϵͳ��ʾ��';

function TfrmFFUI.TransUI(const strLang: string): String;
begin
  if FlngUI = lngEnglish then
  begin
    if SameText(strLang, String(c_strMsgTitle)) then
      Result := 'System Information��'
    else if SameText(strLang, '��Ƶ������Ϣ������Ϊ�գ���������ȷ��ֵ') then
      Result := 'Video Info is not null, must be input'
    else if SameText(strLang, '����������ȷ��Ƶ�Ŀ�͸�') then
      Result := 'Must be intput video width/height'
    else if SameText(strLang, '����ѡ��һ��Ŀ¼��������ת�������Ƶ') then
      Result := 'Must be select a folder, save convert'
    else if SameText(strLang, '����ѡ��һ��Ŀ¼��������������Ƶ') then
      Result := 'Must be select a folder, save split'
    else if SameText(strLang, 'ѡ�񱣴���Ƶת�����Ŀ¼��') then
      Result := 'select a folder, save convert��'
    else if SameText(strLang, 'ѡ��Ŀ¼��') then
      Result := 'select folder��'
    else if SameText(strLang, 'ѡ��һ��Ŀ¼��Ŀ¼�°�����Ƶ�ļ�') then
      Result := 'select a folder, the folder contains video'
    else if SameText(strLang, 'Ŀ¼���ƣ�') then
      Result := 'Folder name��'
    else if SameText(strLang, '������Ƶ��ַ��') then
      Result := 'Web stream addr��'
    else if SameText(strLang, '��ַ��') then
      Result := 'Addr��'
    else if SameText(strLang, '����ѡ���һ����Ƶ�ļ����ٲ���') then
      Result := 'Please select a video file before playing'
    else if SameText(strLang, '��Ƶ���ڲ��ţ���ֹͣ���ٴβ���') then
      Result := 'Video is playing, please stop and play again'
    else if SameText(strLang, 'ѡ�񱣴���Ƶת�����Ŀ¼��') then
      Result := 'Select video save folder��'
    else if SameText(strLang, '�����������Ƶ�ļ���ת��') then
      Result := 'Video files must be added before conversion'
    else if SameText(strLang, '�����ȴ�һ����Ƶ�ļ����ٽ�����Ƶ����') then
      Result := 'A video file must be opened before video split'
  end
  else
  begin
    Result := strLang;
  end;
end;

procedure TfrmFFUI.ChangeLanguageChinese;
begin
  mniOpenFile.Caption       := '���ļ�...';
  mniOpenFolder.Caption     := '���ļ���...';
  mniOpenWebStream.Caption  := '�����紮��...';
  mniCopyDosCommand.Caption := '���Ƶ����а�';

  lblVideoFile.Caption := '���ļ�/�ļ���/���紮����';
  tsInfo.Caption       := '��Ϣ';
  tsPlay.Caption       := '����';
  tsConv.Caption       := 'ת��';
  tsSplit.Caption      := '����';
  tsMerge.Caption      := '�ϲ�';
  tsCut.Caption        := '��ȡ';
  tsLive.Caption       := 'ֱ��';
  tsConfig.Caption     := '����';

  btnVideoPlayPlay.Caption  := '����';
  btnVideoPlayPause.Caption := '��ͣ';
  btnVideoPlayStop.Caption  := 'ֹͣ';

  btnAddVideoFile.Caption   := '����ļ�';
  btnAddFolder.Caption      := '����ļ���';
  btnDelVideoFile.Caption   := 'ɾ��';
  btnVideoConvParam.Caption := '��������';
  btnVideoStartConv.Caption := 'ת��';
  btnVideoStopConv.Caption  := 'ֹͣת��';

  lblVideoSplitTip.Caption      := '���ļ�������';
  lblVidoeSplitVideo.Caption    := '��Ƶ����';
  lblVidoeSplitAudio.Caption    := '��Ƶ����';
  lblVidoeSplitSubtitle.Caption := '��Ļ����';
  btnVideoSplit.Caption         := '����';

  rgLive.Items.Strings[0] := '�����ļ�';
  rgLive.Items.Strings[1] := 'USB����ͷ';
  rgLive.Items.Strings[2] := 'IP ���';
  rgLive.Items.Strings[3] := '�� ��';

  rgPlayUI.Caption           := '����ʱʹ�õ���Ƶ�⣺';
  rgUseGPU.Caption           := '�Ƿ�ʹ��GPU���٣�';
  rgUseGPU.Items.Strings[0]  := '��(NV GF1050�����Կ�,����>436.15,X64ƽ̨)';
  rgUseGPU.Items.Strings[1]  := '��';
  lnklblHelpAccelGPU.Caption := '<a href="https://developer.nvidia.com/video-encode-decode-gpu-support-matrix">NVIDIA GPU ���ٰ���</a>';

  grpVideoConv.Caption                 := '��ʽת����';
  lblConvTip.Caption                   := 'ת��Ϊ��';
  chkVideoSize.Caption                 := '������Ƶ���';
  lblVideoWidth.Caption                := '��';
  lblVideoHeight.Caption               := '�ߣ�';
  chkConvSavePath.Caption              := '����·��ͬ�ļ�';
  lblSaveVideoPath.Caption             := '·����';
  chkConvOpenSavePath.Caption          := 'ת�������򿪱���Ŀ¼';
  lblVideoInfo.Caption                 := '������Ϣ��';
  lblTitle.Caption                     := '���⣺';
  lblArtist.Caption                    := '������';
  lblGenre.Caption                     := '���ͣ�';
  lblComment.Caption                   := 'ע�ͣ�';
  btnSaveConvParam.Caption             := '����';
  btnSaveConvParamAndStartConv.Caption := '���沢��ʼת��';

  grpSplitPath.Caption         := '���뱣��·����';
  chkSplitPath.Caption         := '����·��ͬ�ļ�';
  lblSplitPath.Caption         := '·����';
  chkSplitOpenSavePath.Caption := '��������򿪱���Ŀ¼';

  rgLanguageUI.Caption := '�������ԣ�';
end;

procedure TfrmFFUI.ChangeLanguageEnglish;
begin
  mniOpenFile.Caption       := 'Open file...';
  mniOpenFolder.Caption     := 'Open folder...';
  mniOpenWebStream.Caption  := 'Open stream...';
  mniCopyDosCommand.Caption := 'Copy to clipbrd';

  lblVideoFile.Caption := 'Open File/Folder/Stream��';
  tsInfo.Caption       := 'Info';
  tsPlay.Caption       := 'Play';
  tsConv.Caption       := 'Conv';
  tsSplit.Caption      := 'Split';
  tsMerge.Caption      := 'Merge';
  tsCut.Caption        := 'Cut';
  tsLive.Caption       := 'Live';
  tsConfig.Caption     := 'Config';

  btnVideoPlayPlay.Caption  := 'Play';
  btnVideoPlayPause.Caption := 'Pause';
  btnVideoPlayStop.Caption  := 'Stop';

  btnAddVideoFile.Caption   := 'Add File';
  btnAddFolder.Caption      := 'Add Folder';
  btnDelVideoFile.Caption   := 'Delete';
  btnVideoConvParam.Caption := 'Param config';
  btnVideoStartConv.Caption := 'Convert';
  btnVideoStopConv.Caption  := 'Stop convert';

  lblVideoSplitTip.Caption      := 'File include��';
  lblVidoeSplitVideo.Caption    := 'Video:';
  lblVidoeSplitAudio.Caption    := 'Audio:';
  lblVidoeSplitSubtitle.Caption := 'Subtitle:';
  btnVideoSplit.Caption         := 'Split';

  rgLive.Items.Strings[0] := 'Disk File';
  rgLive.Items.Strings[1] := 'USB Camera';
  rgLive.Items.Strings[2] := 'IP Camera';
  rgLive.Items.Strings[3] := 'Desktop';

  rgPlayUI.Caption           := 'Video library for play��';
  rgUseGPU.Caption           := 'Use GPU Accelerate��';
  rgUseGPU.Items.Strings[0]  := 'Yes(NV GF1050 above,Drivers>436.15,X64)';
  rgUseGPU.Items.Strings[1]  := 'No';
  lnklblHelpAccelGPU.Caption := '<a href="https://developer.nvidia.com/video-encode-decode-gpu-support-matrix">NVIDIA GPU Help</a>';

  grpVideoConv.Caption        := 'Convert format��';
  lblConvTip.Caption          := 'Convert to��';
  chkVideoSize.Caption        := 'Same Video Size';
  lblVideoWidth.Caption       := 'W��';
  lblVideoHeight.Caption      := 'H��';
  chkConvSavePath.Caption     := 'Same Path';
  lblSaveVideoPath.Caption    := 'Path��';
  chkConvOpenSavePath.Caption := 'Open save path after finish convert';

  lblVideoInfo.Caption                 := 'Video Info��';
  lblTitle.Caption                     := 'Title:';
  lblArtist.Caption                    := 'Artist:';
  lblGenre.Caption                     := 'Genre:';
  lblComment.Caption                   := 'Comment:';
  btnSaveConvParam.Caption             := 'Save';
  btnSaveConvParamAndStartConv.Caption := 'Save And Convert';

  grpSplitPath.Caption         := 'Split save path��';
  chkSplitPath.Caption         := 'Same path';
  lblSplitPath.Caption         := 'Path��';
  chkSplitOpenSavePath.Caption := 'Open save path after finish split';

  rgLanguageUI.Caption := 'Language UI��';
end;

{ ���Ľ������� }
procedure TfrmFFUI.ChangeLanguageUI;
begin
  case FlngUI of
    lngChinese:
      ChangeLanguageChinese;
    lngEnglish:
      ChangeLanguageEnglish;
  end;
end;

{ ����ϵͳ���� }
procedure TfrmFFUI.LoadConfig;
var
  strIniFileName: String;
begin
  FbLoadConfig := True;
  try
    strIniFileName := ExtractFilePath(ParamStr(0)) + 'config.ini';
    with TIniFile.Create(strIniFileName) do
    begin
      rgPlayUI.ItemIndex := ReadInteger('Main', 'PlayUI', 0);

      { ��Ƶת������ }
      cbbConv.ItemIndex       := ReadInteger('Conv', 'Format', 0);
      chkVideoSize.Checked    := ReadBool('Conv', 'SameSize', True);
      chkConvSavePath.Checked := ReadBool('COnv', 'SamePath', True);
      if not chkVideoSize.Checked then
      begin
        edtVideoWidth.Text  := ReadString('Conv', 'SizeWidth', '800');
        edtVideoHeight.Text := ReadString('Conv', 'SizeHeight', '600');
      end;
      if not chkConvSavePath.Checked then
      begin
        srchbxVideoConvSavePath.Text := ReadString('Conv', 'SavePath', 'D:\');
      end;

      { ��Ƶ������Ϣ }
      edtTitle.Text   := ReadString('Conv', 'Title', 'dbyoung');
      edtArtist.Text  := ReadString('Conv', 'Artist', 'FFUI 2.0');
      edtGenre.Text   := ReadString('Conv', 'Genre', 'Video');
      edtComment.Text := ReadString('Conv', 'Comment', 'dbyoung@sina.com');

      { ��Ƶ����·�� }
      chkSplitPath.Checked := ReadBool('Split', 'SamePath', True);
      if not chkSplitPath.Checked then
        srchbxSplitVideoSavePath.Text := ReadString('Split', 'SavePath', 'D:\');

      { �������� }
      FlngUI                 := TLangUI(ReadInteger('UI', 'Language', 0) mod 2);
      rgLanguageUI.ItemIndex := Integer(TLangUI(ReadInteger('UI', 'Language', 0) mod 2));
      ChangeLanguageUI;

      Free;
    end;
{$IF Defined(CPUX86)}
    rgUseGPU.ItemIndex := 1;
    rgUseGPU.Enabled   := False;
{$ELSE}
    with TIniFile.Create(strIniFileName) do
    begin
      rgUseGPU.ItemIndex := ReadInteger('Main', 'UseGPU', 0);
      rgUseGPU.Enabled   := True;
      Free;
    end;
{$ENDIF}
  finally
    FbLoadConfig := False;
  end;
end;

{ ����ϵͳ���� }
procedure TfrmFFUI.SaveConfigProc;
var
  strIniFileName: String;
begin
  strIniFileName := ExtractFilePath(ParamStr(0)) + 'config.ini';
  with TIniFile.Create(strIniFileName) do
  begin
    WriteInteger('Main', 'PlayUI', rgPlayUI.ItemIndex);
    WriteInteger('Main', 'UseGPU', rgUseGPU.ItemIndex);
    WriteInteger('Conv', 'Format', cbbConv.ItemIndex);
    WriteBool('Conv', 'SameSize', chkVideoSize.Checked);
    WriteBool('Conv', 'SamePath', chkConvSavePath.Checked);

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
    if not chkConvSavePath.Checked then
      WriteString('Conv', 'SavePath', srchbxVideoConvSavePath.Text)
    else
      DeleteKey('Conv', 'SavePath');
    WriteBool('Conv', 'OpenPath', chkConvOpenSavePath.Checked);

    { ��Ƶ������Ϣ }
    WriteString('Conv', 'Title', edtTitle.Text);
    WriteString('Conv', 'Artist', edtArtist.Text);
    WriteString('Conv', 'Genre', edtGenre.Text);
    WriteString('Conv', 'Comment', edtComment.Text);

    { ���뱣��·�� }
    WriteBool('Split', 'SamePath', chkSplitPath.Checked);
    if not chkSplitPath.Checked then
      WriteString('Split', 'SavePath', srchbxSplitVideoSavePath.Text)
    else
      DeleteKey('Split', 'SavePath');

    { �������� }
    WriteInteger('UI', 'Language', rgLanguageUI.ItemIndex);

    Free;
  end;
end;

{ ����ϵͳ���� }
function TfrmFFUI.SaveConfig: Boolean;
begin
  Result := False;
  if FbLoadConfig then
    Exit;

  { ������ò�������Ч�� }
  if (Trim(edtTitle.Text) = '') or (Trim(edtArtist.Text) = '') or (Trim(edtGenre.Text) = '') or (Trim(edtComment.Text) = '') then
  begin
    MessageBox(Handle, PChar(TransUI('��Ƶ������Ϣ������Ϊ�գ���������ȷ��ֵ')), PChar(TransUI(c_strMsgTitle)), MB_OK or MB_ICONWARNING);
    Exit;
  end;

  if not chkVideoSize.Checked then
  begin
    if (Trim(edtVideoWidth.Text) = '') or (Trim(edtVideoHeight.Text) = '') or (edtVideoWidth.Text = '0') or (edtVideoHeight.Text = '0') then
    begin
      MessageBox(Handle, PChar(TransUI('����������ȷ��Ƶ�Ŀ�͸�')), PChar(TransUI(c_strMsgTitle)), MB_OK or MB_ICONWARNING);
      edtVideoWidth.SetFocus;
      Exit;
    end;
  end;

  if not chkConvSavePath.Checked then
  begin
    if Trim(srchbxVideoConvSavePath.Text) = '' then
    begin
      MessageBox(Handle, PChar(TransUI('����ѡ��һ��Ŀ¼��������ת�������Ƶ')), PChar(TransUI(c_strMsgTitle)), MB_OK or MB_ICONWARNING);
      Exit;
    end;
  end;

  if not chkSplitPath.Checked then
  begin
    if Trim(srchbxSplitVideoSavePath.Text) = '' then
    begin
      MessageBox(Handle, PChar(TransUI('����ѡ��һ��Ŀ¼��������������Ƶ')), PChar(TransUI(c_strMsgTitle)), MB_OK or MB_ICONWARNING);
      Exit;
    end;
  end;

  Result := True;
  SaveConfigProc;
end;

procedure TfrmFFUI.rgLanguageUIClick(Sender: TObject);
begin
  if not SaveConfig then
    Exit;

  FlngUI := TLangUI(Ifthen(rgLanguageUI.ItemIndex = 0, Integer(lngChinese), Integer(lngEnglish)));
  ChangeLanguageUI;
end;

procedure TfrmFFUI.rgPlayUIClick(Sender: TObject);
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
  if not SelectDirectory(TransUI('ѡ�񱣴���Ƶת�����Ŀ¼��'), TransUI('ѡ��Ŀ¼��'), strSelectedFolder) then
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

procedure TfrmFFUI.chkConvOpenSavePathClick(Sender: TObject);
begin
  SaveConfig;
end;

procedure TfrmFFUI.chkSplitPathClick(Sender: TObject);
begin
  lblSplitPath.Visible             := not chkSplitPath.Checked;
  srchbxSplitVideoSavePath.Visible := not chkSplitPath.Checked;
end;

procedure TfrmFFUI.chkConvSavePathClick(Sender: TObject);
begin
  lblSaveVideoPath.Visible        := not chkConvSavePath.Checked;
  srchbxVideoConvSavePath.Visible := not chkConvSavePath.Checked;
end;

procedure TfrmFFUI.lnklblHelpAccelGPULinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
begin
  ShellExecute(0, nil, PChar(Link), nil, nil, 1);
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

  FSynEdit_VideoSplit                := TSynEdit.Create(tsSplit);
  FSynEdit_VideoSplit.Parent         := tsSplit;
  FSynEdit_VideoSplit.Left           := 70;
  FSynEdit_VideoSplit.Top            := 324;
  FSynEdit_VideoSplit.Width          := 761;
  FSynEdit_VideoSplit.Height         := 233;
  FSynEdit_VideoSplit.Anchors        := [akLeft, akTop, akRight, akBottom];
  FSynEdit_VideoSplit.Gutter.Visible := False;
  FSynEdit_VideoSplit.Font.Name      := '����';
  FSynEdit_VideoSplit.Font.Size      := 12;
  FSynEdit_VideoSplit.RightEdge      := pnlVideoConv.Width;
  FSynEdit_VideoSplit.ScrollBars     := ssVertical;
  FSynEdit_VideoSplit.Highlighter    := FJSONHL;
  FSynEdit_VideoSplit.ReadOnly       := True;

end;

procedure TfrmFFUI.FormCreate(Sender: TObject);
begin
  { �����������ؼ� }
  FDOSCommand              := TDosCommand.Create(nil);
  FDOSCommand.OnNewLine    := DosCommandLine;
  FDOSCommand.OnTerminated := DosCommandTerminated;
  CreateSynEdit;

  { ��ʼ������ }
  FStatStyle             := ssBlank;
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
  FSynEdit_VideoSplit.Free;
  FSynEdit_VideoConv.Free;
  FSynEdit_VideoInfo.Free;
end;

procedure TfrmFFUI.FormResize(Sender: TObject);
begin
  pgcAll.TabWidth := (Width - 35) div 8;

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
  if FStatStyle = ssConv then
  begin
    FSynEdit_VideoConv.Lines.Insert(0, ANewLine);
  end
  else if FStatStyle = ssInfo then
  begin
    FSynEdit_VideoInfo.Lines.Add(ANewLine);
  end
  else if FStatStyle = ssSplit then
  begin
    if FVideoStyle <> vsConv then
      FSynEdit_VideoSplit.Lines.Add(ANewLine)
    else
      FSynEdit_VideoSplit.Lines.Insert(0, ANewLine);
  end;
end;

function SHOpenFolderAndSelectItems(pidlFolder: pItemIDList; cidl: Cardinal; apidl: Pointer; dwFlags: DWORD): HRESULT; stdcall; external shell32;

function OpenFolderAndSelectFile(const strFileName: string; const bEditMode: Boolean = False): Boolean;
var
  IIDL      : pItemIDList;
  pShellLink: IShellLink;
  hr        : Integer;
begin
  Result := False;

  hr := CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER, IID_IShellLink, &pShellLink);
  if hr = S_OK then
  begin
    pShellLink.SetPath(PChar(strFileName));
    pShellLink.GetIDList(&IIDL);
    Result := SHOpenFolderAndSelectItems(IIDL, 0, nil, Cardinal(bEditMode)) = S_OK;
  end;
end;

{ ����Ƶת����ı���Ŀ¼ }
procedure TfrmFFUI.OpenVideoConvPath;
var
  strSavePath: String;
begin
  if chkConvSavePath.Checked then
    strSavePath := ExtractFilePath(srchbxSelectVideoFile.Text)
  else
    strSavePath := srchbxVideoConvSavePath.Text;

  if chkConvOpenSavePath.Checked then
    OpenFolderAndSelectFile(srchbxSelectVideoFile.Text);
end;

{ ����Ƶ�����ı���Ŀ¼ }
procedure TfrmFFUI.OpenVideoSplitPath;
var
  strSavePath: String;
begin
  if chkSplitPath.Checked then
    strSavePath := ExtractFilePath(srchbxSelectVideoFile.Text)
  else
    strSavePath := srchbxSplitVideoSavePath.Text;

  if chkSplitOpenSavePath.Checked then
    OpenFolderAndSelectFile(srchbxSelectVideoFile.Text);
end;

{ ��Ƶת������ }
procedure TfrmFFUI.DosCommandTerminated(Sender: TObject);
var
  strTempVideoCSVFileName   : String;
  strTempAudioCSVFileName   : String;
  strTempSubtitleCSVFileName: String;
  I                         : Integer;
  strSplit                  : TArray<string>;
begin
  if FStatStyle = ssConv then
  begin
    FStatStyle                := ssBlank;
    btnVideoStartConv.Enabled := True;
    btnVideoStopConv.Enabled  := False;
    OpenVideoConvPath;
  end
  else if FStatStyle = ssSplit then
  begin
    { ��ȡ��Ƶ����Ϣ }
    if FVideoStyle = vsVideo then
    begin
      lstSplitVideo.Clear;
      strTempVideoCSVFileName := TPath.GetTempPath + 'video.csv';
      try
        FSynEdit_VideoSplit.Lines.SaveToFile(strTempVideoCSVFileName);
        with TStringList.Create do
        begin
          LoadFromFile(strTempVideoCSVFileName);
          for I := 0 to Count - 1 do
          begin
            strSplit := Strings[I].Split([',']);
            lstSplitVideo.Items.Add(strSplit[0] + '/' + strSplit[1] + '/' + strSplit[2]);
          end;
          Free;
        end;
      finally
        DeleteFile(strTempVideoCSVFileName);
      end;
    end;

    { ��ȡ��Ƶ����Ϣ }
    if FVideoStyle = vsAudio then
    begin
      lstSplitAudio.Clear;
      strTempAudioCSVFileName := TPath.GetTempPath + 'Audio.csv';
      try
        FSynEdit_VideoSplit.Lines.SaveToFile(strTempAudioCSVFileName);
        with TStringList.Create do
        begin
          LoadFromFile(strTempAudioCSVFileName);
          for I := 0 to Count - 1 do
          begin
            strSplit := Strings[I].Split([',']);
            lstSplitAudio.Items.Add(strSplit[0] + '/' + strSplit[1] + '/' + strSplit[2]);
          end;
          Free;
        end;
      finally
        DeleteFile(strTempAudioCSVFileName);
      end;
    end;

    { ��ȡ��Ļ����Ϣ }
    if FVideoStyle = vsSubtitle then
    begin
      lstSplitSubtitle.Clear;
      strTempSubtitleCSVFileName := TPath.GetTempPath + 'Subtitle.csv';
      try
        FSynEdit_VideoSplit.Lines.SaveToFile(strTempSubtitleCSVFileName);
        with TStringList.Create do
        begin
          LoadFromFile(strTempSubtitleCSVFileName);
          for I := 0 to Count - 1 do
          begin
            strSplit := Strings[I].Split([',']);
            lstSplitSubtitle.Items.Add(strSplit[0] + '/' + strSplit[1] + '/' + strSplit[2]);
          end;
          Free;
        end;
      finally
        DeleteFile(strTempSubtitleCSVFileName);
      end;
      FStatStyle := ssBlank;
    end;

    FSynEdit_VideoSplit.Lines.Clear;

    { ��Ƶ������� }
    if FVideoStyle = vsConv then
    begin
      btnVideoSplit.Enabled := True;

      { ɾ����ʱ�� CMD �ļ� }
      DeleteFile(TPath.GetTempPath + 'split.cmd');

      { �򿪷�����·�� }
      OpenVideoSplitPath;
    end;
  end;
end;

{ Dos �����в������Ƶ����а� }
procedure TfrmFFUI.mniCopyDosCommandClick(Sender: TObject);
begin
  Clipboard.AsText := statInfo.SimpleText;
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

{ ��ȡ��Ƶ�ļ���ʽ��Ϣ }
procedure TfrmFFUI.GetVideoFileInfo(const strVideoFileName: string);
var
  strFFMPEGPath: string;
begin
  FStatStyle    := ssInfo;
  strFFMPEGPath := ExtractFilePath(ParamStr(0)) + 'video\ffmpeg';
  SetDllDirectory(PChar(strFFMPEGPath));
  FSynEdit_VideoInfo.Lines.Clear;
  FDOSCommand.CommandLine := Format('"%s\ffprobe.exe" -hide_banner -v quiet -show_streams -print_format json "%s"', [strFFMPEGPath, strVideoFileName]);
  FDOSCommand.Execute;
  statInfo.SimpleText := FDOSCommand.CommandLine;
end;

{ ��ȡ��Ƶ�ļ�����Ƶ������Ƶ������Ļ����Ϣ }
procedure TfrmFFUI.GetVideoSplitInfo(const strVideoFileName: string);
var
  strFFMPEGPath: string;
begin
  if FlngUI = lngChinese then
    lblVideoSplitTip.Caption := Format('%s �ļ�������', [ExtractFileName(strVideoFileName)])
  else
    lblVideoSplitTip.Caption := Format('%s Include��', [ExtractFileName(strVideoFileName)]);

  { �ȴ� FDosCommand ִ�н��� }
  while True do
  begin
    Application.ProcessMessages;
    if not FDOSCommand.IsRunning then
      Break;
  end;

  FStatStyle    := ssSplit;
  FVideoStyle   := vsVideo;
  strFFMPEGPath := ExtractFilePath(ParamStr(0)) + 'video\ffmpeg';
  SetDllDirectory(PChar(strFFMPEGPath));

  { ��ȡ��Ƶ����Ϣ }
  FDOSCommand.CommandLine := Format('"%s\ffprobe" -hide_banner -v quiet -show_streams -select_streams v -print_format csv "%s"', [strFFMPEGPath, strVideoFileName]);
  FDOSCommand.Execute;

  { �ȴ���ȡ��Ƶ������ }
  while True do
  begin
    Application.ProcessMessages;
    if not FDOSCommand.IsRunning then
      Break;
  end;

  { ��ȡ��Ƶ����Ϣ }
  FVideoStyle             := vsAudio;
  FDOSCommand.CommandLine := Format('"%s\ffprobe" -hide_banner -v quiet -show_streams -select_streams a -print_format csv "%s"', [strFFMPEGPath, strVideoFileName]);
  FDOSCommand.Execute;

  { �ȴ���ȡ��Ƶ������ }
  while True do
  begin
    Application.ProcessMessages;
    if not FDOSCommand.IsRunning then
      Break;
  end;

  { ��ȡ��Ļ����Ϣ }
  FVideoStyle             := vsSubtitle;
  FDOSCommand.CommandLine := Format('"%s\ffprobe" -hide_banner -v quiet -show_streams -select_streams s -print_format csv "%s"', [strFFMPEGPath, strVideoFileName]);
  FDOSCommand.Execute;
end;

{ ���ļ� }
procedure TfrmFFUI.mniOpenFileClick(Sender: TObject);
begin
  if not dlgOpenVideoFile.Execute then
    Exit;

  FFileStyle                 := fsFile;
  srchbxSelectVideoFile.Text := dlgOpenVideoFile.FileName;
  pgcAll.ActivePage          := tsInfo;

  { ��ȡ��Ƶ�ļ���ʽ��Ϣ }
  GetVideoFileInfo(dlgOpenVideoFile.FileName);

  { ��ȡ��Ƶ�ļ�����Ƶ������Ƶ������Ļ����Ϣ }
  GetVideoSplitInfo(dlgOpenVideoFile.FileName);

  lstFiles.Items.Add(dlgOpenVideoFile.FileName);
end;

{ ���ļ��� }
procedure TfrmFFUI.mniOpenFolderClick(Sender: TObject);
var
  strFolder: String;
begin
  if not SelectDirectory(TransUI('ѡ��һ��Ŀ¼��Ŀ¼�°�����Ƶ�ļ�'), TransUI('Ŀ¼���ƣ�'), strFolder) then
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
  if not InputQuery(TransUI('������Ƶ��ַ��'), TransUI('��ַ��'), strWebStreamAddr) then
    Exit;

  srchbxSelectVideoFile.Text := strWebStreamAddr;
  FFileStyle                 := fsStream;
  pgcAll.ActivePage          := tsPlay;
  btnVideoPlayPlay.Click;
end;

procedure TfrmFFUI.srchbxSelectVideoFileInvokeSearch(Sender: TObject);
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  pmOpen.Popup(pt.x, pt.y);
end;

procedure TfrmFFUI.tmrPlayVideoTimer(Sender: TObject);
begin
  if rgPlayUI.ItemIndex = 0 then
    FhPlayVideoWnd := FindWindow('SDL_app', 'ffplay')
  else if rgPlayUI.ItemIndex = 1 then
    FhPlayVideoWnd := FindWindow('mpv', 'mpv')
  else if rgPlayUI.ItemIndex = 2 then
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
  case rgPlayUI.ItemIndex of
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
  statInfo.SimpleText       := FDOSCommand.CommandLine;
  tmrPlayVideo.Enabled      := True;
  btnVideoPlayPlay.Enabled  := False;
  btnVideoPlayPause.Enabled := True;
  btnVideoPlayStop.Enabled  := True;
end;

procedure TfrmFFUI.btnVideoPlayPlayClick(Sender: TObject);
begin
  if srchbxSelectVideoFile.Text = '' then
  begin
    MessageBox(Handle, PChar(TransUI('����ѡ���һ����Ƶ�ļ����ٲ���')), PChar(TransUI(c_strMsgTitle)), MB_OK or MB_ICONWARNING);
    srchbxSelectVideoFile.SetFocus;
    Exit;
  end;

  if FhPlayVideoWnd <> 0 then
  begin
    MessageBox(Handle, PChar(TransUI('��Ƶ���ڲ��ţ���ֹͣ���ٴβ���')), PChar(TransUI(c_strMsgTitle)), MB_OK or MB_ICONWARNING);
    Exit;
  end;

  FStatStyle := ssPaly;
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

procedure TfrmFFUI.btnVideoPlayPauseClick(Sender: TObject);
begin
  if FhPlayVideoWnd = 0 then
    Exit;

  if rgPlayUI.ItemIndex <> 2 then
    SendPlayUIKey(FhPlayVideoWnd, 'p')
  else
    SendPlayUIKey_vlc(FhPlayVideoWnd, Char(VK_SPACE));
end;

procedure TfrmFFUI.btnVideoPlayStopClick(Sender: TObject);
begin
  if FhPlayVideoWnd = 0 then
    Exit;

  if rgPlayUI.ItemIndex <> 2 then
    SendPlayUIKey(FhPlayVideoWnd, 'q')
  else
    SendPlayUIKey_vlc(FhPlayVideoWnd, 's');

  btnVideoPlayPlay.Enabled  := True;
  btnVideoPlayPause.Enabled := False;
  btnVideoPlayStop.Enabled  := False;
  FhPlayVideoWnd            := 0;
end;

procedure TfrmFFUI.btnAddFolderClick(Sender: TObject);
var
  strFolder: String;
begin
  if not SelectDirectory(TransUI('ѡ��һ��Ŀ¼��Ŀ¼�°�����Ƶ�ļ�'), TransUI('Ŀ¼���ƣ�'), strFolder) then
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

procedure TfrmFFUI.btnSplitPathClick(Sender: TObject);
var
  strSelectedFolder: String;
begin
  if not SelectDirectory(TransUI('ѡ�񱣴���Ƶת�����Ŀ¼��'), TransUI('ѡ��Ŀ¼��'), strSelectedFolder) then
    Exit;

  srchbxSplitVideoSavePath.Text := strSelectedFolder;
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
    MessageBox(Handle, PChar(TransUI('�����������Ƶ�ļ���ת��')), PChar(TransUI(c_strMsgTitle)), MB_OK or MB_ICONWARNING);
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
      if chkConvOpenSavePath.Checked then
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
      if rgUseGPU.ItemIndex = 0 then
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
    FStatStyle := ssConv;
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
procedure TfrmFFUI.KillProcessOfProcessName(const strProcessName: string);
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
  KillProcessOfProcessName(ExtractFilePath(ParamStr(0)) + 'video\ffmpeg\ffmpeg.exe');

  FStatStyle                := ssBlank;
  btnVideoStartConv.Enabled := True;
  btnVideoStopConv.Enabled  := False;
  FDOSCommand.Stop;
end;

procedure TfrmFFUI.btnVideoSplitClick(Sender: TObject);
var
  strFFMPEGPath     : String;
  strVideoFileName  : String;
  strOutputFileName : String;
  strTempCMDFileName: String;
  I                 : Integer;
  intIndex          : Integer;
  strSavePath       : String;
begin
  if Trim(srchbxSelectVideoFile.Text) = '' then
  begin
    MessageBox(Handle, PChar(TransUI('�����ȴ�һ����Ƶ�ļ����ٽ�����Ƶ����')), PChar(TransUI(c_strMsgTitle)), MB_OK or MB_ICONWARNING);
    srchbxSelectVideoFile.SetFocus;
    Exit;
  end;

  btnVideoSplit.Enabled := False;
  FStatStyle            := ssSplit;
  FVideoStyle           := vsConv;
  strVideoFileName      := srchbxSelectVideoFile.Text;
  strFFMPEGPath         := ExtractFilePath(ParamStr(0)) + 'video\ffmpeg';
  SetDllDirectory(PChar(strFFMPEGPath));

  { ����Ŀ¼ }
  if chkSplitPath.Checked then
    strSavePath := ExtractFilePath(srchbxSelectVideoFile.Text)
  else
    strSavePath := srchbxSplitVideoSavePath.Text;
  if RightStr(strSavePath, 1) <> '\' then
    strSavePath := strSavePath + '\';

  { ���� CMD �ļ� }
  strTempCMDFileName := TPath.GetTempPath + 'split.cmd';
  with TStringList.Create do
  begin
    { �������Ƶ ������ }
    for I := 0 to lstSplitVideo.Count - 1 do
    begin
      intIndex          := StrToInt(lstSplitVideo.Items.Strings[I].Split(['/'])[1]);
      strOutputFileName := strSavePath + ChangeFileExt(ExtractFileName(srchbxSelectVideoFile.Text), '') + Format('_%0.2d', [intIndex]) + '.' + lstSplitVideo.Items.Strings[I].Split(['/'])[2];
      Add(Format('"%s\ffmpeg.exe" -hide_banner -i "%s" -c copy -map 0:%d -y "%s"', [strFFMPEGPath, strVideoFileName, intIndex, strOutputFileName]));
    end;

    { �������Ƶ ������ }
    for I := 0 to lstSplitAudio.Count - 1 do
    begin
      intIndex          := StrToInt(lstSplitAudio.Items.Strings[I].Split(['/'])[1]);
      strOutputFileName := strSavePath + ChangeFileExt(ExtractFileName(srchbxSelectVideoFile.Text), '') + Format('_%0.2d', [intIndex]) + '.' + lstSplitAudio.Items.Strings[I].Split(['/'])[2];
      Add(Format('"%s\ffmpeg.exe" -hide_banner -i "%s" -c copy -map 0:%d -y "%s"', [strFFMPEGPath, strVideoFileName, intIndex, strOutputFileName]));
    end;

    { �������Ļ ������ }
    for I := 0 to lstSplitSubtitle.Count - 1 do
    begin
      intIndex          := StrToInt(lstSplitSubtitle.Items.Strings[I].Split(['/'])[1]);
      strOutputFileName := strSavePath + ChangeFileExt(ExtractFileName(srchbxSelectVideoFile.Text), '') + Format('_%0.2d', [intIndex]) + '.' + lstSplitSubtitle.Items.Strings[I].Split(['/'])[2];
      Add(Format('"%s\ffmpeg.exe" -hide_banner -i "%s" -c copy -map 0:%d -y "%s"', [strFFMPEGPath, strVideoFileName, intIndex, strOutputFileName]));
    end;

    SaveToFile(strTempCMDFileName);
    Free;
  end;

  { ִ�� CMD �ļ���������Ƶ���� }
  FDOSCommand.CommandLine := strTempCMDFileName;
  FDOSCommand.Execute;
  statInfo.SimpleText := FDOSCommand.CommandLine;
end;

end.
