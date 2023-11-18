<?php
header("Access-Control-Allow-Origin:*");
header("Access-Control-Allow-Headers:*");
//MySQL database Connection
$con = mysqli_connect('localhost', 'root', '', 'mk_mobile_smt_5');

//Received JSON into $json variable
$json = file_get_contents('php://input');
$obj = json_decode($json, true);

if (isset($obj["username"]) && isset($obj["password"])) {
    $uname = mysqli_real_escape_string($con, $obj['username']);
    $pwd = mysqli_real_escape_string($con, $obj['password']);

    $result = [];

    $sql = "SELECT * FROM ms_users WHERE username='{$uname}' and
    password='{$pwd}'";

    $res = $con->query($sql);
    if ($res->num_rows > 0) {
        $row = $res->fetch_assoc();
        $result['loginStatus'] = true;
        $result['message'] = "Login Successfully!";
        $result["userInfo"] = $row;
    } else {
        $result['loginStatus'] = false;
        $result['message'] = "Invalid Login! Please try again!";
    }

    echo json_encode($result);
} else {
    //set http code
    http_response_code(404);
    echo json_encode(['message' => "404 Not Found!"]);
}
