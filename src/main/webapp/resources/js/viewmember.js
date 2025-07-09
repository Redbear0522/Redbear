function checkid(){
	id = document.getElementById("id").value;
	url='/Redbear/views/member/checkid.jsp?id='+id;
	open(url,"checkid","width=400,height=300");
}

function inputCheck(){
	pw = document.getElementById("pw");
	pw2 = document.getElementById("pw2");
	name = document.getElementById("name");
	if(name.value == null || name.value==""){
		alert("이름을 입력하세요");
		return false;
	}
	if(pw.value != pw2.value){
		alert("비밀번호를 확인하시오");
		pw.vlaue="";
		pw2.vlaue="";
		pw.focus();
		return false;
	}
}