Attribute VB_Name = "main"
Option Explicit

Dim nf As New nodefuncVBA

Sub main()
    '������`
    '�J�����g�f�B���N�g��
    nf.setCd ThisWorkbook.Path
    '�Ăяo��js�t�@�C��
    nf.setJs "main.js"

    '�ċA�֐�
    Debug.Print nf.nodefn("fact", 1, 10)

    '�z��
    Dim Arr As Variant
    Arr = nf.nodefn("returnData", Array(0, Array(1, Array(2, Array(3, "�ӂ�")))))
    Debug.Print Arr(1)(1)(1)(1)

    'Date�^
    Debug.Print nf.nodefn("returnData", Now)
End Sub

