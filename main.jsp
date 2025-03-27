<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스팀 게임 목록 사이트</title>
</head>
<body>
<!-- users 폴더의 loginSection.jsp를 불러와 로그인, 로그아웃, 회원가입 기능 출력 -->
<%
	request.getRequestDispatcher("user/loginSection.jsp").include(request, response);
	request.getRequestDispatcher("wishlist/wishlist.jsp").include(request, response);
	request.getRequestDispatcher("gameList/gameList.jsp").include(request, response);
%>
</body>
</html>