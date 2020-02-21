unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.TlHelp32, Winapi.ShellAPI, System.SysUtils, System.StrUtils, System.Classes, System.IniFiles, System.IOUtils, System.Types, System.Math, System.ImageList,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.ComCtrls, Vcl.Menus, Vcl.Clipbrd, Vcl.FileCtrl, Vcl.ImgList,
  {�������ؼ�}
  SynEdit, SynHighlighterJSON, DosCommand, uProcessAPI;

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
    chkSplitSamePath: TCheckBox;
    lblSplitSamePath: TLabel;
    srchbxVideoConvSavePath: TSearchBox;
    srchbxSplitVideoSavePath: TSearchBox;
    lnklblHelpAccelGPU: TLinkLabel;
    rgLanguageUI: TRadioGroup;
    ilpgc: TImageList;
    tsCut: TTabSheet;
    chkConvOpenSavePath: TCheckBox;
    chkSplitOpenSavePath: TCheckBox;
    lblMergeVideo: TLabel;
    lstMergeVideo: TListBox;
    lblMergeAudio: TLabel;
    lblMergeSubtitle: TLabel;
    lstMergeAudio: TListBox;
    lstMergeSubtitle: TListBox;
    lblMergeTip: TLabel;
    btnMergeVideoAdd: TButton;
    btnMergeVideoDel: TButton;
    btnMergeAudioAdd: TButton;
    btnMergeAudioDel: TButton;
    btnMergeSubtitleAdd: TButton;
    btnMergeSubtitleDel: TButton;
    btnMerge: TButton;
    grpMergePath: TGroupBox;
    lblMergeSamePath: TLabel;
    chkMergeSamePath: TCheckBox;
    srchbxMergeSavePath: TSearchBox;
    chkMergeOpenSavePath: TCheckBox;
    lblMergeFormat: TLabel;
    cbbMergeFormat: TComboBox;
    chkAddWaterMark: TCheckBox;
    lblWatermark: TLabel;
    srchbxWatermark: TSearchBox;
    btnConnectMulVideo: TButton;
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
    procedure chkSplitSamePathClick(Sender: TObject);
    procedure lnklblHelpAccelGPULinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
    procedure rgLanguageUIClick(Sender: TObject);
    procedure btnVideoSplitClick(Sender: TObject);
    procedure chkConvOpenSavePathClick(Sender: TObject);
    procedure chkMergeSamePathClick(Sender: TObject);
    procedure chkMergeOpenSavePathClick(Sender: TObject);
    procedure btnMergeClick(Sender: TObject);
    procedure srchbxSplitVideoSavePathInvokeSearch(Sender: TObject);
    procedure srchbxVideoConvSavePathInvokeSearch(Sender: TObject);
    procedure btnMergeVideoAddClick(Sender: TObject);
    procedure btnMergeVideoDelClick(Sender: TObject);
    procedure btnMergeAudioAddClick(Sender: TObject);
    procedure btnMergeAudioDelClick(Sender: TObject);
    procedure btnMergeSubtitleAddClick(Sender: TObject);
    procedure btnMergeSubtitleDelClick(Sender: TObject);
    procedure cbbMergeFormatChange(Sender: TObject);
    procedure btnConnectMulVideoClick(Sender: TObject);
    procedure srchbxWatermarkInvokeSearch(Sender: TObject);
  private
    FlngUI             : TLangUI;
    FDOSCommand        : TDosCommand;
    FSynEdit_VideoInfo : TSynEdit;
    FSynEdit_VideoConv : TSynEdit;
    FSynEdit_VideoSplit: TSynEdit;
    FSynEdit_VideoMerge: TSynEdit;
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
{$INCLUDE lng.inc}

