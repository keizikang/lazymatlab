// script.js
document.addEventListener('DOMContentLoaded', function() {
    // 날짜와 숫자를 설정합니다.
    const data = [
        { date: '2024-06-01', number: 10 },
        { date: '2024-06-02', number: 15 },
        { date: '2024-06-03', number: 7 },
        { date: '2024-06-04', number: 18 },
        { date: '2024-06-05', number: 12 }
    ];

    // 모든 날짜와 숫자를 HTML에 표시합니다.
    const dataListElement = document.getElementById('data-list');
    data.forEach(entry => {
        const listItem = document.createElement('li');
        listItem.textContent = `날짜: ${entry.date}, 숫자: ${entry.number}`;
        dataListElement.appendChild(listItem);
    });

    // 그래프를 생성합니다.
    const ctx = document.getElementById('myChart').getContext('2d');
    const chart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: data.map(entry => entry.date),
            datasets: [{
                label: '숫자',
                data: data.map(entry => entry.number),
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 2,
                fill: false
            }]
        },
        options: {
            scales: {
                x: {
                    type: 'time',
                    time: {
                        unit: 'day',
                        tooltipFormat: 'YYYY-MM-DD',
                        displayFormats: {
                            day: 'YYYY-MM-DD'
                        }
                    },
                    title: {
                        display: true,
                        text: '날짜'
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '숫자'
                    }
                }
            }
        }
    });
});
