VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "nodefuncVBA"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'nodefunc VBA by.YOS G-spec

'�y�\�񕶎���z������Ƃ��Ď��̒P����g�p���Ȃ�����
'$ArraY0$, $ArraY1$... $ArraY[n]$, $ReturnSectioN$, $ReturnArgS$, $AsTypE$

'�yVBA���Ŏg�p�ł���֐��z
'setCd(CurrentPath As String)
'  �J�����g�f�B���N�g���̐ݒ���s���B
'  CurrentPath:�J�����g�f�B���N�g���̃p�X(�����l:�{�t�@�C���̃p�X)

'setJs(FileName As String)
'  �Ăяo��js�t�@�C���̐ݒ�B
'  FileName:js�t�@�C����(�t���p�X��)(�����l:�{�t�@�C���̃p�X)

'[ReturnArgs] = nodefn(FuncName As String, [Args As Variant]) As Variant
'  Node.js�̊֐��̌Ăяo���B
'  Node.js�ōs��ꂽ�W���o�͂̓C�~�f�B�G�C�g�ɏo�͂���B
'  FuncName:�֐���
'  Args:����[�ȗ���, �C�ӌ�]
'  ReturnArgs:�Ԃ�l[�ȗ���]

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
    
    '���������`���̕�����ɕϊ�
    Dim i As Long
    For i = 0 To UBound(args)
        set_type args(i), 0
    Next
    
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
    
    '�ꎞ�t�@�C���̑��݃`�F�b�N
    If Dir(nodeCdPath & "\" & tempfile) = "" Then
        Debug.Print "Error:���ʂ̖��擾"
        Exit Function
    End If

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
    
    '�Ԃ�l�Ƃ��ĕԂ��ꂽ�l�̎擾
    Dim return_array As Variant
    return_array = Split(return_txt, "$ReturnSectioN$")

    'Node.js�̕W���o�͂��C�~�f�B�G�C�g�ɏo��
    If return_array(0) <> "" Then
        Debug.Print "> " & Replace(return_array(0), vbLf, vbLf & "> ")
    End If

    '�Ԃ�l�Ƃ��ĕԂ����l����
    If UBound(return_array) < 1 Then
        Set nodefn = Nothing
        Exit Function
    End If
    
    Dim return_args As Variant
    return_args = return_array(1)
    '�Ԃ�l�̌�����
    If InStr(return_args, "$ReturnArgS$") < 1 Then
        '�L���X�g����return
        nodefn = typecast(return_args, 0)
    '�����ł���Δz��Ƃ��ĕԂ�
    Else
        '�Ԃ�l�𕪊�
        Dim return_arg As Variant
        return_arg = Split(return_args, "$ReturnArgS$")

        For i = 0 To UBound(return_arg)
            return_arg(i) = typecast(return_arg(i), 0)
        Next
        nodefn = return_arg
    End If
End Function

'nodefunc�ł͎��s�s��
Public Function nodefunc(func As String, ParamArray args() As Variant) As Variant
    MsgBox "����������: nodefn"
    Set nodefunc = Nothing
End Function

'����`���̕�����ɕϊ�
'args:����, arrNo:�z��̊K�w��
Private Sub set_type(ByRef arg As Variant, arrNo As Long)
    '�z��ł���Γ��ꕶ���Ō���
    If IsArray(arg) Then
        Dim i As Long
        For i = 0 To UBound(arg)
            '�z��̒��g�����l��(�ċA)
            set_type arg(i), arrNo + 1
        Next
        arg = Join(arg, "$ArraY" & arrNo & "$")
    Else
        '������Ɍ^�����������ĕԋp
        arg = Join(Array(arg, TypeName(arg)), "$AsTypE$")
    End If
End Sub

'�Ԃ�l�̃L���X�g
'args:����, arrNo:�z��̊K�w��
Private Function typecast(arg As Variant, arrNo As Long) As Variant
    If InStr(arg, "$ArraY" & arrNo & "$") Then
        '�z��ł���Ε���
        Dim argArr As Variant
        argArr = Split(arg, "$ArraY" & arrNo & "$")

        'Split�������g��Variant�^�łȂ����ߐV���ɒ�`
        ReDim argArrV(UBound(argArr)) As Variant
        
        '�z��̒��g���L���X�g
        Dim i As Long
        For i = 0 To UBound(argArr)
            '�ċA
            argArrV(i) = typecast(argArr(i), arrNo + 1)
        Next
        typecast = argArrV
    Else
        '�e��L���X�g
        Dim args As Variant
        args = Split(arg, "$AsTypE$")
        arg = args(0)           '�l

        Dim vbatype As String   '�^���
        vbatype = args(1)

        Select Case vbatype
            Case "Double":
                typecast = CDbl(arg)
            Case "String":
                typecast = CStr(arg)
            Case "Boolean":
                typecast = CBool(arg)
            Case "Date":
                typecast = CDate(arg)
            Case "Nothing":
                typecast = Nothing
            Case "Empty":
                typecast = Empty
            Case Else
                typecast = CStr(arg & " As ?")
        End Select
    End If
    
End Function
