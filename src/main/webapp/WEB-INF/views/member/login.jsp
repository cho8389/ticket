<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Login</title>


<link rel='stylesheet prefetch'
	href='http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/themes/smoothness/jquery-ui.css'>
<style type="text/css">
body {
	background:
		url(https://dl.dropboxusercontent.com/u/23299152/Wallpapers/wallpaper-22705.jpg)
		no-repeat center center fixed;
	-webkit-background-size: cover;
	-moz-background-size: cover;
	-o-background-size: cover;
	background-size: cover;
	font-family: 'Roboto', sans-serif;
}

.login-card {
	padding: 40px;
	width: 274px;
	background-color: #F7F7F7;
	margin: 0 auto 10px;
	border-radius: 2px;
	box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
	overflow: hidden;
}

.login-card h1 {
	font-weight: 100;
	text-align: center;
	font-size: 2.3em;
}

.login-card input[type=submit] {
	width: 100%;
	display: block;
	margin-bottom: 10px;
	position: relative;
}

.login-card input[type=text], input[type=password] {
	height: 44px;
	font-size: 16px;
	width: 100%;
	margin-bottom: 10px;
	-webkit-appearance: none;
	background: #fff;
	border: 1px solid #d9d9d9;
	border-top: 1px solid #c0c0c0;
	/* border-radius: 2px; */
	padding: 0 8px;
	box-sizing: border-box;
	-moz-box-sizing: border-box;
}

.login-card input[type=text]:hover, input[type=password]:hover {
	border: 1px solid #b9b9b9;
	border-top: 1px solid #a0a0a0;
	-moz-box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
	-webkit-box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
	box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
}

.login {
	text-align: center;
	font-size: 14px;
	font-family: 'Arial', sans-serif;
	font-weight: 700;
	height: 36px;
	padding: 0 8px;
	/* border-radius: 3px; */
	/* -webkit-user-select: none;
  user-select: none; */
}

.login-submit {
	/* border: 1px solid #3079ed; */
	border: 0px;
	color: #fff;
	text-shadow: 0 1px rgba(0, 0, 0, 0.1);
	background-color: #dc3545;
	/* background-image: -webkit-gradient(linear, 0 0, 0 100%,   from(#4d90fe), to(#4787ed)); */
}

.login-submit:hover {
	/* border: 1px solid #2f5bb7; */
	border: 0px;
	text-shadow: 0 1px rgba(0, 0, 0, 0.3);
	background-color: #dc3545;
	/* background-image: -webkit-gradient(linear, 0 0, 0 100%,   from(#4d90fe), to(#357ae8)); */
}

.login-card a {
	text-decoration: none;
	color: #666;
	font-weight: 400;
	text-align: center;
	display: inline-block;
	opacity: 0.6;
	transition: opacity ease 0.5s;
}

.login-card a:hover {
	opacity: 1;
}

.login-help {
	width: 100%;
	text-align: center;
	font-size: 12px;
}
</style>


</head>

<body>

	<div class="login-card">
		<h1>로그인</h1>
		<br>
		<form action="/member/loginPost" method="post">
			<input type="hidden" name="returl" value="${param.returl }" />
			<input type="text" name="id" placeholder="ID"> 
			<input type="password" name="pw" placeholder="Password"> 
			<input type="submit" name="login" onclick="login_go()" class="login login-submit" value="login">
		</form>

		<div class="login-help">
			<a href="/member/regist">회원가입</a> • <a href="/member/findPass">아이디/비밀번호 찾기</a>
		</div>
	</div>
	
	<!-- <div id="error"><img src="https://dl.dropboxusercontent.com/u/23299152/Delete-icon.png" /> Your caps-lock is on.</div> -->
	<script
		src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
	<script
		src='http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js'></script>
	
	<!-- jQuery 2.1.4 -->
	<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<script>
		function login_go(event){
			event.preventDefault();
			$.ajax({
				url:'loginPost',
				type:'post',
				data:$('form input').serialize(),
				dataType:'json',
				beforeSend:function(xhr){
					xhr.setRequestHeader("Accept","application/json")	
				}
			}).done(function(body){
	    		 var message=body.response.message;
	    		 var error=body.response.error;
	    		 var returl=body.response.returl;
	    		 if (error){
	    			 alert(message);
	    			 $('input[name=returl]').val(returl);
	    		 }else{
	    			 if(returl==''){
	    				 returl="<c:url value="/member/index" />";
	    			 }
	    			 location.href=returl;    				 
	    		 }
	    	  });
		}
	</script>


</body>

</html>
