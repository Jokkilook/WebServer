<!-- loginSection.php에서 호출  -->

<?php
session_start(); // 세션 시작

//DIR은 현재 php파일의 절대경로를 반환
//main에서 include/require 될 때. 상대경로시 경로가 꼬일 위험존재.
require(__DIR__ . "/../SQLconstants.php"); // DB 정보 포함 파일

// 이전 페이지 <form>의 POST로, 전달받은 데이터
$id = isset($_POST['id']) ? $_POST['id'] : null;
$pw = isset($_POST['pw']) ? $_POST['pw'] : null;
$name = isset($_POST['name']) ? $_POST['name'] : null;
$message = null;

try
{
    // MySQL 연결하기
    $conn = new mysqli($mySQL_host, $mySQL_id, $mySQL_password, $mySQL_database);

    // 연결 오류 확인
    if ($conn->connect_error)
    {
        die("DB 연결 오류: " . $conn->connect_error);
    }

    // 유저 정보를 유저 테이블에 추가하는 SQL 문 작성
    $query = "INSERT INTO users (id, pw, name) VALUES (?, ?, ?)";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("sss", $id, $pw, $name); // 문자열 3개 바인딩

    // SQL 실행 및 결과 확인
    if ($stmt->execute()) {
        // 회원가입 성공 시
        echo "<script>alert('회원가입에 성공했습니다!'); window.location.href = '../main.php';</script>";
    } else {
        // 회원가입 실패 시
        echo "<script>alert('회원가입에 실패했습니다!'); window.location.href = '../main.php';</script>";
    }

    // 연결 해제
    $stmt->close();
    $conn->close();
}

catch (Exception $e)
{
    $message = $e->getMessage();
    echo "오류 발생: " . htmlspecialchars($message);
}
