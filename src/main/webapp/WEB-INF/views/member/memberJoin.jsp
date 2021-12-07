<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알바의 민족 개인회원가입</title>
<!-- Favicon -->
<link rel="shortcut icon"
	href="${pageContext.request.contextPath}/resources/assets/images/logo/favicon.png" type="image/x-icon">
<!-- CSS Files -->
<link rel="stylesheet" href="<c:url value='/resources/assets/css/almin.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/member/css/member.css'/>">
<style>
.agree_terms{/* 가입약관 */
  height: 300px;/* scroll하기 위해 추가 */
  padding: 0 18px;
  background-color: white;
  max-height: 0;
  overflow: scroll;
  transition: max-height 0.3s ease-out;
 }
</style>
</head>
<script type="text/javascript">
	$(document).ready(function(){ 
		$("#agreeChkAll").change(function selectAll(selectAll) {
			console.log("전체선택 체크");
		    if(this.checked){
			console.log($("input[name=agree]"));
			$(':checkbox').each(function() {
	            this.checked = true;                        
	        });
		    }
			else $("input[name=agree]").prop("checked", false);
			}); 
		
		//내용보기 클릭 시 가입약관 Accordion
		var acc = document.getElementsByClassName("toggle_terms");
		var i;

		for (i = 0; i < acc.length; i++) {
		  acc[i].addEventListener("click", function() {
		    this.classList.toggle("active");
		    var agree_terms = this.nextElementSibling;
		    if (agree_terms.style.maxHeight) {
		    	agree_terms.style.maxHeight = null;
		      } else {
		    	  agree_terms.style.maxHeight = agree_terms.scrollHeight + "px";
		      } 
		  });
		}
			$(".cancel").on("click", function(){// 취소버튼 클릭 시
				location.href = "${pageContext.request.contextPath}/main";
			})
			
			// 정규표현식 선언
			var regExp = /^[0-9]*$/;   
			var idPattern = /^[a-zA-Z]{1}[A-Za-z0-9]{6,50}$/;
//			var pwPattern = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,250}$/;
//			var pwPattern =/^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+])(?!.*[^a-zA-z0-9$`~!@$!%*#^?&\\(\\)\-_=+]).{6,16}$/;
			var pwPattern =/^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$^!%*#?&])[A-Za-z\d$@$!^%*#?&]{6,}$/;
			var namePattern = /^[a-zA-Z가-힣]*$/;
			var birthPattern = /^\d{2}([0]\d|[1][0-2])([0][1-9]|[1-2]\d|[3][0-1]){6}$/;
			var genderPattern = /^[1-4]{1}$/;
			var emailPattern = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*.[a-zA-Z]{1,3}$/i;   
//			var phonePattern = /^01[016789]{1}-?([0-9]{4})-?([0-9]{4})$/;
			var phone2Pattern = /^[0-9]{3,4}$/;
			var phone3Pattern = /^[0-9]{4}$/;
			//맨 뒤의 /i는 대소문자 구분하지 않도록 쓸 때 사용
			var idChkYN = "N";
			$("#idCheck").on("click", function(){
			
			var html = "";
			var userId = $("#userId").val();
				console.log(userId);
					if(userId == ""){
						alert("아이디를 입력해주세요.");
						$("#userId").focus();
						return false;
					} else if(!idPattern.test(userId)){
						alert("아이디를 조건에 맞게 입력해주세요(6~50자 영문, 숫자)");
		                return false;
					}	else {
					}
						$.ajax({
							type : 'post',
							url : '${pageContext.request.contextPath}/members/idCheck',
							data : {
								userId : userId
							},
							dataType : 'text',
							success : function(result) {
								console.log(result);
								if (result == 1) {
									alert("중복된 ID입니다.");
								} else {
									alert("사용가능한 ID입니다.");
									html+="ID 중복확인 완료";
									idChkYN = "Y";
									$("#userId").attr("readonly",true);
									$("#userId").css({//TODO: 왜 안 먹는지 확인
										"background-color":"#ddd"
									});
								} $("#idCmt").html(html);
								console.log($("#idCmt").val);
							},
							error : function(e) {
								$("#checkId").text("ajax 통신 실패");
							}
						});
					});
	
			$("#userPass").on("keyup", function(){
				var userPass = $("#userPass").val();
				var html = "";
				console.log("입력한 비밀번호: "+userPass);
				if(!pwPattern.test(userPass)){
					console.log("정규식XXX");
					 html+="영문, 숫자, 특수문자 포함 6자 이상 입력";
				} else{
					html+="비밀번호 양식에 부합합니다.";
					$("#pwCmt").css({"color":"green"});
				}  $("#pwCmt").html(html);
			})
			
			$("#pwChk").on("keyup", function(){
				var userPass = $("#userPass").val();
				var pwChk = $("#pwChk").val();
				var html = "";
				if($("#userPass").val()==""){
					 html+="먼저 비밀번호를 입력해주세요.";
					$("#userPass").focus();
				} else if(userPass != pwChk){
					 html+="비밀번호가 일치하지 않습니다.";
				} else{
					 html+="비밀번호가 일치합니다.";
					$("#pwChkCmt").css({"color":"green"});
				}
				$("#pwChkCmt").html(html);
			})
			
			$("#userName").on("keyup", function(){
				var userName = $("#userName").val();
				var html = "";
				if(!namePattern.test(userName)){
					 html+="영문 또는 한글만 입력해주세요.";
				} $("#nmCmt").html(html);
			})
			
			$("#birthNum").on("keyup", function(){
				var birthNum = $("#birthNum").val();
				var html = "";
				if(!birthPattern.test(birthNum)){
					 html+="생년월일 형태로 입력해주세요.";
				} $("#gdCmt").html(html);
			})
			
			$("#genderNum").on("keyup", function(){
				var genderNum = $("#genderNum").val();
				var html = "";
				if(!genderPattern.test(genderNum)){
					 html+="1~4 숫자만 입력해주세요.";
				} $("#gdCmt").html(html);
			})
			
			$("#email_3").change(function(){
				$("#email_3 option:selected").each(function () { 
					if($(this).val()== '1'){ //직접입력일 경우
						$("#email_2").val(''); //값 초기화
						$("#email_2").attr("disabled",false); //활성화
						}else{ //직접입력이 아닐경우
							$("#email_2").val($(this).text()); //선택값 입력
							$("#email_2").attr("disabled",true); //비활성화
							}
					});
			});
			
			$("#phone2").on("keyup", function(){
				var phone2 = $("#phone2").val();
				var html = "";
				if(!phone2Pattern.test(phone2)){
					 html+="최소3자리, 최대4자리 숫자만 입력해주세요.";
				} $("#pn2Cmt").html(html);
			})
			$("#phone3").on("keyup", function(){
				var phone3 = $("#phone3").val();
				var html = "";
				if(!phone3Pattern.test(phone3)){
					 html+="4자리 숫자만 입력해주세요.";
				} $("#pn3Cmt").html(html);
			})
			
			$("#submit").on("click", function(){
			//TODO: agreeChk_5, 0, 1 체크안되면 "필수항목에 동의해주세요."
			if($("#userId").val()==""){
				alert("아이디를 입력해주세요.");
				$("#userId").focus();
				return false;
			} else if(idChkYN=="N"){
				alert("아이디 중복확인 해주세요");
				$("#userId").focus();
				return false;
			}
			if($("#userPass").val()==""){
				alert("비밀번호를 입력해주세요.");
				$("#userPass").focus();
				return false;
			}
			if($("#userName").val()==""){
				alert("성명을 입력해주세요.");
				$("#userName").focus();
				return false;
			}
			var json = {'memberId':  $("#userId").val(),
					'memberPw': $("#userPass").val(),
					'memberName':$("#userName").val(),
					'memberPhone':$("#phone1").val()+"-"+$("#phone2").val()+"-"+$("#phone3").val(),
					'memberBirth':$("#birthNum").val(),
					'memberGender':$("#genderNum").val(),
					'memberEmail':$("#email_1").val()+"@"+$("#email_2").val()
					};
			$.ajax({
				url: "<%=request.getContextPath()%>/members",
				type: "post",
				 // data : 서버(컨트롤러)로 보내는 데이터.
				 // json데이터를 JSON.stringify를 이용하여 String으로 형변환
				data: JSON.stringify(json),
				//이때 전달한 String데이터는 JSON형태의 데이터임을 알려줌.
				contentType : "application/json; charset=utf-8",
				success: function(result){
					if(result == 0){
						alert("아이디와 비밀번호를 다시 확인해주세요.");
					} else {
						console.log("로그인 성공")
		    		$(".modal").hide(); 
					$("#login-state").show();//로그아웃, 마이페이지
					$("#logout-state").hide();//로그인, 회원가입
					}
				location.href ="<%=request.getContextPath()%>/members/emails?Memberemail="+$("#email_1").val()+"@"+$("#email_2").val()
			},
			error:function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+
						"\n"+"error:"+error);
			}
			});
	});
});
</script>
<body>
<!-- 공통헤더 템플릿 -->
<c:import url="/WEB-INF/views/template/header.jsp"/>
<section>
	<h2>개인회원가입</h2>
	<div class="inner">
    <div class="user_join_agree">									<!-- 여기서 this는 이벤트가 발생한 element, 즉, '일괄동의' 체크박스 -->
        <input type="checkbox" name="selectall" id="agreeChkAll" value="selectall"><label for="agreeChkAll"><b style="color:dodgerblue">필수동의 항목 및 [선택] 개인정보 수집 및 이용동의, [선택] 광고성 정보 이메일/SMS 수신 동의에 일괄 동의합니다.</b></label>
    </div>
    <hr>
    <div class="user_join_agree agrSelect">
        <input type="checkbox" name="agree" id="agreeChk_5" value="on" data-required="1"><label for="agreeChk_5"><span>[필수]</span> 만 15세 이상입니다</label>
    </div>
    <div class="user_join_agree agrSelect">
        <input type="checkbox" name="agree" id="agreeChk_0" value="on" data-required="1"><label for="agreeChk_0"><span>[필수]</span> 서비스 이용약관 동의</label>
        <div class="toggle_terms"><a href="#">내용보기<span class=""></span></a></div>
        <div class="agree_terms">
            <p>개정일자 : 2020년 9월 3일</p>
            <dl>
                <dt>제1조 (목적)</dt>
                <dd>본 약관은 알바의 민족 유한책임회사 (이하 "회사")가 운영하는 "서비스"를 이용함에 있어 "회사"와 회원간의 이용 조건 및 제반 절차, 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 한다.</dd>
                <dt>제2조 (용어의 정의)</dt>
                <dd>
                    이 약관에서 사용하는 용어의 정의는 아래와 같다.
                    <ol>
                        <li>
                            ① "사이트"라 함은 회사가 서비스를 "회원"에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 설정한 가상의 영업장 또는 회사가 운영하는 웹사이트, 모바일웹, 앱 등의 서비스를 제공하는 모든 매체를 통칭하며, 통합된 하나의 회원 계정(아이디 및 비밀번호)을 이용하여 서비스를 제공받을 수 있는 아래의 사이트를 말한다.
                            <ul>
                                <li>- www.albamon.com</li>
                                <li>- m.albamon.com</li>
                            </ul>
                        </li>
                        <li>② "서비스"라 함은 회사가 운영하는 사이트를 통해 개인이 구직, 교육 등의 목적으로 등록하는 자료를 DB화하여 각각의 목적에 맞게 분류 가공, 집계하여 정보를 제공하는 서비스와 사이트에서 제공하는 모든 부대 서비스를 말한다.</li>
                        <li>③ "회원"이라 함은 "회사"가 제공하는 서비스를 이용하거나 이용하려는 자로, 페이스북 등 외부 서비스 연동을 통해 "회사"와 이용계약을 체결한자 또는 체결하려는 자를 포함하며, 아이디와 비밀번호의 설정 등 회원가입 절차를 거쳐 회원가입확인 이메일 등을 통해 회사로부터 회원으로 인정받은 "개인회원"을 말한다.</li>
                        <li>④ "아이디"라 함은 회원가입시 회원의 식별과 회원의 서비스 이용을 위하여 회원이 선정하고 "회사"가 부여하는 문자와 숫자의 조합을 말한다.</li>
                        <li>⑤ "비밀번호"라 함은 위 제4항에 따라 회원이 회원가입시 아이디를 설정하면서 아이디를 부여받은 자와 동일인임을 확인하고 "회원"의 정보 등을 보호하기 위하여 "회원"이 선정한 문자와 숫자의 조합을 말한다.</li>
                        <li>⑥ "비회원"이라 함은 회원가입절차를 거치지 않고 "회사"가 제공하는 서비스를 이용하거나 하려는 자를 말한다.</li>
                    </ol>
                </dd>
                <dt>제3조 (약관의 명시와 개정)</dt>
                <dd>
                    <ol>
                        <li>① "회사"는 이 약관의 내용과 상호, 영업소 소재지, 대표자의 성명, 사업자등록번호, 연락처 등을 이용자가 알 수 있도록 초기 화면에 게시하거나 기타의 방법으로 이용자에게 공지해야 한다.</li>
                        <li>② "회사"는 약관의 규제에 관한 법률, 전기통신기본법, 전기통신사업법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등 관련법을 위배하지 않는 범위에서 이 약관을 개정할 수 있다.</li>
                        <li>③ "회사"가 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행약관과 함께 그 개정약관의 적용일자 7일 전부터 적용일자 전일까지 공지한다. 단 "회원"의 권리, 의무에 중대한 영향을 주는 변경의 경우에는 적용일자 30일 전부터 공지하도록 한다.</li>
                        <li>④ "회원"은 변경된 약관에 대해 거부할 권리가 있다. "회원"은 변경된 시점으로부터 15일 이내에 거부의사를 표명할 수 있다. "회원"이 거부하는 경우 본 서비스 제공자인 "회사"는 15일의 기간을 정하여 "회원"에게 사전 통지 후 당해 "회원"과의 계약을 해지할 수 있다. 만약, "회원"이 거부의사를 표시하지 않거나, 전항에 따라 시행일 이후에 "서비스"를 이용하는 경우에는 동의한 것으로 간주한다.</li>
                    </ol>
                </dd>
                <dt>제4조 (약관의 해석)</dt>
                <dd>
                    <ol>
                        <li>① 이 약관에서 규정하지 않은 사항에 관해서는 약관의 규제에 관한 법률, 전기통신기본법, 전기통신사업법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등의 관계법령에 따른다.</li>
                        <li>② 각 사이트 및 서비스 이용약관이 있는 경우에는 서비스 이용약관이 우선한다.</li>
                        <li>③ "회원"이 "회사"와 개별 계약을 체결하여 서비스를 이용하는 경우에는 개별 계약이 우선한다.</li>
                    </ol>
                </dd>
                <dt>제 5 조 (이용계약의 성립)</dt>
                <dd>
                    <ol>
                        <li>① "회사"의 서비스 이용계약(이하 '이용계약')은 서비스를 이용하고자 하는 자가 본 약관과 개인정보처리방침을 읽고 "동의" 또는 "확인" 버튼을 누른 경우 본 약관에 동의한 것으로 간주한다. </li>
                        <li>② 제1항 신청에 있어 "회사"는 "회원"의 종류에 따라 전문기관을 통한 실명확인 및 본인인증을 요청할 수 있으며, "회원"은 본인인증에 필요한 이름, 생년월일, 연락처 등을 제공하여야 한다. </li>
                        <li>③ "회원"이 이용신청(회원가입 신청) 작성 후에 "회사"가 웹상의 안내 및 전자메일로 "회원"에게 통지함으로써 이용계약이 성립된다.</li>
                        <li>④페이스북 등 외부 서비스와의 연동을 통해 이용계약을 신청할 경우, 본 약관과 개인정보처리방침, 서비스 제공을 위해 "회사"가 "회원"의 외부 서비스 계정 정보 접근 및 활용에 "동의" 또는 "확인" 버튼을 누르면 "회사"가 웹상의 안내 및 전자메일로 "회원"에게 통지함으로써 이용계약이 성립된다. </li>
                    </ol>
                </dd>
                <dt>제6조 (이용신청의 승낙과 제한)</dt>
                <dd>
                    <ol>
                        <li>① "회사"는 전조의 규정에 의한 이용신청 고객에 대하여 업무수행상 또는 기술상 지장이 없는 경우에는 원칙적으로 접수순서에 따라 서비스 이용을 승낙한다.</li>
                        <li>
                            ② "회사"는 아래사항에 해당하는 경우에 대해서는 서비스 이용신청을 승낙하지 아니한다.
                            <ol>
                                <li>1. 실명이 아니거나 타인의 명의를 이용하여 신청한 경우</li>
                                <li>2. 이용계약 신청서의 내용을 허위로 기재하거나 "회사"가 제시하는 내용을 기재하지 않은 경우</li>
                                <li>3. 만 15세 미만의 아동이 신청한 경우. 다만, 만 13세 이상 만 15세 미만의 아동으로서 노동부장관 발급의 취직인허증이 있는 경우에는 그러하지 아니한다.</li>
                                <li>4. 이용자의 귀책사유로 인하여 승인이 불가능하거나 기타 규정한 제반 사항을 위반하여 신청하는 경우 </li>
                            </ol>
                        </li>
                        <li>
                            ③ "회사"는 아래사항에 해당하는 경우에는 그 신청에 대하여 승낙제한 사유가 해소될 때까지 승낙을 유보할 수 있다.
                            <ol>
                                <li> 1. "회사"가 설비의 여유가 없는 경우</li>
                                <li> 2. "회사"의 기술상 지장이 있는 경우</li>
                                <li> 3. 기타 "회사"의 귀책사유로 이용승낙이 곤란한 경우</li>
                            </ol>
                        </li>
                    </ol>
                </dd>
                <dt>제7조 (서비스의 내용)</dt>
                <dd>
                    <ol>
                        <li>
                            ① "회사"는 제2조 2항의 서비스를 제공할 수 있으며 그 내용은 다음 각 호와 같다.
                            <ol>
                                <li>1. 이력서 등록 및 인재정보 게재 서비스</li>
                                <li>2. 온라인 입사지원 서비스</li>
                                <li>3. 헤드헌팅/아웃소싱 서비스</li>
                                <li>4. 구인/구직과 관련된 제반 서비스</li>
                                <li>5. 교육과 관련된 제반 서비스</li>
                                <li>6. 이용자간의 교류와 소통에 관련한 서비스</li>
                                <li>7. 자료거래에 관련한 서비스</li>
                                <li>8. 기타 "회사"가 추가 개발, 편집, 재구성하거나 제휴계약 등을 통해 "회원"에게 제공하는 일체의 서비스</li>
                            </ol>
                        </li>
                        <li>② "회사"는 필요한 경우 서비스의 내용을 추가 또는 변경할 수 있다. 단, 이 경우 "회사"는 추가 또는 변경내용을 회원에게 공지해야 한다.</li>
                    </ol>
                </dd>
                <dt>제8조 (회원, 이력서 정보)</dt>
                <dd>
                    <ol>
                        <li>① "회원"의 이력서는 개인이 회원가입 또는 이력서 작성 및 수정시 희망한 형태로 등록 및 제공된다.</li>
                        <li>② "회사"는 "회원"이 이력서의 인재정보 등록/미등록 지정, 이력서상의 연락처 제공 여부를 자유롭게 선택할 수 있도록 하여야 한다.</li>
                        <li>③ "회사"는 "회원"이 이력서의 인재정보 등록 및 제공을 희망했을 경우, 기업회원, 서치펌회원의 이력서 열람 및 각종 포지션 제안에 동의한 것으로 간주하며 "회사"는 기업회원, 서치펌회원에게 유료로 이력서 열람 서비스를 제공할 수 있다. 다만, 연락처 각 항목이 비공개로 지정된 경우 해당 항목별 연락처를 노출할 수 없다.</li>
                        <li>④ "회사"는 안정적인 서비스를 제공하기 위해 테스트 및 모니터링 용도로 "사이트" 운영자가 이력서 정보를 열람하도록 할 수 있다.</li>
                        <li>⑤ "회사"는 "회원"의 자유로운 선택에 의하여 등록 및 제공되는 이력서의 정보를 기준(바탕)으로 구직활동에 보다 유익한 서비스를 제공하기 위하여 이를 개발, 편집, 재구성한 통계 자료로 활용 할 수 있다.</li>
                    </ol>
                </dd>
                <dt>제9조 (제휴를 통한 서비스)</dt>
                <dd>
                    <ol>
                        <li>① "회사"는 제휴 관계를 체결한 여타 인터넷 웹 사이트 및 채용박람회 또는 신문, 잡지 등의 오프라인 매체를 통해 사이트에 등록한 "회원"의 이력서 정보가 열람될 수 있도록 서비스를 제공할 수 있다. 단, 제휴 서비스를 통해 노출되는 이력서의 연락처 정보는 "회원"이 이력서 등록 시 선택한 연락처 공개 여부에 따라 제공된다.</li>
                        <li>② "회사"는 제휴를 통해 타 사이트 및 매체에 등록될 수 있음을 고지해야 하며, 제휴 사이트 목록을 사이트내에서 상시 열람할 수 있도록 해야 한다. 단, 등록의 형태가 "회사"가 직접 구축하지 않고, 제휴사가 xml 또는 api 형태로 "회사"로부터 제공 받아 구축한 매체 목록은 본 약관 외 별도의 제휴 리스트에서 열람할 수 있도록 한다.</li>
                        <li>③ "회사"는 "회원"이 공개를 요청한 이력서에 한해 제휴를 맺은 타 사이트에 이력서 정보를 제공한다. (본 약관 시행일 현재에는 제휴를 통한 타 사이트 및 매체는 없다.)</li>
                        <li>④ "본조 제③호" 제휴를 통한 사이트의 변동사항 발생 시 공지사항을 통해 고지 후 진행 한다.</li>
                    </ol>
                </dd>
                <dt>제10조 (서비스의 요금)</dt>
                <dd>
                    <ol>
                        <li>① "회원" 가입과 이력서 등록은 무료이다. 다만 기업회원 또는 사이트에 방문한 기업체에게 자신의 이력서 정보를 보다 효과적으로 노출시키기 위한 유료서비스 및 인성, 적성 검사 등 회원 가입 목적 외 기타 서비스를 이용하기 위한 별도의 서비스는 유료로 제공될 수 있다.</li>
                        <li>② "회사"는 유료서비스를 제공할 경우 사이트에 요금에 대해서 공지를 하여야 한다.</li>
                        <li>③ "회사"는 유료서비스 이용금액을 서비스의 종류 및 기간에 따라 "회사"가 예고 없이 변경할 수 있다. 다만, 변경 이전에 적용 또는 계약한 금액은 소급하여 적용하지 아니한다.</li>
                    </ol>
                </dd>
                <dt>제11조 (서비스 요금의 환불)</dt>
                <dd>
                    <ol>
                        <li>
                            ① "회사"는 다음 각 호에 해당하는 경우 이용요금을 환불한다. 단, 각 당사자의 귀책사유에 따라 환불 조건이 달라질 수 있다.
                            <ol>
                                <li>1. 유료서비스 이용이 개시되지 않은 경우</li>
                            </ol>
                            <ol>
                                <li> 2. 네트워크 또는 시스템 장애로 서비스 이용이 불가능한 경우</li>
                            </ol>
                            <ol>
                                <li> 3. 유료서비스 신청 후 "회원"의 사정에 의해 서비스가 취소될 경우</li>
                            </ol>
                        </li>
                        <li>② "회사"가 본 약관 제19조에 따라 가입해지/서비스중지/자료삭제를 취한 경우, "회사"는 "회원"에게 이용요금을 환불하지 않으며, 별도로 "회원"에게 손해배상을 청구할 수 있다.</li>
                        <li>③ 이용료를 환불받고자 하는 회원은 고객센터로 환불을 요청해야 한다.</li>
                        <li>④ "회사"는 환불 요건에 부합하는 것으로 판단될 경우, 각 서비스 환불 안내에 따라 유료이용 계약 당시 상품의 정가 기준으로 서비스 제공된 기간에 해당하는 요금을 차감한 잔액을 환불한다.</li>
                    </ol>
                </dd>
                <dt>제12조 (서비스 이용시간)</dt>
                <dd>
                    <ol>
                        <li>① "회사"는 특별한 사유가 없는 한 연중무휴, 1일 24시간 서비스를 제공한다. 다만, "회사"는 서비스의 종류나 성질에 따라 제공하는 서비스 중 일부에 대해서는 별도로 이용시간을 정할 수 있으며, 이 경우 "회사"는 그 이용시간을 사전에 회원에게 공지 또는 통지하여야 한다.</li>
                        <li>② "회사"는 자료의 가공과 갱신을 위한 시스템 작업시간, 장애 해결을 위한 보수작업 시간, 정기 PM 작업, 시스템 교체작업, 회선 장애 등이 발생한 경우 일시적으로 서비스를 중단할 수 있으며 계획된 작업의 경우 공지란에 서비스 중단 시간과 작업 내용을 알려야 한다. 다만, "회사"가 사전에 통지할 수 없는 부득이한 사유가 있는 경우 사후에 통지할 수 있다.</li>
                    </ol>
                </dd>
                <dt>제13조 (서비스 제공의 중지)</dt>
                <dd>
                    <ol>
                        <li>
                            ① "회사"는 다음 각 호에 해당하는 경우 서비스의 제공을 중지할 수 있다.
                            <ol>
                                <li>1. 설비의 보수 등 "회사"의 필요에 의해 사전에 회원들에게 통지한 경우</li>
                                <li>2. 기간통신사업자가 전기통신서비스 제공을 중지하는 경우</li>
                                <li>3. 기타 불가항력적인 사유에 의해 서비스 제공이 객관적으로 불가능한 경우</li>
                            </ol>
                        </li>
                        <li>② 전항의 경우, "회사"는 기간의 정함이 있는 유료서비스 이용자들에게는 그 이용기간을 연장하거나 환불 등의 방법으로 손실을 보상하여야 한다.</li>
                    </ol>
                </dd>
                <dt>제14조 (정보의 제공 및 광고의 게재)</dt>
                <dd>
                    <ol>
                        <li>① "회사"는 "회원"에게 서비스 이용에 필요가 있다고 인정되거나 서비스 개선 및 회원대상의 서비스 소개 등의 목적으로 하는 각종 정보에 대해서 전자우편이나 서신우편을 이용한 방법으로 제공할 수 있다.</li>
                        <li>② "회사"는 제공하는 서비스와 관련되는 정보 또는 광고를 서비스 화면, 홈페이지, 전자우편 등에 게재할 수 있으며, 광고가 게재된 전자우편을 수신한 "회원"은 수신거절을 "회사"에게 할 수 있다.</li>
                        <li>③ "회사"는 서비스상에 게재되어 있거나 본 서비스를 통한 광고주의 판촉활동에 회원이 참여하거나 교신 또는 거래를 함으로써 발생하는 모든 손실과 손해에 대해 책임을 지지 않는다.</li>
                        <li>④ 본 서비스의 "회원"은 서비스 이용 시 노출되는 광고게재에 대해 동의 하는 것으로 간주한다.</li>
                    </ol>
                </dd>
                <dt>제15조 (자료내용의 책임과 "회사"의 정보 수정 권한)</dt>
                <dd>
                    <ol>
                        <li>① 자료내용은 "회원"이 등록한 개인정보 및 이력서와 사이트에 게시한 게시물을 말한다.</li>
                        <li>② "회원"은 자료 내용 및 게시물을 사실에 근거하여 성실하게 작성해야 하며, 만일 자료의 내용이 사실이 아니거나 부정확하게 작성되어 발생하는 모든 책임은 "회원"에게 있다.</li>
                        <li>③ 모든 자료내용의 관리와 작성은 "회원" 본인이 하는 것이 원칙이나 사정상 위탁 또는 대행관리를 하더라도 자료내용의 책임은 "회원"에게 있으며 "회원"은 주기적으로 자신의 자료를 확인하여 항상 정확하게 관리가 되도록 노력해야 한다.</li>
                        <li>④ "회사"는 "회원"이 등록한 자료 내용에 오자, 탈자 또는 사회적 통념에 어긋나는 문구와 내용이 있을 경우 이를 언제든지 수정할 수 있다.</li>
                        <li>⑤ "회원"이 등록한 자료로 인해 타인(또는 타법인)으로부터 허위사실 및 명예훼손 등으로 삭제 요청이 접수된 경우 "회사"는 "회원"에게 사전 통지 없이 본 자료를 삭제할 수 있으며 삭제 후 메일 등의 방법으로 통지할 수 있다.</li>
                    </ol>
                </dd>
                <dt>제16조 (자료 내용의 활용 및 취급)</dt>
                <dd>
                    <ol>
                        <li>① "회원"이 선택하거나 입력한 정보는 취업 및 관련 동향의 통계 자료로 구성, 활용될 수 있으며 그 자료는 매체를 통한 언론 배포 또는 제휴사에게 제공될 수 있다. 단, 개인을 식별할 수 있는 형태가 아니어야 한다.</li>
                        <li>② '사이트'에서 정당한 절차를 거쳐 기업회원, 서치펌회원이 열람한 "회원"의 이력서 정보는 해당 기업의 인사자료이며 이에 대한 관리 권한은 해당 기업의 정책에 의한다.</li>
                        <li>③ "회사"는 '사이트'의 온라인 입사지원 시스템을 통해 지원한 "회원"의 이력서 열람 여부 및 기업회원이 제공한 채용정보에 입사지원한 구직자들의 각종 통계데이터를 "회원"에게 제공할 수 있다.</li>
                    </ol>
                </dd>
                <dt>제17조 ("회사"의 의무)</dt>
                <dd>
                    <ol>
                        <li>① "회사"는 본 약관에서 정한 바에 따라 계속적, 안정적으로 서비스를 제공할 수 있도록 최선의 노력을 다해야 한다.</li>
                        <li>② "회사"는 서비스와 관련한 "회원"의 불만사항이 접수되는 경우 이를 즉시 처리하여야 하며, 즉시 처리가 곤란한 경우에는 그 사유와 처리일정을 서비스 화면 또는 기타 방법을 통해 동 "회원"에게 통지하여야 한다.</li>
                        <li>③ "회사"는 유료 결제와 관련한 결제 사항 정보를 1년 이상 보존한다. 다만 회원 자격이 없는 회원은 예외로 한다.</li>
                        <li>④ 천재지변 등 예측하지 못한 일이 발생하거나 시스템의 장애가 발생하여 서비스가 중단될 경우 이에 대한 손해에 대해서는 "회사"가 책임을 지지 않는다. 다만 자료의 복구나 정상적인 서비스 지원이 되도록 최선을 다할 의무를 진다.</li>
                        <li>⑤ "회원"의 자료를 본 서비스 이외의 목적으로 제3자에게 제공하거나 열람시킬 경우 반드시 "회원"의 동의를 얻어야 한다.</li>
                    </ol>
                </dd>
                <dt>제18조 ("회원"의 의무)</dt>
                <dd>
                    <ol>
                        <li>① "회원"은 관계법령과 본 약관의 규정 및 기타 "회사"가 통지하는 사항을 준수하여야 하며, 기타 "회사"의 업무에 방해되는 행위를 해서는 안 된다.</li>
                        <li>② "회원"이 신청한 유료서비스는 등록 또는 신청과 동시에 "회사"와 채권, 채무 관계가 발생하며, "회원"은 이에 대한 요금을 지정한 기일 내에 납부하여야 한다.</li>
                        <li>③ "회원"이 결제 수단으로 신용카드를 사용할 경우 비밀번호 등 정보 유실 방지는 "회원" 스스로 관리해야 한다. 단, 사이트의 결함에 따른 정보유실의 발생에 대한 책임은 "회원"의 의무에 해당하지 아니한다.</li>
                        <li>④ "회원"은 서비스를 이용하여 얻은 정보를 "회사"의 사전동의 없이 복사, 복제, 번역, 출판, 방송 기타의 방법으로 사용하거나 이를 타인에게 제공할 수 없다.</li>
                        <li>
                            ⑤ "회원"은 본 서비스를 건전한 취업 및 경력관리 이외의 목적으로 사용해서는 안되며 이용 중 다음 각 호의 행위를 해서는 안 된다.
                            <ol>
                                <li>1. 다른 회원의 아이디를 부정 사용하는 행위</li>
                                <li>2. 범죄행위를 목적으로 하거나 기타 범죄행위와 관련된 행위</li>
                                <li>3. 타인의 명예를 훼손하거나 모욕하는 행위</li>
                                <li>4. 타인의 지적재산권 등의 권리를 침해하는 행위</li>
                                <li>5. 해킹행위 또는 바이러스의 유포 행위</li>
                                <li>6. 타인의 의사에 반하여 광고성 정보 등 일정한 내용을 계속적으로 전송하는 행위</li>
                                <li>7. 서비스의 안정적인 운영에 지장을 주거나 줄 우려가 있다고 판단되는 행위</li>
                                <li>8. 사이트의 정보 및 서비스를 이용한 영리 행위</li>
                                <li>9. 그밖에 선량한 풍속, 기타 사회질서를 해하거나 관계법령에 위반하는 행위</li>
                            </ol>
                        </li>
                    </ol>
                </dd>
                <dt>제19조 ("회원"의 가입해지/서비스중지/자료삭제)</dt>
                <dd>
                    <ol>
                        <li>① "회원"은 언제든지 회원탈퇴 또는 이력서 등록을 해지하기 위해 고객센터 또는 회원탈퇴 메뉴 등을 통하여 이용계약 해지 신청을 할 수 있으며, "회사"는 관련법 등이 정하는 바에 따라 이를 처리한다.</li>
                        <li>
                            ② 다음의 사항에 해당하는 경우 "회사"는 사전 동의없이 가입해지나 서비스 중지, 이력서 삭제 조치를 취할 수 있다.
                            <ol>
                                <li>1. 회원의 의무를 성실하게 이행하지 않았을 때</li>
                                <li>2. 규정한 유료서비스 이용 요금을 납부하지 않았을 때</li>
                                <li>3. 본 서비스 목적에 맞지 않는 분야에 정보를 활용하여 사회적 물의가 발생한 때</li>
                                <li>4. 회원이 등록한 정보의 내용이 사실과 다르거나 조작되었을 때</li>
                                <li>5. 본 서비스와 관련하여 회사 또는 제3자의 명예를 훼손하였을 때</li>
                                <li>6. 기타 위 각호에 준하는 사유가 발생하였을 때</li>
                            </ol>
                        </li>
                        <li>③ "회원"이 유료서비스를 이용하는 중 "회사"의 책임에 의해 정상적인 서비스가 제공되지 않을 경우 "회원"은 본 서비스의 해지를 요청할 수 있으며 "회사"는 기간의 정함이 있는 유료서비스의 경우에는 해지일까지 이용일수를 1일기준금액으로 계산하여 이용금액을 공제후 환급하고, 이용 건수의 정함이 있는 유료서비스의 경우에는 기 사용분을 1건기준금액으로 계산하여 이용금액을 공제후 환급한다.</li>
                        <li>④ "회사"는 회원 가입이 해지된 경우에는 개인정보처리방침 중, 04.개인정보의 보유 및 이용기간 규정에 따른다.</li>
                        <li>⑤ 개인정보보호를 위하여 "회원"이 선택한 개인정보 보유기간(1년, 3년, 회원탈퇴시) 동안 "사이트"를 이용하지 않은 경우, "아이디"를 "휴면계정"으로 분리하여 해당 계정의 이용을 중지할 수 있다. 이 경우 "회사"는 "휴면계정 처리 예정일"로부터 30일 이전에 해당사실을 전자메일, 서면, SMS 중 하나의 방법으로 사전통지하며 "회원"이 직접 본인확인을 거쳐, 다시 "사이트" 이용 의사표시를 한 경우에는 "사이트" 이용이 가능하다. "휴면계정"으로 분리 보관된 개인정보는 5년간 보관 후 지체없이 파기한다. </li>
                    </ol>
                </dd>
                <dt>제20조 (손해배상)</dt>
                <dd>
                    <ol>
                        <li>① "회사"가 이 약관의 규정을 위반한 행위로 "회원"에게 손해를 입히거나 기타 "회사"가 제공하는 모든 서비스와 관련하여 "회사"의 책임 있는 사유로 인해 "회원"에게 손해가 발생한 경우 "회사"는 그 손해를 배상하여야 한다.</li>
                        <li>② "회사"는 책임 있는 사유로 제공한 정보가 사실과 달라 "회원"이 손해를 입었을 경우에 "회사"는 그 손해를 배상하여야 한다.</li>
                        <li>③ "회원"이 이 약관의 규정을 위반한 행위로 "회사" 및 제3자에게 손해를 입히거나 "회원"의 책임 있는 사유에 의해 "회사" 및 제3자에게 손해를 입힌 경우에는 "회원"은 그 손해를 배상하여야 한다.</li>
                        <li>④ 타 회원(개인회원, 기업회원, 서치펌회원 모두 포함)의 귀책사유로 "회원"의 손해가 발생한 경우 "회사"는 이에 대한 배상 책임이 없다.</li>
                    </ol>
                </dd>
                <dt>제21조 (양도 금지)</dt>
                <dd>
                    "회원"의 서비스 받을 권리는 제3자에게 양도, 대여, 증여 등으로 사용할 수 없다.
                </dd>
                <dt>제22조 (이용요금 오류의 조정)</dt>
                <dd>
                    "회사"는 이용요금과 관련하여 오류가 있는 경우에 "회원"의 요청, 또는 "회사"의 사전 통지에 의하여 다음에 해당하는 조치를 취한다.
                    <ol>
                        <li>1. 과다납입한 요금에 대하여는 그 금액을 반환한다. 다만, "회원"이 동의할 경우 다음 달에 청구할 요금에서 해당 금액만큼을 감하여 청구한다.</li>
                        <li>2. 요금을 반환받아야 할 "회원"이 요금체납이 있는 경우에는 반환해야 할 요금에서 이를 우선 공제하고 반환한다.</li>
                        <li>3. "회사"는 과소청구액에 대해서는 익월에 합산청구한다.</li>
                    </ol>
                </dd>
                <dt>제23조 ("회원"의 개인정보보호)</dt>
                <dd>
                    "회사"는 "회원"의 개인정보보호를 위하여 노력해야 한다. "회원"의 개인정보보호에 관해서는 정보통신망이용촉진 및 정보보호 등에 관한 법률, 개인정보보호법에 따르고, "사이트"에 "개인정보처리방침"을 고지한다..
                </dd>
                <dt>제24조 (신용정보의 제공 활용 동의)</dt>
                <dd>
                    <ol>
                        <li>① "회사"가 회원가입과 관련하여 취득한 "회원"의 개인신용정보를 타인에게 제공하거나 활용하고자 할 때에는 신용정보의 이용 및 보호에 관한 법률 제23조의 규정에 따라 사전에 그 사유 및 해당기관 또는 업체명 등을 밝히고 해당 "회원"의 동의를 얻어야 한다.</li>
                        <li>② 본 서비스와 관련하여 "회사"가 "회원"으로부터 신용정보의 이용 및 보호에 관한 법률에 따라 타인에게 제공 활용에 동의를 얻은 경우 "회원"은 "회사"가 신용정보 사업자 또는 신용정보 집중기관에 정보를 제공하여 "회원"의 신용을 판단하기 위한 자료로 활용하거나, 공공기관에서 정책자료로 활용되도록 정보를 제공하는 데 동의한 것으로 간주한다.</li>
                    </ol>
                </dd>
                <dt>제25조 (분쟁의 해결)</dt>
                <dd>
                    <ol>
                        <li>① "회사"와 "회원"은 서비스와 관련하여 발생한 분쟁을 원만하게 해결하기 위하여 필요한 모든 노력을 하여야 한다.</li>
                        <li>② 전항의 노력에도 불구하고, 동 분쟁에 관한 소송은 "회사"의 주소지 관할법원으로 한다.</li>
                    </ol>
                </dd>
                <dt>부칙</dt>
                <dd>
                    이 약관은 2020년 9월 3일부터 시행한다.
                </dd>
            </dl>
        </div>
    </div>
    <div class="user_join_agree agrSelect">
        <input type="checkbox" name="agree" id="agreeChk_1" value="on" data-required="1"><label for="agreeChk_1"><span>[필수]</span> 개인정보 수집 및 이용 동의</label>
        <div class="toggle_terms"><a href="#">내용보기<span class=""></span></a></div>
        <div class="agree_terms">
            알바의 민족 서비스 이용을 위해 아래와 같이 개인정보를 수집 및 이용합니다. <br>동의를 거부할 권리가 있으며, 동의 거부 시 알바의 민족 회원서비스 이용이 불가합니다.
            <table class="agree-table">
                <colgroup>
                    <col width="33%">
                    <col width="34%">
                    <col width="33%">
                </colgroup>
                <thead>
                    <tr>
                        <th>목적</th>
                        <th>항목</th>
                        <th>보유 및 이용기간</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>본인여부 확인, 계약이행 및 약관변경 등의 고지를 위한 연락, 본인의사확인 및 민원 등의 고객불만처리</td>
                        <td>이름, 아이디, 비밀번호, 휴대폰번호, 이메일</td>
                        <td rowspan="2">회원 탈퇴 시 즉시 파기</td>
                    </tr>
                    <tr>
                        <td>공모전 정보 등록자 확인 및 고객불만 처리</td>
                        <td>담당자명, 이메일, 전화번호</td>
                    </tr>
                    <tr>
                        <td>입사지원 및 이력서 공개 등 취업활동 서비스 제공</td>
                        <td>이름, 생년월일, 성별, 휴대폰번호, 학력사항 또는 경력사항, 이메일, 전화번호, 주소, 홈페이지, 사진, 인턴·대외활동, 교육이수, 자격증, 수상, 해외경험, 어학, 포트폴리오, 취업우대·병역(보훈대상, 취업보호대상, 고용지원금대상, 장애, 병역), 자기소개서</td>
                        <td>이력서 삭제 또는 회원 탈퇴 시 즉시 파기</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="user_join_agree agrSelect">
        <input type="checkbox" name="agree" id="agreeChk_3" value="on"><label for="agreeChk_3"><span class="select">[선택]</span> 개인정보 수집 및 이용 동의</label>
        <div class="toggle_terms"><a href="#">내용보기<span class=""></span></a></div>
        <div class="agree_terms">
            <dl>
                <dt>1. 수집하는 개인정보 항목 및 이용 목적</dt>
                <dd>
                    <ol>
                        <li>
                            1) 이력서 등록 시
                            <p>- 수집목적 : 이력서 작성</p>
                            <p>- 수집항목 : 취업우대사항(보훈대상, 취업보호대상, 장애여부, 병역사항, 고용지원금대상)</p>
                        </li>
                    </ol>
                </dd>
                <dt>2. 개인정보의 보유 및 이용기간</dt>
                <dd>
                    회원탈퇴를 요청하거나 개인정보의 수집 및 이용에 대한 동의를 철회하는 경우, 수집 및 이용목적이 달성되거나 이용기간이 종료한 경우 개인정보를 지체 없이 파기합니다. 단, 상법 등 관계법령의 규정에 의하여 보존할 필요가 있는 경우 법령에서 규정한 보존기간 동안 거래내역과 최소한의 기본정보를 보유합니다.
                </dd>
            </dl>
        </div>
    </div>
    <div class="user_join_agree agrSelect">
        <input type="checkbox" name="agree" id="agreeChk_2" value="on"><label for="agreeChk_2"><span class="select">[선택]</span> 광고성 정보 이메일/SMS 수신 동의 <br><span class="promotion_type">(알바 뉴스레터, 소식 및 광고메일, 휴대폰 알림)</span></label>
    <hr>
        <div class="toggle_terms">
            <a href="#">내용보기<span class=""></span></a>
        </div>
        <div class="agree_terms">
            <dl>
                <dt>1. 수집 및 이용 목적</dt>
                <dd>회원이 수집 및 이용에 동의한 개인정보를 활용하여, 전자적 전송매체(이메일/SMS 등 다양한 전송매체)를 통해 서비스에 대한 개인 맞춤형 광고 정보(뉴스레터, 소식 및 광고메일, 휴대폰 알림)를 전송할 수 있습니다.</dd>
                <dt>2. 수집하는 개인정보 항목</dt>
                <dd>필수 동의사항에서 개인정보 수집 및 이용에 동의한 항목</dd>
                <dt>3. 보유 및 이용기간 </dt>
                <dd>
                    회원탈퇴를 요청하거나 개인정보의 수집 및 이용에 대한 동의를 철회하는 경우, 수집 및 이용목적이 달성되거나 이용기간이 종료한 경우 개인정보를 지체 없이 파기합니다.<br>
                    단, 상법 등 관계법령의 규정에 의하여 보존할 필요가 있는 경우 법령에서 규정한 보존기간 동안 거래내역과 최소한의 기본정보를 보유합니다.
                </dd>
                <dt>4. 수신동의 거부 및 철회방법 안내</dt>
                <dd>
                    본 동의는 거부하실 수 있습니다. 다만 거부 시 동의를 통해 제공 가능한 각종 혜택, 이벤트 안내를 받아보실 수 없습니다.
                    본 수신동의를 철회하고자 할 경우에는 뉴스레터·문자수신 설정 페이지에서 수신여부를 변경하실 수 있습니다.
                </dd>
            </dl>
        </div>
    </div>
