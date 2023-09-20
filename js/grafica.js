function Cargardatosgraf() {
    $.ajax({
      url: '../contolador/grafica/controlador_grafica.php',
      type: 'GET'
    }).done(function(resp) {
      var data = JSON.parse(resp);
      var titulo = data.data.map(item=> item.insumo_nombre.toLowerCase());
      var cantidad = data.data.map(item=> item.insumo_stock);
      const areaChartCanvas = $('#areaChart');
      console.log(data,'Este es el titulo')
      const myChart = new Chart(areaChartCanvas, {
        type: 'bar',
        data: {
          labels: titulo,
          datasets: [{
            label: 'Insumo',
            data: cantidad,
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
            borderWidth: 1
          }]
        },
        options: {
          scales: {
            y: {
              beginAtZero: true
            }
          }
        }
      });
    })
}

function Cargardatosgraf2() {
    $.ajax({
      url: '../contolador/grafica/controlador_grafica2.php',
      type: 'GET'
    }).done(function(resp) {
      var data = JSON.parse(resp);
      var titulo = data.data.map(item=> item.medicamento_nombre.toLowerCase());
      var cantidad = data.data.map(item=> item.medicamento_stock);
      const areaChartCanvas = $('#areaChart2');
      console.log(data,'Este es el titulo')
      const myChart = new Chart(areaChartCanvas, {
        type: 'bar',
        data: {
          labels: titulo,
          datasets: [{
            label: 'Medicamento',
            data: cantidad,
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
            borderWidth: 1
          }]
        },
        options: {
          scales: {
            y: {
              beginAtZero: true
            }
          }
        }
      });
    })
}

