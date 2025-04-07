<!-- main.php에서 호출  -->

<?php
    // 세션 시작
    session_start(); 
?>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 / 회원가입</title>
    <script>
        //섹션 보이기/숨기기 (회원가입 보이기, 로그인 숨기기)
        function showRegisterForm()
        {
            document.getElementById("login").hidden = true;
            document.getElementById("register").hidden = false;
        }

        //섹션 보이기/숨기기 (회원가입 숨기기, 로그인 보이기)
        function showLoginForm()
        {
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
		    <!-- 아이디/비밀번호/로그인버튼/회원가입버튼 -->
		    <!-- 회원가입 버튼을 누르면, login.php 로 데이터 전송 -->
            <form id="login" method="post" action="./user/login.php">
                아이디 <input type="text" name="id" required><br>
                비밀번호 <input type="password" name="pw" required><br>

                <input type="submit" name="submit" value="로그인">

                <button type="button" onclick="showRegisterForm()">회원가입</button>
            </form>
            
            <!-- 회원가입 섹션 (hidden="true"로 처음에는 숨겨져있음)-->
		    <!-- 닉네임/아이디/비밀번호/취소버튼/가입버튼 -->
		    <!-- 가입 버튼을 누르면, register.php 로 데이터 전송 -->
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
            <p style="font-size: 24px; font-weight: bold;"><?= htmlspecialchars($user) ?>님 환영합니다!</p>
            <!-- 로그아웃 버튼을 누르면, logout.php 실행 -->
            <button onclick="location.href='./user/logout.php'">로그아웃</button>
            <br><br><br>
    <?php
        }
    ?>
    </div>
</body>
</html>