</div>
	
	
	
<form id="updateForm" action="/member/memberUpdate" method="post">
	<table>
		<tr>
		<th><label for="userId">아이디</label></th>
		<td><input type="text" id="userId" name="userId"  placeholder="6~50자 영문, 숫자" maxlength="50" required>
		<button type="button" class="btn3" id="idCheck">중복확인</button>
		<span id="idCmt" class="cmt"></span></td>
		</tr>
		<tr>
		<th><label for="userPass" placeholder="8~16자 영문, 숫자, 특수문자">비밀번호</label></th>
		<td><input type="password" id="userPass" required><span id="pwCmt" class="cmt"></span></td>
		</tr>
		<tr>
		<th>비밀번호 확인</th>
		<td><input type="password" id="pwChk"><span id="pwChkCmt" class="cmt"></span></td>
		</tr>
		<tr>
		<th><label for="userName">이름</label></th>
		<td>
		<!-- maxlengh: 최대 입력 글자수, size: 화면에 보이는 최대글자수 -->
		<input type="text" id="userName" name="userName" maxlength="50" size = "10" required>
		<span id="nmCmt" class="cmt"></span>
		</td>
		</tr>
		<tr>
		<th>주민등록번호</th>
		<td>
		<input type="text" id="birthNum" placeholder="예:931010" maxlength="6" size="6" required> -
		<input type="text" id="genderNum" maxlength="1" size = "1" required>●●●●●●
		<span id="gdCmt" class="cmt"></span>
		</td>
		</tr>
		<tr>
		<th>이메일</th>
		<td>
		<input type="text" id = "email_1" name="email_1" maxlength="30" required>@
		<input type="text" id = "email_2" name="email_2" maxlength="30" required disabled>
		</td>
		<td>
		<select id = "email_3" name="email_3">
			<option value="1">직접입력</option> 
			<option value="naver.com" selected>naver.com</option> 
			<option value="hanmail.net">hanmail.net</option> 
			<option value="hotmail.com">hotmail.com</option> 
			<option value="gmail.com">gmail.com</option> 
			<option value="nate.com">nate.com</option> 
			<option value="daum.net">daum.net</option> 
			<option value="yahoo.co.kr">yahoo.co.kr</option> 
			<option value="dreamwiz.com">dreamwiz.com</option> 
		</select>
		</td>
		</tr>
		<tr>
		<th>휴대폰번호</th>
		<td>
		<select id = "phone1" name="phone1" style="width:150px;">
			<option value="010" selected>010</option> 
			<option value="011">011</option> 
			<option value="016">016</option> 
			<option value="017">017</option> 
			<option value="018">018</option> 
			<option value="019">019</option> 
		</select>
		- <input type="text" name="phone2" id="phone2"  placeholder="0000" maxlength="4" size = "4" required> -
		<input type="text" name="phone3" id="phone3"  placeholder="0000" maxlength="4" size = "4" required>
		<span id="pn2Cmt" class="cmt"></span>
		<span id="pn3Cmt" class="cmt"></span>
		</td>
		</tr>
	</table>
<div class="btngroup">
<button class="btn1" type="button" id="submit">회원가입</button>
<button class="cancel btn2" type="button">취소</button>
</div>
</form>
</section>
	<!-- 공통푸터 템플릿 -->
<c:import url="/WEB-INF/views/template/footer.jsp"/>
</body>
</html>