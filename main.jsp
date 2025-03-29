<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스팀 게임 목록 사이트</title>
</head>
<script>
	function getSearchKeyword() {
	    return document.getElementById("searchInput").value;
	}
	
	function searchGames() {
	    var searchKeyword = getSearchKeyword();
	    loadList(searchKeyword, "game_id", "ASC"); 
	}
	
	function loadList(search, sort, order) {
	    var xhr = new XMLHttpRequest();
	    xhr.open("GET", "gameList/gameList.jsp?search=" + encodeURIComponent(search) + "&sort=" + sort + "&order=" + order, true);
	    xhr.onreadystatechange = function () {
	        if (xhr.readyState == 4 && xhr.status == 200) {
	            document.getElementById("leftSection").innerHTML = xhr.responseText;
	        }
	    };
	    xhr.send();
	}
</script>
<body>
<!-- users 폴더의 loginSection.jsp를 불러와 로그인, 로그아웃, 회원가입 기능 출력 -->
<!-- wishlist 폴더의 wishlist.jsp를 불러와 찜 목록 추가 제거 기능 출력 -->
<!-- gameList 폴더의 gameList.jsp를 불러와 게임 리스트 기능 출력 -->
<div id="rightSection">
	<%
	request.getRequestDispatcher("user/loginSection.jsp").include(request, response);
	request.getRequestDispatcher("wishlist/wishlist.jsp").include(request, response);
	%>
</div>
<form name="formm" method="post">				
	검색 <input type="text" id="searchInput" name="search" size="60" onkeydown="if(event.key === 'Enter') { event.preventDefault(); searchGames(); }"> 
	<button type="button" onclick="searchGames()">검색</button>
</form>  
정렬
<button onclick="loadList(getSearchKeyword(),'game_name', 'ASC')">이름</button>
<button onclick="loadList(getSearchKeyword(),'release_date', 'ASC')">출시일</button>
<button onclick="loadList(getSearchKeyword(),'good', 'DESC')">평가</button>
<button onclick="loadList(getSearchKeyword(),'price', 'DESC')">가격</button>
<div id="leftSection">
	<script>
		window.onload=function() { loadList('',"game_id","ASC") }
	</script>
	<%//request.getRequestDispatcher("gameList/gameList.jsp").include(request, response); %>
</div>
</body>
</html>