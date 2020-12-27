import consumer from "./consumer"
import Chart from "chart.js"

consumer.subscriptions.create("InventoriesChannel", {
  connected() {},
  disconnected() {},
  received(data) {
    if(data.type === "chart") { refreshChart(data.data); }
    if(data.type === "sales") { refreshSales(data.data); }
    if(data.type === "notifications") { refreshNotifications(data.data); }
    if(data.type === "select_inputs") {
      refreshSelectInputs(data.data.shoe_models, "shoe");
      refreshSelectInputs(data.data.store_names, "store");
    }
  }
});

function refreshSales(data){
  var elem = document.getElementById("sales")
  var result = ""
  data.forEach(element => {
    var badge = "";
    var arrow = "";
    if(element.trend === "up") {
      badge = "success";
      arrow = "<i class='fa fa-arrow-up ml-1'></i>"
    } else if (element.trend === "down") {
      badge = "danger";
      arrow = "<i class='fa fa-arrow-down ml-1'></i>"
    } else {
      badge = "primary"
    }
    result += `
    <a class="list-group-item list-group-item-action waves-effect">${element.shoe_model}
    <span class="badge badge-${badge} badge-pill pull-right">${element.percentage}%
      ${arrow}
    </span>
    </a>
    `
  });
  elem.innerHTML = result;
}

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

function refreshNotifications(data) {
  var elem = document.getElementById("notification")
  var result = ""
  data.forEach(element => {
    result += `
    <li class="list-group-item">${element}</li>
    `
  });
  elem.innerHTML = result;
}

function refreshSelectInputs(data, id) {
  var sel = document.getElementById(id);
  var selected_option = sel.options[sel.selectedIndex].text;
  var list = "";
  
  list += `<option value="">All</option>`;
  for(var i = 0; i < data.length; i++) {
    var selected = data[i] === selected_option ? "selected" : "";
    list += `<option ${selected} value='${data[i]}'>${data[i]}</option>`;
  }
  sel.innerHTML = list;
}




