// 날짜 조회 버튼
let dateInputBtn = document.getElementById('date_input_btn');

//date 객체 선언
let date = new Date();

// 년도 입력 <input>
let yearInput = document.getElementById('yearInput');

// 월 입력 <input>
let monthInput = document.getElementById('monthInput');

//년&월 입력칸에 현재 날짜 값 넣기(년)
yearInput.value = date.getFullYear();

//년&월 입력칸에 현재 날짜 값 넣기(년)
monthInput.value = date.getMonth() + 1;

// 년도 & 월에 맞는 data 가져오는 event
dateInputBtn.onclick = () => {
    console.log(yearInput.value + " : " + monthInput.value);
    // ajax 코드 필요
}

//ajax를 통해 GET method로 보낼 path
// 구직 & 면접
let getNeedChartPath = "/almin/careers/needchart/" + userId + "?year=" + date.getFullYear() + "&month=" + (date.getMonth() + 1);
console.log("getNeedChartPath : " + getNeedChartPath);

// 근무
let getWorkChartPath = "/almin/careers/workchart/" + userId + "?year=" + date.getFullYear() + "&month=" + (date.getMonth() + 1);
console.log("getWorkChartPath : " + getWorkChartPath);


// 좌측 사이드 버튼을 클릭하면 chart 화면으로 전환
careerCalButn.onclick = () => {
	calDiv.style.display = 'none';
	chartDiv.style.display = 'block';
	// topCalTitle.innerText = "우리의 민족!!! 칠갑산님의 MyChart";
	
	// 구직 data 가져오기
	sendRequest("GET", getNeedChartPath, null, afterNeedChart);
	
	// 근무 data 가져오기
	// sendRequest("GET", getWorkChartPath, null, afterWorkChart);
}
// ======================================================================================================
// 구직 & 면접 횟수를 담을 배열
let needchartArr = [];

// 구직 data ajax callback function
function afterNeedChart() {
	if (httpRequest.readyState === 4) {
		if (httpRequest.status === 200) {
			let needCalChartData = JSON.parse(httpRequest.responseText);
			console.log(needCalChartData);
			for (var i = 0; i < needCalChartData.length; i++) {
				needchartArr[i] = needCalChartData[i].COUNT_TYPE;
			}
			sendRequest("GET", getWorkChartPath, null, afterWorkChart);
		}
	}	
}
//======================================================================================================
// 근무 data 중 근무일수를 담을 배열
let workChartDay = [];

//근무 data 중 매장명을 담을 배열
let workChartTitle = [];

// 그래프 배경색
let backgroundColorArr = []

//그래프 border 색
let borderColorArr = []

// 근무 data ajax callback function
function afterWorkChart() {
	if (httpRequest.readyState === 4) {
		if (httpRequest.status === 200) {
			let workCalChartData = JSON.parse(httpRequest.responseText);
			console.log(workCalChartData);
			
			// 근무 chart에 data 및 색깔널기
			for (var i = 0; i < workCalChartData.length; i++) {
				workChartDay[i] = workCalChartData[i].WORKDAY;
				workChartTitle[i] = workCalChartData[i].WORK_TITLE;
				
				let colorTemp = changeRGBA();
				// 그래프 배경 색
				backgroundColorArr[i] = colorTemp;
				// 그래프 border
				borderColorArr[i] = colorTemp.replace(",0.2)", ")");
			}
			
			let tabelEle = document.getElementById('moneyTabelReal');
			
			if(workCalChartData.length != 0) { // 근무 데이터가 있을때만 테이블 동적 생성
				// 월급 테이블 계산
				for (var i = 0; i < workCalChartData.length; i++) {
					// <tr>
					let trEle = document.createElement('tr');
					tabelEle.appendChild(trEle);
	
					// 매장명이 담기는 <td>
					let firstTdEle = document.createElement('td');
					firstTdEle.setAttribute('class', 'firstTd');
					firstTdEle.innerText = workCalChartData[i].WORK_TITLE;
					trEle.appendChild(firstTdEle);
	
					// 월급이 담기는 <td>
					let secondTdEle = document.createElement('td');
					secondTdEle.setAttribute('class', 'secondTd');
					secondTdEle.innerText = workCalChartData[i].WORK_TIME * workCalChartData[i].WORKDAY * workCalChartData[i].WORK_MONEY;
					trEle.appendChild(secondTdEle);
				}
			}
			
			
			// TODO 마지막 ajax callback function에서 해야함
			loadChart();
		}
	}	
}
//======================================================================================================

