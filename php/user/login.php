<!-- loginSection.php에서 호출  -->

<?php
// 세션 시작
session_start();

//DIR은 현재 php파일의 절대경로를 반환
//main에서 include/require 될 때. 상대경로시 경로가 꼬일 위험존재.
require(__DIR__ . "/../SQLconstants.php"); // DB 정보 포함 파일

// 이전 페이지 <form>의 POST로, 전달받은 데이터 (아이디/비밀번호)
$id = isset($_POST['id']) ? $_POST['id'] : null;
$pw = isset($_POST['pw']) ? $_POST['pw'] : null;
$message = null;

//ID/PW 모두 입력한 경우O
if ($id && $pw)
{
    try
    {
        // MySQL 연결하기
        $conn = new mysqli($mySQL_host, $mySQL_id, $mySQL_password, $mySQL_database);

        // 연결 오류 확인
        if ($conn->connect_error) {
            die("DB 연결 오류: " . $conn->connect_error);
        }

        // 유저 정보를 가져오는 SQL (SQL Injection 방지를 위해 Prepared Statement 사용)
        $query = "SELECT usernum, name FROM users WHERE id = ? AND pw = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("ss", $id, $pw);  // 두 개의 문자열 파라미터 바인딩
        $stmt->execute();
        $result = $stmt->get_result();

        // 아이디/비밀번호가 일치하는 유저 존재O
        if ($result->num_rows > 0) 
        {
            $row = $result->fetch_assoc();
            $name = $row['name'];
            $usernum = $row['usernum'];

            // 세션에 정보 저장하기
            $_SESSION['user'] = $name;
            $_SESSION['usernum'] = $usernum;

            // 메인 페이지로 리다이렉트
            header("Location: ../main.php");
            exit();
        }

        // 아이디/비밀번호가 일치하는 유저 존재X
        else
        { 
            $message = "로그인 정보가 일치하지 않습니다.";
            echo "<script>alert('$message'); window.location.href = '../main.php';</script>";
        }

        // MySQL 연결 닫기
        $stmt->close();
        $conn->close();
    }

    catch (Exception $e)
    {
        $message = $e->getMessage();
        echo "오류 발생: " . htmlspecialchars($message);
    }
}

//ID/PW 모두 입력한 경우X
else
{
    echo "<script>alert('아이디와 비밀번호를 입력하세요.'); window.location.href = '../main.php';</script>";
}
?>
