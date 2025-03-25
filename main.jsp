<%@ page language="java" contentType= "text/html;charset=utf8" pageEncoding="utf8"%>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게임 리스트</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .game-item { display: flex; align-items: center; justify-content: space-between; background: #ccc; padding: 10px; margin: 10px 0; border-radius: 5px; }
        .game-info { flex: 1; }
        .button { background: red; color: white; padding: 5px 10px; border: none; cursor: pointer; }
        .login-form { display: none; background: #ddd; padding: 10px; margin-top: 20px; }
    </style>
</head>
<body>
    <h2>게임 리스트</h2>
    <div id="game-list">
        <div class="game-item">
            <div class="game-info">
                <strong>게임 이름</strong><br>
                개발자: 개발자 이름<br>
                장르: 장르명<br>
                가격: 10.99$
            </div>
            <button class="button" onclick="checkLogin()">찜하기</button>
        </div>
    </div>
    
    <div id="login-form" class="login-form">
        <h3>로그인</h3>
        아이디: <input type="text" id="user-id"><br>
        비밀번호: <input type="password" id="password"><br>
        <button onclick="login()">로그인</button>
        <button onclick="register()">회원가입</button>
    </div>
    
    <script>
        let isLoggedIn = false;
        function checkLogin() {
            if (!isLoggedIn) {
                document.getElementById('login-form').style.display = 'block';
            } else {
                alert('찜 목록에 추가되었습니다.');
            }
        }
        function login() {
            isLoggedIn = true;
            document.getElementById('login-form').style.display = 'none';
            alert('로그인 성공!');
        }
        function register() {
            alert('회원가입 페이지로 이동합니다.');
        }
    </script>
</body>
</html>