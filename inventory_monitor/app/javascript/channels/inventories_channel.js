import consumer from "./consumer"
import Chart from "chart.js"
consumer.subscriptions.create("InventoriesChannel", {
  connected() {},
  disconnected() {},
  received(data) {
    if(data.type === "chart") { refreshChart(data.data); }
  }
});
function refreshChart(data) {
  if( window.myBar!==undefined) {
    window.myBar.destroy();
  }
  var dataset = data;
    window.myBar = new Chart(document.getElementById("bar-chart"), {
      type: 'scatter',
      data: {
        datasets: dataset
      },
      options: {
        lineTension: 0,
        title: {
          display: true,
          text: 'Shoe in hands over time'
        },
        legend: {
          display: false
        },
        hover: {
          mode: false
        },
        animation: {
          duration: 0
        },
        tooltips: {
          callbacks: {
            label: function(tooltipItem, data) {
              var dataset = data.datasets[tooltipItem.datasetIndex];
              var val = tooltipItem.value;
              return dataset.label + '-' + val;
            }
          }
        },
        states: {
          hover: {
            filter: {
              type: 'none',
            }
          },
        },
        scales:{
          xAxes: [{
            ticks: {
              display: false, //this removed the labels on the x-axis
            },
            gridLines: {
              display: false
            }
          }]
        }
      }
    });
}





