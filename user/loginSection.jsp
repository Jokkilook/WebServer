<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../SQLconstants.jsp" %>
<script>
    function showRegisterForm() {
        document.getElementById("login").hidden = true;
        document.getElementById("register").hidden = false;
    }
    function showLoginForm() {
        document.getElementById("register").hidden = true;
        document.getElementById("login").hidden = false;
    }
</script>
<body>
<div id="loginSection">
<%	
	//세션에 저장된 유저 정보가 없으면 로그인 창 표시
	if(session.getAttribute("user")==null){
%>
		<!-- 로그인 섹션 -->
		<form id="login" method="post" action="./user/login.jsp">
			아이디 <input type="text" name="id" required><br>
			비밀번호 <input type="password" name="pw" required><br>
			<input type="submit" name="submit" value="로그인">
			<button onclick="showRegisterForm()">회원가입</button>
		</form>
		
		<!-- 회원가입 섹션 -->
		<form id="register" method="post" action="./user/register.jsp" hidden="true">
			닉네임 <input type="text" name="name" required><br>
			아이디 <input type="text" name="id" required><br>
			비밀번호 <input type="password" name="pw" required><br>
			<button onclick="showLoginForm()">취소</button>
			<input type="submit" value="가입">
		</form>
<%
	} else {
		//세션에 저장된 유저 정보가 있으면 유저 환영 메시지 표시
		String user = (String)session.getAttribute("user");
%>
		<%=user %>님 환영합니다!<br>
		<button onclick="location.href='./user/logout.jsp'">로그아웃</button>
<%
	}
%>
<div>