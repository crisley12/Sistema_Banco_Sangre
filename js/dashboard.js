function dashboard() {
    $.ajax({
      url: '../contolador/dashboard/controlador_dashboard.php',
      type: 'POST'
    }).done(function(resp) {
      var data = JSON.parse(resp);
      document.getElementById('lbl_pacientes').innerHTML = data[0][0];
      document.getElementById('lbl_medico').innerHTML = data[0][1];
      document.getElementById('lbl_usuarios').innerHTML = data[0][2];
    })
  }

  function listar_citas_diarias(){
    $.ajax({
      url: '../contolador/dashboard/controlador_listar_citas_diarias.php',
      type: 'POST'
    }).done(function(resp) {
      var data = JSON.parse(resp);
      document.getElementById('lbl_citas').innerHTML = data[0][0];
      
    })
    
  }

  