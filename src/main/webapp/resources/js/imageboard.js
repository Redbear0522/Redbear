count = 2;
function addFile(){
	addfile = document.getElementById("addfile");
	
	addfile.innerHTML=
		addfile.innerHTML+
			"<input type='file' name='img"+(count++)+"'><br>";
}

 function writeSave(){
 	// [수정] document.writeform -> document.write
 	if(document.write.writer.value==""){
 	  alert("작성자를 입력하십시오.");
 	  document.write.writer.focus();
 	  return false;
 	}

     // [수정] document.writeform.subject -> document.write.title
 	if(document.write.title.value==""){
 	  alert("제목을 입력하십시오.");
 	  document.write.title.focus();
 	  return false;
 	}
 	
 	if(document.write.content.value==""){
 	  alert("내용을 입력하십시오.");
 	  document.write.content.focus();
 	  return false;
 	}
     
     // [수정] document.writeform.passwd -> document.write.pw
 	if(document.write.pw.value==""){
 	  alert("비밀번호를 입력하십시오.");
 	  document.write.pw.focus();
 	  return false;
 	}
     // 모든 검사를 통과하면 true를 반환하지 않고, form의 submit을 그대로 진행시킴
  }
  function addFile() {
      // 추가될 파일들을 담을 부모 div 요소를 가져옵니다.
      const addfileContainer = document.getElementById("addfile");

      // 새로운 파일 입력을 감싸는 div를 만듭니다.
      const newFileDiv = document.createElement("div");
      newFileDiv.style.marginTop = "10px"; // 위쪽 여백을 줘서 간격을 만듭니다.

      // 새로운 파일 입력(input) 요소를 만듭니다.
      const newFileInput = document.createElement("input");
      newFileInput.type = "file";
      // 각 파일의 name을 다르게 지정합니다 (예: uploadFile2, uploadFile3, ...)
      newFileInput.name = "uploadFile" + (++fileCount); 

      // 새로 만든 div에 파일 입력 요소를 자식으로 추가합니다.
      newFileDiv.appendChild(newFileInput);

      // 최종적으로 #addfile 컨테이너에 새로 만든 div를 추가합니다.
      // 이렇게 하면 <br> 태그 없이도 각 파일이 한 줄씩 깔끔하게 추가됩니다.
      addfileContainer.appendChild(newFileDiv);
  }

