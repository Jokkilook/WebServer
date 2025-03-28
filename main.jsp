<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스팀 게임 목록 사이트</title>
</head>
<body>
<script>
	//include 된 gameList.jsp만 새로고침하게 해주는 코드
    function loadPage(page) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "gameList.jsp?page=" + page, true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                document.getElementById("gameListContainer").innerHTML = xhr.responseText;
            }
        };
        xhr.send();
    }
</script>
<!-- users 폴더의 loginSection.jsp를 불러와 로그인, 로그아웃, 회원가입 기능 출력 -->
<!-- wishlist 폴더의 wishlist.jsp를 불러와 찜 목록 추가 제거 기능 출력 -->
<!-- gameList 폴더의 gameList.jsp를 불러와 게임 리스트 기능 출력 -->
<div id="rightSection">
	<%
	request.getRequestDispatcher("user/loginSection.jsp").include(request, response);
	request.getRequestDispatcher("wishlist/wishlist.jsp").include(request, response);
	%>
</div>
<div id="leftSection">
	<%request.getRequestDispatcher("gameList/gameList.jsp").include(request, response); %>
</div>
</body>
</html>