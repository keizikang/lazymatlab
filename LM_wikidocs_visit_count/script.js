// script.js
document.addEventListener('DOMContentLoaded', function() {
    // 날짜와 숫자를 설정합니다.
    const data = [
        { date: '2024-06-01', number: 10 },
        { date: '2024-06-02', number: 15 },
        { date: '2024-06-03', number: 7 },
        { date: '2024-06-04', number: 18 },
        { date: '2024-06-05', number: 1223 }
    ];

    // 날짜와 숫자를 HTML에 표시합니다.
    const dateElement = document.getElementById('date');
    const numberElement = document.getElementById('number');

    const latestData = data[data.length - 1];
    dateElement.textContent = '날짜: ' + latestData.date;
    numberElement.textContent = '숫자: ' + latestData.number;

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
                    type: 'category',
                    labels: data.map(entry => entry.date)
                },
                y: {
                    beginAtZero: true
                }
            }
        }
    });
});
