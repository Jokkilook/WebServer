<!-- loginSection.php에서 호출  -->

<?php
// 세션 시작
session_start();

// 세션에 저장된 유저 정보를 지우기
unset($_SESSION['user']);      // 유저 이름 제거
unset($_SESSION['usernum']);    // 유저 넘버 제거
unset($_SESSION['wishlist']);   // 찜 목록 제거

// 메인 페이지로 돌아가기
header("Location: ../main.php");
// 리다이렉트 후 코드 실행 방지
exit();