// window.onload = function () { onload 시작
function loadChart() {

//// 년&월 입력칸에 현재 날짜 값 넣기(년)
//yearInput.value = date.getFullYear();
//
////년&월 입력칸에 현재 날짜 값 넣기(년)
//monthInput.value = date.getMonth() + 1;

//근무 변수
const workCt = document.getElementById('workChart');

// 구직 변수
const needCt = document.getElementById('needChart');

// 경력 변수
const careerCt = document.getElementById('careerChart');
//============================================================================================================
	// 구직 chart
	const needChart = new Chart(needCt, {
	type: 'pie',
	data: {
	    labels: ['면접 횟수', '지원 횟수'],
	    datasets: [{
	        // data: [12, 19, 3, 5, 2, 3],
	        data: needchartArr,
	        backgroundColor: [
	            'rgba(255, 99, 132, 0.2)',
	            'rgba(54, 162, 235, 0.2)'
	            // 'rgba(255, 206, 86, 0.2)'
	            // 'rgba(75, 192, 192, 0.2)',
	            // 'rgba(153, 102, 255, 0.2)',
	            // 'rgba(255, 159, 64, 0.2)'
	        ],
	        borderColor: [
	            'rgba(255, 99, 132, 1)',
	            'rgba(54, 162, 235, 1)'
	            // 'rgba(255, 206, 86, 1)'
	            // 'rgba(75, 192, 192, 1)',
	            // 'rgba(153, 102, 255, 1)',
	            // 'rgba(255, 159, 64, 1)'
	        ],
	        // , borderWidth: 1 // 그래프 바깥선
	    	hoverOffset: 10
	    }]
	},
	options: {
	    plugins: {
	        legend: {
	            position: 'top',
	        },
	        title: {
	            display: true,
	            text: '지원 & 면접 횟수'
	        }
	    },
	    scales: {
	        y: {
	            beginAtZero: true,
	            position: 'none'
	        }
	    }
	    // , events : () => {
	    //     alert(123);
	    // } ajax 사용
	}
	});
//============================================================================================================
	// 근무 chart
	const workChart = new Chart(workCt, {
	type: 'doughnut',
	data: {
	    // labels: ['Red', 'Blue', 'Yellow', 'Green'],
	    labels: workChartTitle,
	    datasets: [{
	        data: workChartDay, // 알바별 월 근무 일수
	        // data: [32, 19, 3, 5], // 알바별 월 알바비 총량
	        // data: [32, 19, 3, 5, 2, 3],
	        backgroundColor: backgroundColorArr,
	        borderColor: borderColorArr,
	        borderWidth: 3, // 그래프 바깥 경계
	        hoverOffset: 10 // 그래프 마우스 hover시
	    }]
	},
	options: {
	    plugins: {
	        legend: {
	            position: 'top',
	        },
	        title: {
	            display: true,
	            text: '근무 일수'
	        }
	    },
	    scales: {
	        y: {
	            beginAtZero: true,
	            position: 'none'
	        }
	    },
	    cutout: "60%", // 도넛 원형 크기 설정
	    borderRadius: 5 // 그래프 끝 radius 설정
	}
	});
// ============================================================================================================
	// 경력 chart
	const careerChart = new Chart(careerCt, {
	type: 'pie',
	data: {
	    labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
	    datasets: [{
	        label: '# of Votes',
	        data: [32, 19, 3, 5, 2, 3],
	        backgroundColor: [
	            'rgba(255, 99, 132, 0.2)',
	            'rgba(54, 162, 235, 0.2)',
	            'rgba(255, 206, 86, 0.2)',
	            'rgba(75, 192, 192, 0.2)',
	            'rgba(153, 102, 255, 0.2)',
	            'rgba(255, 159, 64, 0.2)'
	        ],
	        borderColor: [
	            'rgba(255, 99, 132, 1)',
	            'rgba(54, 162, 235, 1)',
	            'rgba(255, 206, 86, 1)',
	            'rgba(75, 192, 192, 1)',
	            'rgba(153, 102, 255, 1)',
	            'rgba(255, 159, 64, 1)'
	        ],
	        borderWidth: 1,
	        hoverOffset: 10
	    }]
	},
	options: {
	    scales: {
	        // yAxes : [{ // y축 그래프 범위
	        //     ticks : {
	        //         min : -10,
	        //         max : 100,
	        //         stepSize : 5,
	        //         position: 'none'
	        //     }
	        // }],
	        y: {
	            beginAtZero: true,
	            position: 'none'
	        }
	    },
	    plugins: {
	        legend: {
	            position: 'top'
	            // display: false // (label: '# of Votes') 지우기
	        },
	        title: {
	            display: true,
	            text: '경력'
	        }
	    }
	}
	});
}
// } onload 끝
// 색깔 랜덤 생성(그래프 배경 & border)
function changeRGBA() {
	// 0~255값을 랜덤으로 뽑아내서 각각의 변수 r,g,b 에 들어간다.
	let r = Math.round(Math.random() * 255); 
	let g = Math.round(Math.random() * 255);
	let b = Math.round(Math.random() * 255);
	 
	let random_color = "rgba(" + r + "," + g + "," + b + "," + 0.2 + ")";
	// let random_color = "rgb(" + r + "," + g + "," + b + ")";
	 
	return random_color;
}
