<?php
//수정 중
session_start(); // 세션 시작
?>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 / 회원가입</title>
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
</head>
<body>
<div id="loginSection">
<?php
    // 세션에 저장된 유저 정보가 없으면 로그인 창 표시
    if (!isset($_SESSION['user'])) { 
?>
        <!-- 로그인 섹션 -->
        <!-- 로그인 버튼을 누르면 login.php 로 데이터 전송 -->
        <form id="login" method="post" action="./user/login.php">
            아이디 <input type="text" name="id" required><br>
            비밀번호 <input type="password" name="pw" required><br>
            <input type="submit" name="submit" value="로그인">
            <button type="button" onclick="showRegisterForm()">회원가입</button>
        </form>
        
        <!-- 회원가입 섹션 -->
        <!-- 가입 버튼을 누르면 register.php 로 데이터 전송 -->
        <form id="register" method="post" action="./user/register.php" hidden>
            닉네임 <input type="text" name="name" required><br>
            아이디 <input type="text" name="id" required><br>
            비밀번호 <input type="password" name="pw" required><br>
            <button type="button" onclick="showLoginForm()">취소</button>
            <input type="submit" value="가입">
        </form>
<?php
    } else {
        // 세션에 저장된 유저 정보가 있으면 유저 환영 메시지 표시
        $user = $_SESSION['user'];
?>
        <p><?= htmlspecialchars($user) ?>님 환영합니다!</p>
        <!-- 로그아웃 버튼 -->
        <button onclick="location.href='./user/logout.php'">로그아웃</button>
<?php
    }
?>
</div>
</body>
</html>
