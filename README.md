# nodefunc VBA
  VBA����Node.js�̊֐����Ăяo�����߂̃��W���[���R�ł��B  
  
* �����悤  
�@VBA����Node.js�̊֐����Ă�ŕԂ�l�𓾂邱�Ƃ��o���܂��B  
�@�����@�\�Ƃ��Ă͂��ꂭ�炢�B  
�@���Ƃ͂��������x�����瑽�p���ցB  
�@�ׂ����g�p���@�̓\�[�X���R�����g�Q�ƁB  
    
##�t�@�C���\��

* nodefuncVBA.xlsm  
����e�X�g�ɕK�v�Ȃ��̂��܂񂾃e�X�g�p�t�@�C���B  
* main.bas  
VBA�̌Ăяo�����̃e�X�g�p�t�@�C���B  
�W�����W���[���Ƃ��ēo�^���Ďg�p�B  
* main.js  
VBA����Ăяo�����e�X�g�pNode.js�t�@�C���B  
* nodefuncVBA.cls  
Node.js��VBA����Ăяo�����߂ɕK�v��VBA�p�N���X�t�@�C���B  
* nodefuncVBA.js  
Node.js��VBA����Ăяo�����߂ɕK�v��Node.js�p���W���[���B  
* nodefuncVBAlite.cls  
* nodefuncVBAlite.js  
�ォ��^�ϊ��������ċ@�\���ȗ����������́B  
�W���o�͂����̂܂ܕԂ�l�Ƃ��ē����܂��B  
  
#�Ă���
* VBA�� main.bas  

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
  
* Node.js�� main.js  

        var nf=require("./nodefuncVBA");
        //�Ăяo���֐�
        eval(nf.func());
        
        //�K��
        function fact(x,i){
        	if(0<i){
        		nf.return_VBA(fact(x*i,i-1));
        	}
        	else{
        		nf.return_VBA(x);
        	}
        }
        
        //���̂܂ܕԂ��֐�
        function returnData(x){
        	console.log(x);
        	nf.return_VBA(x);
        }
  
* ���s����  

         3628800 
        > [ 0, [ 1, [ 2, [Object] ] ] ]
        > 
        �ӂ�
        > Sat May 21 2016 23:54:42 GMT+0900 (���� (�W����))
        > 
        2016/05/21 23:54:42 

#���C�Z���X
�p�u���b�N�h���C���ł��B  
���ρE�Ĕz�z�Ȃ�ł������R�ɁB
