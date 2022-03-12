import Chart from 'chart.js/auto';

const ctx = document.getElementById("myChart");
const result = document.getElementById("result")
const resultHash = JSON.parse(result.getAttribute('data-result'))

Chart.defaults.font.color = "#656765";
Chart.defaults.font.family = "'Zen Maru Gothic', sans-serif";
new Chart(ctx, {
  type: "radar",
  data: {
    labels: [
      "平静さ",
      "怒り",
      "喜び",
      "悲しみ",
      "元気さ",
    ],
    datasets: [
      {
        data: [resultHash.calm, resultHash.anger, resultHash.joy, resultHash.sorrow, resultHash.energy],
        fill: true,
        backgroundColor: "#f69c9f33",
        borderColor: "#f69c9f",
        pointBackgroundColor: "#f69c9f",
        pointBorderColor: "#fcfaf2",
        pointHoverBackgroundColor: "#fcfaf2",
        pointHoverBorderColor: "#f69c9f",
      },
    ],
  },
  options: {
    elements: {
      line: {
        borderWidth: 3,
      },
    },
    plugins: {
      legend: {
        display: false,
      },
    },
    scales: {
      r: {
        min: 0,
        max: 50,
      },
    },
  },
});
