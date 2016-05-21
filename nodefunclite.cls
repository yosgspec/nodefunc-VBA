VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "nodefunclite"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'nodefunc VBA Lite by.YOS G-spec

'�yVBA���Ŏg�p�ł���֐��z
'setCd(CurrentPath As String)
'  �J�����g�f�B���N�g���̐ݒ���s���B
'  CurrentPath:�J�����g�f�B���N�g���̃p�X(�����l:�{�t�@�C���̃p�X)

'setJs(FileName As String)
'  �Ăяo��js�t�@�C���̐ݒ�B
'  FileName:js�t�@�C����(�t���p�X��)(�����l:�{�t�@�C���̃p�X)

'[ReturnArgs] = nodefn(FuncName As String, [Args As Variant]) As Variant
'  Node.js�̊֐��̌Ăяo���B
'  FuncName:�֐���
'  Args:����[�ȗ���, �C�ӌ�]
'  ReturnArg:�Ԃ�l[�ȗ���]

Option Explicit

Private nodeCdPath As Variant   '�J�����g�t�H���_
Private requireJs As Variant    '�Ăяo��js�t�@�C��

'�J�����g�t�H���_�̐ݒ�
Public Sub setCd(cdpath As String)
    nodeCdPath = cdpath
End Sub

'js�t�@�C���̐ݒ�
Public Sub setJs(jsfile As String)
    requireJs = jsfile
End Sub

'nodefunc�{��
'func:�Ăяo���֐���, args():�֐��̈���(���s��)
'�Ԃ�l:�֐��̕Ԃ�l
Public Function nodefn(func As String, ParamArray args() As Variant) As Variant
    '�J�����g�t�H���_�̎擾
    nodeCdPath = IIf(nodeCdPath = Empty, ThisWorkbook.path, nodeCdPath)
    'js�t�@�C���̎擾
    requireJs = IIf(requireJs = Empty, "main.js", requireJs)
    '�ꎞ�t�@�C��(��������)
    Const tempfile As String = "Temp$GIy0qPan"

    '�R�}���h���C�������ݒ�
    Dim WSH As Object
    Set WSH = CreateObject("WScript.Shell")
    WSH.CurrentDirectory = nodeCdPath

    Dim Command As String '���s�R�}���h

    ' C:\> node main.js (args)
    Command = Join(Array( _
        "node """, requireJs, """ ", func, _
        IIf(0 <= UBound(args), _
            " """ & Join(args, """ """) & """", _
            "") _
    ), "")

    '�R�}���h���s
    'cmd /c (Command) > (tempfile) 2>&1
    WSH.Run Join(Array( _
        "%ComSpec% /c ", Command, " > ", tempfile, " 2>&1" _
    ), ""), 0, True

    '�������ʂ̎擾
    Dim return_txt As String    '��������
    return_txt = ""

    With CreateObject("ADODB.Stream")
        .Open
        .Charset = "utf-8"
        .LoadFromFile nodeCdPath & "\" & tempfile
        return_txt = .ReadText
        .Close
    End With

    '���ʂ���Ȃ�I��
    If Len(return_txt) < 2 Then
        Set nodefn = Nothing
        Exit Function
    End If

    '�Ō��vbLf������
    return_txt = Mid(return_txt, 1, Len(return_txt) - 1)

    '�ꎞ�t�@�C���̍폜
    Kill nodeCdPath & "\" & tempfile

    nodefn = return_txt
End Function