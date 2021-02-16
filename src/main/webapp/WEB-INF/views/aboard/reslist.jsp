<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<%@include file="header.jsp"%>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<style>
.popup {
	position: absolute;
	left: 0px;
	top: 0px;
}

.back {
	background-color: gray;
	opacity: 0.5;
	width: 100%;
	height: 100%;
	overflow: hidden;
	z-index: 1101;
}

.front {
	z-index: 1110;
	opacity: 1;
	border: 1px;
}

.show {
	position: relative;
	width: 50%;
	height: 50%;
	margin: 200px auto;
	overflow: hidden;
}
li{
list-style:none;
}
.popup_img{
	margin:auto;
}
</style>
<div class="container">
	<div class='box'>
		<div class="box-header with-border">
			<h1 style="font-size: 30px" class="box-title"><strong>예약 목록</strong></h1>
		</div>
		<div class="box-body text-right">
			<select id="searchtype">
				<option value="n"<c:out value="${cri.search == null?'selected':''}"/>>---</option>
				<option value="id"<c:out value="${cri.search eq 'id'?'selected':''}"/>>예약아이디</option>
				<option value="date"<c:out value="${cri.search eq 'date'?'selected':''}"/>>예약일</option>
				<option value="nom"<c:out value="${cri.search eq 'nom'?'selected':''}"/>>좌석번호</option>
				<option value="seat"<c:out value="${cri.search eq 'seat'?'selected':''}"/>>좌석아이디</option>
				<option value="mem"<c:out value="${cri.search eq 'mem'?'selected':''}"/>>회원아이디</option>
				<option value="no"<c:out value="${cri.search eq 'no'?'selected':''}"/>>글번호</option>
				<option value="imp"<c:out value="${cri.search eq 'imp'?'selected':''}"/>>결제코드</option>
				<option value="status"<c:out value="${cri.search eq 'status'?'selected':''}"/>>상태</option>
			</select>
			<input id="key" type="text" id="keyword">
			<input id="search" type="button" class="btn btn-primary" value="검색">
			<select id="pagenum">
				<option value="10"<c:out value="${cri.search eq '10'?'selected':''}"/>>10</option>
				<option value="30"<c:out value="${cri.search eq '30'?'selected':''}"/>>30</option>
				<option value="50"<c:out value="${cri.search eq '50'?'selected':''}"/>>50</option>
				<option value="999999999999999999999999"<c:out value="${cri.search eq '--'?'selected':''}"/>>--</option>
			</select>
		</div>
	</div>
	<div class="box">
		<table class="table table-striped" id="list">
		<tr>
			<th><label id="res_id">예약아이디</label></th>
			<th><label id="res_date">예약일</label></th>
			<th><label id="res_nom">좌석번호</label></th>
			<th><label id="seat_id">좌석아이디</label></th>
			<th><label id="mem_id">회원아이디</label></th>
			<th><label id="ttr_no">글번호</label></th>
			<th><label id="imp_uid">결제코드</label></th>
			<th><label id="status">상태</label></th>
		</tr>
		</table>
	</div>
</div>
<div class="popup back" style="display: none;"></div>
	<div id="popup_front" class='popup front text-center' style="display: none;">
		<form id="updateform">
		</form>
	</div>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
