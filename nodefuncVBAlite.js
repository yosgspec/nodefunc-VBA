/* nodefunc VBA Lite by.YOS G-spec

�yNode.js���Ŏg�p�ł���֐��z
FuncStr=func():string
[eval(func()):any]
  VBA����^����ꂽ�������֐��̌`�ɕϊ�����B
  �ʏ��eval�Ƒg�ݍ��킹�Ċ֐����Ăяo������B
  FuncStr:�֐��̕�����

return_VBA(ReturnArg)
  VBA�ɒl��Ԃ��B
  ReturnArg:�Ԃ�l
*/

module.exports=new function(){
	//�֐��̒�`
	this.func=function(){
		//�R�}���h���C�������̏��� 0:node, 1:�t�@�C����
		process.argv.shift();
		process.argv.shift();
		//�֐����̎擾+�R�}���h���C���������珜��
		var runfunc=process.argv.shift()+"(";
		var args="";

		//�֐��̈������R���}��؂�
		if(0<process.argv.length){
			for(var i=0;i<process.argv.length;i++){
				args+=",'"+process.argv[i]+"'";
			}
			//���̃R���}������
			args=args.substr(1);
		}
		runfunc+=args+")";
		//�֐���"������"��Ԋ�(eval�K�{)
		return runfunc;
	};

	//VBA�ւ̕Ԃ�l
	this.return_VBA=function(arg){
		console.log(arg);
		process.exit();
	};
};