const
  c_strAudioFormat    = '*.3gp;*.aac;*.ac3;*.dts;*.mp2;*.mp3;*.m3p;*.wav;*.wma;*.ogg';
  c_strVideoFormat    = '*.AVI;*.FLV;*.M2V;*.MKV;*.MOV;*.MPG;*.MP4;*.H264;*.H265;*.RMVB;*.TS;*.VOB;*.WMV;*.YUV';
  c_strSubtitleFormat = '*.txt;*.ass;*.srt';

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
      rgUseGPU.ItemIndex := ReadInteger('Main', 'UseGPU', 0);

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
      chkSplitSamePath.Checked := ReadBool('Split', 'SamePath', True);
      if not chkSplitSamePath.Checked then
        srchbxSplitVideoSavePath.Text := ReadString('Split', 'SavePath', 'D:\');
      chkSplitOpenSavePath.Checked    := ReadBool('Split', 'OpenSavePath', True);

      { ��Ƶ�ϲ�·�� }
      chkMergeSamePath.Checked := ReadBool('Merge', 'SamePath', True);
      if not chkMergeSamePath.Checked then
        srchbxMergeSavePath.Text   := ReadString('Merge', 'SavePath', 'D:\');
      chkMergeOpenSavePath.Checked := ReadBool('Merge', 'OpenSavePath', True);

      { �������� }
      FlngUI                 := TLangUI(ReadInteger('UI', 'Language', 0) mod 2);
      rgLanguageUI.ItemIndex := Integer(TLangUI(ReadInteger('UI', 'Language', 0) mod 2));
      ChangeLanguageUI;

      Free;
    end;
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
    WriteBool('Split', 'SamePath', chkSplitSamePath.Checked);
    if not chkSplitSamePath.Checked then
      WriteString('Split', 'SavePath', srchbxSplitVideoSavePath.Text)
    else
      DeleteKey('Split', 'SavePath');
    WriteBool('Split', 'OpenSavePath', chkSplitOpenSavePath.Checked);

    { �ϲ�����·�� }
    WriteBool('Merge', 'SamePath', chkMergeSamePath.Checked);
    if not chkMergeSamePath.Checked then
      WriteString('Merge', 'SavePath', srchbxMergeSavePath.Text)
    else
      DeleteKey('Merge', 'SavePath');
    WriteBool('Merge', 'OpenSavePath', chkMergeOpenSavePath.Checked);

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

  if not chkSplitSamePath.Checked then
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

procedure TfrmFFUI.chkSplitSamePathClick(Sender: TObject);
begin
  lblSplitSamePath.Visible         := not chkSplitSamePath.Checked;
  srchbxSplitVideoSavePath.Visible := not chkSplitSamePath.Checked;
end;

procedure TfrmFFUI.chkConvSavePathClick(Sender: TObject);
begin
  lblSaveVideoPath.Visible        := not chkConvSavePath.Checked;
  srchbxVideoConvSavePath.Visible := not chkConvSavePath.Checked;
end;

procedure TfrmFFUI.chkMergeOpenSavePathClick(Sender: TObject);
begin
  SaveConfig;
end;

procedure TfrmFFUI.chkMergeSamePathClick(Sender: TObject);
begin
  lblMergeSamePath.Visible    := not chkMergeSamePath.Checked;
  srchbxMergeSavePath.Visible := not chkMergeSamePath.Checked;
end;

procedure TfrmFFUI.lnklblHelpAccelGPULinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
begin
  ShellExecute(0, nil, PChar(Link), nil, nil, 1);
end;

procedure TfrmFFUI.cbbMergeFormatChange(Sender: TObject);
begin
  //
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

  FSynEdit_VideoMerge                := TSynEdit.Create(tsMerge);
  FSynEdit_VideoMerge.Parent         := tsMerge;
  FSynEdit_VideoMerge.Left           := 70;
  FSynEdit_VideoMerge.Top            := 324;
  FSynEdit_VideoMerge.Width          := 761;
  FSynEdit_VideoMerge.Height         := 233;
  FSynEdit_VideoMerge.Anchors        := [akLeft, akTop, akRight, akBottom];
  FSynEdit_VideoMerge.Gutter.Visible := False;
  FSynEdit_VideoMerge.Font.Name      := '����';
  FSynEdit_VideoMerge.Font.Size      := 12;
  FSynEdit_VideoMerge.RightEdge      := pnlVideoConv.Width;
  FSynEdit_VideoMerge.ScrollBars     := ssVertical;
  FSynEdit_VideoMerge.Highlighter    := FJSONHL;
  FSynEdit_VideoMerge.ReadOnly       := True;

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

  dlgOpenVideoFile.Filter := Ifthen(FlngUI = lngChinese, '��Ƶ�ļ�(', 'Video file(') + c_strVideoFormat + ')|' + c_strVideoFormat;
end;

procedure TfrmFFUI.FormDestroy(Sender: TObject);
begin
  { ����ϵͳ���� }
  SaveConfig;

  { ���ٴ����ĵ������ؼ� }
  FDOSCommand.Free;
  FJSONHL.Free;
  FSynEdit_VideoMerge.Free;
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
    ShellExecute(0, 'open', 'explorer.exe', PChar(strSavePath), nil, SW_SHOWNORMAL);
end;

{ ����Ƶ�����ı���Ŀ¼ }
procedure TfrmFFUI.OpenVideoSplitPath;
var
  strSavePath: String;
begin
  if chkSplitSamePath.Checked then
    strSavePath := ExtractFilePath(srchbxSelectVideoFile.Text)
  else
    strSavePath := srchbxSplitVideoSavePath.Text;

  if chkSplitOpenSavePath.Checked then
    ShellExecute(0, 'open', 'explorer.exe', PChar(strSavePath), nil, SW_SHOWNORMAL);
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
            lstSplitVideo.Items.Add(strSplit[1] + '/' + strSplit[2]);
          end;
          Free;
        end;
      finally
        FSynEdit_VideoSplit.Lines.Clear;
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
            lstSplitAudio.Items.Add(strSplit[1] + '/' + strSplit[2]);
          end;
          Free;
        end;
      finally
        FSynEdit_VideoSplit.Lines.Clear;
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
            lstSplitSubtitle.Items.Add(strSplit[1] + '/' + strSplit[2]);
          end;
          Free;
        end;
      finally
        FSynEdit_VideoSplit.Lines.Clear;
        DeleteFile(strTempSubtitleCSVFileName);
      end;
      FStatStyle := ssBlank;
    end;

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
  dlgOpenVideoFile.Filter := Ifthen(FlngUI = lngChinese, '��Ƶ�ļ�(', 'Video file(') + c_strVideoFormat + ')|' + c_strVideoFormat;
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

procedure TfrmFFUI.srchbxSplitVideoSavePathInvokeSearch(Sender: TObject);
var
  strSelectedFolder: String;
begin
  if not SelectDirectory(TransUI('ѡ�񱣴���Ƶת�����Ŀ¼��'), TransUI('ѡ��Ŀ¼��'), strSelectedFolder) then
    Exit;

  srchbxSplitVideoSavePath.Text := strSelectedFolder;
end;

procedure TfrmFFUI.srchbxVideoConvSavePathInvokeSearch(Sender: TObject);
var
  strSelectedFolder: String;
begin
  if not SelectDirectory(TransUI('ѡ�񱣴���Ƶת�����Ŀ¼��'), TransUI('ѡ��Ŀ¼��'), strSelectedFolder) then
    Exit;

  srchbxVideoConvSavePath.Text := strSelectedFolder;
end;

{ ------------------------------------------------------------------------- ��Ƶ���� ------------------------------------------------------------------------------- }

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

{ ------------------------------------------------------------------------- ��Ƶת�� ------------------------------------------------------------------------------- }

procedure TfrmFFUI.btnAddVideoFileClick(Sender: TObject);
begin
  if not dlgOpenVideoFile.Execute then
    Exit;

  lstFiles.Items.Add(dlgOpenVideoFile.FileName);
end;

procedure TfrmFFUI.btnAddFolderClick(Sender: TObject);
var
  strFolder: String;
begin
  if not SelectDirectory(TransUI('ѡ��һ��Ŀ¼��Ŀ¼�°�����Ƶ�ļ�'), TransUI('Ŀ¼���ƣ�'), strFolder) then
    Exit;

  FindVideoFile(strFolder);
end;

procedure TfrmFFUI.btnDelVideoFileClick(Sender: TObject);
begin
  if lstFiles.ItemIndex <> -1 then
    lstFiles.DeleteSelected;
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
  c_strFFMPEGConv_CPU_H265 = '"%s\ffmpeg" -hide_banner -i "%s" -c:v libx265    %s %s -y "%s"';
  c_strFFMPEGConv_CPU_FFLV = '"%s\ffmpeg" -hide_banner -i "%s" -c:v flv        %s %s -y "%s"';
  c_strFFMPEGConv_GPU_H264 = '"%s\ffmpeg" -hide_banner -i "%s" -c:v h264_nvenc %s %s -y "%s"';
  c_strFFMPEGConv_GPU_H265 = '"%s\ffmpeg" -hide_banner -i "%s" -c:v nvenc_hevc %s %s -y "%s"';
var
  strFFMPEGPath      : String;
  strFFMPGCommandLine: String;
  strInputFile       : string;
  strOutPutFile      : string;
  I                  : Integer;
  strTempCMDFileName : String;
  strExtFileName     : String;
  strVideoSize       : String;
  strVideoInfo       : String;
  lstCMD             : TStringList;
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
      if chkConvSavePath.Checked then
      begin
        strOutPutFile := ChangeFileExt(strInputFile, strExtFileName);
        if SameText(strOutPutFile, strInputFile) then
          strOutPutFile := strInputFile + strExtFileName;
      end
      else
      begin
        if RightStr(srchbxVideoConvSavePath.Text, 1) <> '\' then
          strOutPutFile := srchbxVideoConvSavePath.Text + '\' + ChangeFileExt(ExtractFileName(strInputFile), strExtFileName)
        else
          strOutPutFile := srchbxVideoConvSavePath.Text + ChangeFileExt(ExtractFileName(strInputFile), strExtFileName);
        if not System.SysUtils.DirectoryExists(ExtractFileDir(strOutPutFile)) then
          System.SysUtils.ForceDirectories(ExtractFileDir(strOutPutFile));
      end;

      case cbbConv.ItemIndex of
        0:
          if rgUseGPU.ItemIndex = 1 then
            strFFMPGCommandLine := Format(c_strFFMPEGConv_CPU_H264, [strFFMPEGPath, strInputFile, strVideoSize, strVideoInfo, strOutPutFile])
          else
            strFFMPGCommandLine := Format(c_strFFMPEGConv_GPU_H264, [strFFMPEGPath, strInputFile, strVideoSize, strVideoInfo, strOutPutFile]);
        1:
          if rgUseGPU.ItemIndex = 1 then
            strFFMPGCommandLine := Format(c_strFFMPEGConv_CPU_H265, [strFFMPEGPath, strInputFile, strVideoSize, strVideoInfo, strOutPutFile])
          else
            strFFMPGCommandLine := Format(c_strFFMPEGConv_GPU_H265, [strFFMPEGPath, strInputFile, strVideoSize, strVideoInfo, strOutPutFile]);
        2:
          strFFMPGCommandLine := Format(c_strFFMPEGConv_CPU_FFLV, [strFFMPEGPath, strInputFile, strVideoSize, strVideoInfo, strOutPutFile]);
      end;

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

{ ------------------------------------------------------------------------- ��Ƶ���� ------------------------------------------------------------------------------- }

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
  if chkSplitSamePath.Checked then
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
      intIndex          := StrToInt(lstSplitVideo.Items.Strings[I].Split(['/'])[0]);
      strOutputFileName := strSavePath + ChangeFileExt(ExtractFileName(srchbxSelectVideoFile.Text), '') + Format('_%0.2d', [intIndex]) + '.' + 'mp4'; // lstSplitVideo.Items.Strings[I].Split(['/'])[1];
      Add(Format('"%s\ffmpeg.exe" -hide_banner -i "%s" -c copy -map 0:%d -y "%s"', [strFFMPEGPath, strVideoFileName, intIndex, strOutputFileName]));
    end;

    { �������Ƶ ������ }
    for I := 0 to lstSplitAudio.Count - 1 do
    begin
      intIndex          := StrToInt(lstSplitAudio.Items.Strings[I].Split(['/'])[0]);
      strOutputFileName := strSavePath + ChangeFileExt(ExtractFileName(srchbxSelectVideoFile.Text), '') + Format('_%0.2d', [intIndex]) + '.' + lstSplitAudio.Items.Strings[I].Split(['/'])[1];
      Add(Format('"%s\ffmpeg.exe" -hide_banner -i "%s" -c copy -map 0:%d -y "%s"', [strFFMPEGPath, strVideoFileName, intIndex, strOutputFileName]));
    end;

    { �������Ļ ������ }
    for I := 0 to lstSplitSubtitle.Count - 1 do
    begin
      intIndex          := StrToInt(lstSplitSubtitle.Items.Strings[I].Split(['/'])[0]);
      strOutputFileName := strSavePath + ChangeFileExt(ExtractFileName(srchbxSelectVideoFile.Text), '') + Format('_%0.2d', [intIndex]) + '.' + lstSplitSubtitle.Items.Strings[I].Split(['/'])[1];
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

{ ------------------------------------------------------------------------- ��Ƶ�ϲ� ------------------------------------------------------------------------------- }
procedure TfrmFFUI.btnMergeAudioAddClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
  begin
    Filter := Ifthen(FlngUI = lngChinese, '��Ƶ��(', 'Audio file(') + c_strAudioFormat + ')|' + c_strAudioFormat;
    if Execute() then
    begin
      lstMergeAudio.Items.Add(FileName);
    end;
    Free;
  end;
end;

procedure TfrmFFUI.btnMergeAudioDelClick(Sender: TObject);
begin
  lstMergeAudio.DeleteSelected;
end;

procedure TfrmFFUI.btnMergeVideoAddClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
  begin
    Filter := Ifthen(FlngUI = lngChinese, '��Ƶ��(', 'Video file(') + c_strVideoFormat + ')|' + c_strVideoFormat;
    if Execute() then
    begin
      lstMergeVideo.Items.Add(FileName);
    end;
    Free;
  end;
end;

procedure TfrmFFUI.btnMergeVideoDelClick(Sender: TObject);
begin
  lstMergeVideo.DeleteSelected;
end;

procedure TfrmFFUI.btnMergeSubtitleAddClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
  begin
    Filter := Ifthen(FlngUI = lngChinese, '��Ļ��(', 'Subtitle file(') + c_strSubtitleFormat + ')|' + c_strSubtitleFormat;
    if Execute() then
    begin
      lstMergeSubtitle.Items.Add(FileName);
    end;
    Free;
  end;
end;

procedure TfrmFFUI.btnMergeSubtitleDelClick(Sender: TObject);
begin
  lstMergeSubtitle.DeleteSelected;
end;

procedure TfrmFFUI.srchbxWatermarkInvokeSearch(Sender: TObject);
begin
  //
end;

procedure TfrmFFUI.btnMergeClick(Sender: TObject);
begin
  // ��Ƶ���ˮӡ
  // ffmpeg -i input.mp4 -i logo.jpg -filter_complex [0:v][1:v]overlay=main_w-overlay_w-10:main_h-overlay_h-10[out] -map [out] -map 0:a -codec:a copy output.mp4
  // main_w-overlay_w-10 ��Ƶ�Ŀ��-ˮӡ�Ŀ��-ˮӡ�߾ࣻ

  // ����Ƶ�ϳ�
  // ffmpeg -y �Ci input.mp4 �Ci input.mp3 �Cvcodec copy �Cacodec copy output.mp4
  // -y ��������ļ�

  // ��ȡ��Ƶ�ֲ�                                                ffmpeg -i in.mp4 -filter:v "crop=out_w:out_h:x:y" out.mp4
  // ��ȡ������Ƶ����[80,60]��λ�ÿ�ʼ����ȡ��200����100����Ƶ   ffmpeg -i in.mp4 -filter:v "crop=80:60:200:100" -c:a copy out.mp4
  // ��ȡ���½ǵ��ķ�֮һ                                        ffmpeg -i in.mp4 -filter:v "crop=in_w/2:in_h/2:in_w/2:in_h/2" -c:a copy out.mp4
  // ��ȥ�ײ�40���ظ߶�                                          ffmpeg -i in.mp4 -filter:v "crop=in_w:in_h-40" -c:a copy out.mp4

  // ffmpeg -i video.mp4 -i audio.wav -c:v copy -c:a aac -strict experimental                       output.mp4
  // ffmpeg -i video.mp4 -i audio.wav -c:v copy -c:a aac -strict experimental -map 0:v:0 -map 1:a:0 output.mp4    <�滻��Ƶ�е���Ƶ>

end;

procedure TfrmFFUI.btnConnectMulVideoClick(Sender: TObject);
begin
  // ffmpeg -f concat -safe 0 -i filelist.txt -c copy output.mp4

  // ffmpeg -i 1.mp4 -vcodec copy -acodec copy -vbsf h264_mp4toannexb 1.ts
  // ffmpeg -i 2.mp4 -vcodec copy -acodec copy -vbsf h264_mp4toannexb 2.ts
  // ffmpeg -i "concat:1.ts|2.ts" -acodec copy -vcodec copy -absf aac_adtstoasc output.mp4


  // ffmpeg -i input1.flv -c copy -bsf:v h264_mp4toannexb -f mpegts input1.ts
  // ffmpeg -i input2.flv -c copy -bsf:v h264_mp4toannexb -f mpegts input2.ts
  // ffmpeg -i input3.flv -c copy -bsf:v h264_mp4toannexb -f mpegts input3.ts
  // ffmpeg -i "concat:input1.ts|input2.ts|input3.ts" -c copy -bsf:a aac_adtstoasc -movflags +faststart output.mp4

  // ffmpeg -i input1.mp4 -i input2.webm -i input3.avi -filter_complex '[0:0] [0:1] [1:0] [1:1] [2:0] [2:1] concat=n=3:v=1:a=1 [v] [a]' -map '[v]' -map '[a]' <������ѡ��> output.mkv
end;

(*
  ������Ļ��
  ffmpeg -i video.avi -i sub.ass -map 0:0 -map 0:1 -map 1 -c:a copy -c:v copy -c:s copy video.mkv

  ��ȡ��Ļ��
  1��ԭʼ�ı����
  ffmpeg -i output.mkv -an -vn -bsf:s mov2textsub -scodec copy -f rawvideo sub.txt
  ffmpeg -i output.mkv -an -vn -c:s copy -f rawvideo -map 0:s sub2.txt
  2��ass��ʽ���
  ffmpeg -i output.mkv -an -vn -scodec copy sub3.ass


  ��ν��Ӳ��Ļ�ǰ���Ļ�ӵ���Ƶ���У����ǵ�������Ļ�����������£�
  ffmpeg -i demo.mp4 -vf ass=subtitle.ass output.mp4
  ��
  ffmpeg -i demo.mp4 -vf subtitles=sample.srt out.mp4


  ���ˮӡ
  �ڹ̶���λ�����ˮӡ
  ffmpeg -i test.mp4 -i test.png -filter_complex ��overlay=10:10�� watermark.mp4
  ��test.mp4���Ͻ�10,10��λ�����ˮӡͼƬtest.png��ͬʱ�ڸ�Ŀ¼����һ��watermark.mp4����Ƶ

  ����Ӧ���ˮӡ
  ffmpeg -i test.mp4 -i test.png -filter_complex ��overlay=x=main_h-10:main_w-10�� watermark.mp4
  ��test.mp4�������½�10��10��λ�����ˮӡ��main_h������Ƶ�ĸ߶ȣ�main_w������Ƶ�Ŀ��

  ͬʱΪ��Ƶ���ˮӡ����Ļ
  ffmpeg -i test.mp4 -i test.png -filter_complex ��overlay=x=main_w-273:y=main_h-113,subtitles=test.srt:force_style=��Fontsize=11���� output.mp4
  ��test.mp4�����Ļ��ˮӡ��ͬʱ��Ļ����Ĵ�СΪ11px���������Ҫ������Ļ��λ�ã����壬��Ӱ�ȿ���ֱ����Fontsize=11����ֱ��ƴ�Ӽ��ɡ�Shadow=0,MarginV=20������ӰΪ1�������±߾�Ϊ20px

*)
end.