var search;
var keyword;
var ord;
var orders=["id_asc","date_asc","nom_asc","seat_asc","mem_asc","no_asc","imp_asc","status_asc"]
var page=1
var pagenum=10
var pk;
var uid;
function date(as){
	a=new Date(as)
	console.log(a)
	return a.getFullYear()+"-"+a.getMonth()+"-"+a.getDate()+" "+a.getHours()+":"+a.getMinutes()
}
Date.prototype.toDateInputValue = (function() {
    var local = new Date(this);
    local.setMinutes(this.getMinutes() - this.getTimezoneOffset());
    return local.toJSON().slice(0,10);
});
function makelist(){
		$.getJSON("/aboard/res/"+search+"/"+keyword+"/"+ord+"/"+page+"/"+pagenum,function(data){
				var str="<tr>"+
				"<th><label id='res_id'>예약아이디</label></th>"+
				"<th><label id='res_date'>예약일</label></th>"+
				"<th><label id='res_nom'>좌석번호</label></th>"+
				"<th><label id='seat_id'>좌석아이디</label></th>"+
				"<th><label id='mem_id'>회원아이디</label></th>"+
				"<th><label id='ttr_no'>글번호</label></th>"+
				"<th><label id='imp_uid'>결제코드</label></th>"+
				"<th><label id='status'>상태</label></th>"+
			"</tr>";
				var list=data.list
				for(i in list){
					str+="<tr>"+
					"<td id='pk'>"+list[i].res_id+"</td>"+
					"<td>"+list[i].res_date+"</td>"+
					"<td>"+list[i].res_nom+"</td>"+
					"<td>"+list[i].seat_id+"</td>"+
					"<td>"+list[i].mem_id+"</td>"+
					"<td>"+list[i].ttr_no+"</td>"+
					"<td>"+list[i].imp_uid+"</td>"+
					"<td>"+list[i].status+"</td>"+
					"</tr>"
				}
				str+="<tr><td id='pagearea' colspan='7'></td></tr>"
				$('#list').html(str);
				var pageMaker=data.pageMaker;
				var str="";
				if(pageMaker.prev){
					str+="<li><button class='btn btn-primary'>"+(pageMaker.startPage-1)
						  +"'> << </button></li>";
				};
				for(var i=pageMaker.startPage,len=pageMaker.endPage;i<=len;i++){
					var strClass=pageMaker.cri.page==i?'class=active':'';
					str+="<li "+strClass+"><button class='reppage btn btn-primary'>"+i+"</button></li>";
				};
				if(pageMaker.next){
					str+="<li><button class='btn btn-primary'>"+(pageMaker.endPage+1)
					  +"'> >> </button></li>";
				};
				$('#pagearea').append(str);
	});
}
$(document).ready(function(){
	$('#list').on('click','tr th',function(index){
		if(orders[$(this).index()].indexOf('asc')>0){
			var a=orders[$(this).index()].replace('asc','desc')
			orders[$(this).index()]=a
			ord=a
		}else if(orders[$(this).index()].indexOf('desc')>0){
			var a=orders[$(this).index()].replace('desc','asc')
			orders[$(this).index()]=a
			ord=a
		}
		makelist()
	})
	$('#list').on('click','tr td li .reppage',function(index){
		page=$(this).text();
		makelist()
	})
	$('#search').on('click',function(event){
		search=$("#searchtype option:selected").val()
		keyword=$('#key').val()
		makelist();
	})
	$('#pagenum').change(function(){
		pagenum=$(this).children("option:selected").val();
		makelist();
	})
	makelist()
	$('#list').on('click','tr',function(event){
		pk=$(this).children('#pk').text()
		$.getJSON("/aboard/res/"+pk,function(data){
			data=data.res
			var str=""
			str+="<table class='table table-striped'><tr><td><label>좌석번호</label><input type='text' value="+data.res_nom+" name='res_nom' readonly></th></tr>"+
			"<tr><td><label>아이디</label><input type='text' value="+data.res_id+" name='res_id'></th></tr>"+
			"<tr><td><label>예약일</label><input type='date' value="+new Date(data.res_date).toDateInputValue()+" name='res_date'></th></tr>"+
			"<tr><td><label>회원아이디</label><input type='text' value="+data.mem_id+" name='mem_id'></th></tr>"+
			"<tr><td><label>글 번호</label><input type='text' value="+data.ttr_no+" name='ttr_no'></th></tr>"+
			"<tr><td><label>좌석아이디</label><input type='text' value="+data.seat_id+" name='seat_id'></th></tr>"+
			"<tr><td><label>결제아이디</label><input type='text' value="+data.imp_uid+" name='imp_uid'></th></tr>"+
			"<tr><td><label>상태</label><input type='text' value="+data.status+" name='status' readonly></th></tr>"+
			"<tr><td><input type='button' id='delete' value='삭제'></th></tr></table>";
			
			$('#updateform').html(str);
			$('.popup').show();
			uid=data.imp_uid;
		})
	});
	$('.back').on('click',function(){
		$('.popup').hide();
	});
	$('#updateform').on('click','table tr td #delete',function(event){
		$.ajax({
			url : "https://cors-anywhere.herokuapp.com/api.iamport.kr/users/getToken",
			type : "post",
			dataType : 'json',
			data: {
	    		imp_key:"imp_apikey",
	    		imp_secret:"ekKoeW8RyKuT0zgaZsUtXXTLQ4AhPFW3ZGseDA6bkA5lamv9OqDMnxyeB9wqOsuO9W3Mx9YSJ4dTqJ3f"
    		},
    	complete:function(result){
    		var token=result.responseJSON.response.access_token
    		$.ajax({
				url : "https://cors-anywhere.herokuapp.com/api.iamport.kr/payments/cancel?_token="+token,
				type : "post",
				dataType : 'json',
				data: {
		    		imp_uid : uid
	    		}
			});
    		$.getJSON("/aboard/resdel/"+pk)
    	}
		})
		makelist();
	});
})

</script>
</body>
</html>