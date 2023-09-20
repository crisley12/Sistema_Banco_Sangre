<?php
session_start();
if (!isset($_SESSION['S_IDUSUARIO'])) {
  header('location: ../Login/index.php');
}

?>

<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>BASANTRANFS/SISTEMA</title>
  <!-- Tell the browser to be responsive to screen width -->
  <link rel="shortcut icon" type="image/x-icon" href="../sangre.png">
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- Bootstrap 3.3.7 -->
  <link rel="stylesheet" href="../Plantilla/bower_components/bootstrap/dist/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="../Plantilla/bower_components/font-awesome/css/font-awesome.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="../Plantilla/bower_components/Ionicons/css/ionicons.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="../Plantilla/dist/css/AdminLTE.min.css">
  <!-- AdminLTE Skins. Choose a skin from the css/skins
folder instead of downloading all of them to reduce the load. -->
  <link rel="stylesheet" href="../Plantilla/dist/css/skins/_all-skins.min.css">
  <!-- chart -->
  <link rel="../Plantilla/plugins/chart.js/Chart.min.css">
  <!-- Morris chart -->
  <link rel="stylesheet" href="../Plantilla/bower_components/morris.js/morris.css">
  <!-- jvectormap -->
  <link rel="stylesheet" href="../Plantilla/bower_components/jvectormap/jquery-jvectormap.css">
  <!-- Date Picker -->
  <link rel="stylesheet" href="../Plantilla/bower_components/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css">
  <!-- Daterange picker -->
  <link rel="stylesheet" href="../Plantilla/bower_components/bootstrap-daterangepicker/daterangepicker.css">
  <!-- bootstrap wysihtml5 - text editor -->
  <link rel="stylesheet" href="../Plantilla/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">
  <link rel="stylesheet" href="../Plantilla/plugins/DataTable/datatables.min.css">
  <link rel="stylesheet" href="../Plantilla/plugins/select2/select2.min.css">
  <!-- fullCalendar -->

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

  <!-- Google Font -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">
</head>
<style>
  .Swal2-popup {
    font-size: 1.6rem !important;
  }
</style>

<body class="hold-transition skin-blue sidebar-mini">
  <div class="wrapper">

    <header class="main-header">
      <!-- Logo -->
      <a class="logo">
        <!-- logo for regular state and mobile devices -->
        <span class="logo-lg">CONSULTORIO</span>
      </a>
      <!-- Header Navbar: style can be found in header.less -->
      <nav class="navbar navbar-static-top">
        <!-- Sidebar toggle button-->
        <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
          <span class="sr-only">Toggle navigation</span>
        </a>

        <div class="navbar-custom-menu">
          <ul class="nav navbar-nav">
            <!-- Notifications: style can be found in dropdown.less -->
            <li class="dropdown notifications-menu">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">

              </a>
              <ul class="dropdown-menu">
                <li>
                  <!-- inner menu: contains the actual data -->
                  <ul class="menu">
                </li>
              </ul>
            </li>
          </ul>
          </li>
          <!-- Tasks: style can be found in dropdown.less -->
          <ul class="dropdown-menu">
            <ul class="menu">
            </ul>
          </ul>
          <!-- User Account: style can be found in dropdown.less -->
          <li class="dropdown user user-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <img id="img_nav" class="user-image" alt="User Image">
              <span class="hidden-xs"><?php echo $_SESSION['S_USER']; ?></span>
            </a>
            <ul class="dropdown-menu">
              <!-- User image -->
              <li class="user-header">
                <img id="img_subnav" class="img-circle" alt="User Image">

                <p>
                  <?php echo $_SESSION['S_USER']; ?>
                </p>
              </li>
              <!-- Menu Footer-->
              <li class="user-footer">
                <div class="pull-left">
                  <a href="#" onclick="AbrirModalEditarContra()" class="btn btn-default btn-flat">Cambiar contraseña</a>
                </div>
                <div class="pull-right">
                  <a href="../contolador/usuario/controlador_cerrar_session.php" class="btn btn-default btn-flat">Salir</a>
                </div>
              </li>
            </ul>
          </li>
          </ul>
        </div>
      </nav>
    </header>
    <!-- Left side column. contains the logo and sidebar -->
    <aside class="main-sidebar">
      <!-- sidebar: style can be found in sidebar.less -->
      <section class="sidebar">
        <!-- Sidebar user panel -->
        <div class="user-panel">
          <div class="pull-left image">
            <img id="img_lateral" class="img-circle" alt="User Image">
          </div>
          <div class="pull-left info">
            <p><?php echo $_SESSION['S_USER']; ?></p>
            <a href="#"><i class="fa fa-circle text-success"></i> En Linea</a>
          </div>
        </div>

        <!-- sidebar menu: : style can be found in sidebar.less -->
        <ul class="sidebar-menu" data-widget="tree">
          <li class="header" style="text-align:center">PANEL ADMINISTRATIVO</li>
          <li class="active treeview">
            <?php
            if ($_SESSION['S_ROL'] == 'ADMINISTRADOR') {

            ?>
              <!--ususario-->
              <header style="text-align:center">
                <a href="dashboard/vista_dashboard_listar.php" class="logo">
                  <i class="fa fa-github-alt"></i> <span class="logo-lg">INICIO</span>
                </a>
              </header>

              <a onclick="cargar_contenido('contenido_principal','paciente/vista_paciente_listar.php')" style="cursor:pointer">
                <i class="fa fa-user"></i> <span>Paciente</span>
                <span class="pull-right-container">
                </span>
              </a>
              <a onclick="cargar_contenido('contenido_principal','cita/vista_cita_listar.php')" style="cursor:pointer">
                <i class="fa fa-user-md"></i> <span>Cita</span>
                <span class="pull-right-container">
                </span>
              </a>
              <a onclick="cargar_contenido('contenido_principal','consulta_medica/vista_consulta_listar.php')" style="cursor:pointer">
                <i class="fa fa-stethoscope"></i> <span>Consulta Medica</span>
                <span class="pull-right-container">
                </span>
              </a>

              <a onclick="cargar_contenido('contenido_principal','medico/vista_medico_listar.php')" style="cursor:pointer">
                <i class="fa fa-user-md"></i> <span>Médico</span>
                <span class="pull-right-container">
                </span>
              </a>
              <a onclick="cargar_contenido('contenido_principal','usuario/vista_usuario_listar.php')" style="cursor:pointer">
                <i class="fa fa-users"></i> <span>Usuario</span>
                <span class="pull-right-container">
                </span>
              </a>
              <a onclick="cargar_contenido('contenido_principal','procedimiento/vista_procedimiento_listar.php')" style="cursor:pointer">
                <i class="fa fa-hourglass-3"></i> <span>Procedimientos</span>
                <span class="pull-right-container">
                </span>
              </a>
              <a onclick="cargar_contenido('contenido_principal','insumo/vista_insumo_listar.php')" style="cursor:pointer">
                <i class="fa fa-cubes"></i> <span>Insumo</span>
                <span class="pull-right-container">
                </span>
              </a>
              <a onclick="cargar_contenido('contenido_principal','medicamento/vista_medicamento_listar.php')" style="cursor:pointer">
                <i class="fa fa-medkit"></i> <span>Medicamento</span>
                <span class="pull-right-container">
                </span>
              </a>
              <a onclick="cargar_contenido('contenido_principal','especialidad/vista_especialidad_listar.php')" style="cursor:pointer">
                <i class="fa fa-gg"></i> <span>Especialidad</span>
                <span class="pull-right-container">
                </span>
              </a>
              <a onclick="cargar_contenido('contenido_principal','historial/vista_historial_listar.php')" style="cursor:pointer">
                <i class="fa fa-file-text-o"></i> <span>Historial Médico</span>
                <span class="pull-right-container">
                </span>
              </a>
              <a onclick="cargar_contenido('contenido_principal','restaurar/vista_restaurar_listar.php')" style="cursor:pointer">
                <i class="fa fa-history"></i> <span>Restaurar</span>
                <span class="pull-right-container">
                </span>
              </a>
              <a onclick="cargar_contenido('contenido_principal','auditoria/vista_auditoria_listar.php')" style="cursor:pointer">
                <i class="fa fa-television"></i> <span>Auditoria</span>
                <span class="pull-right-container">
                </span>
              </a>
              <a onclick="cargar_contenido('contenido_principal','donaciones/vista_donaciones_listar.php')" style="cursor:pointer">
                <i class="fa fa-plus-square"></i> <span>Donaciones</span>
                <span class="pull-right-container">
                </span>
              </a>

            <?php
            }
            ?>

            <?php
            if ($_SESSION['S_ROL'] == 'RECEPCIONISTA') {

            ?>
              <!-- /. CONTENIDO QUE VERA EL USUARIO SEGUN EL ROL -->
              <a onclick="cargar_contenido('contenido_principal','cita/vista_cita_listar.php')" style="cursor:pointer">
                <i class="fa fa-user-md"></i> <span>Cita</span>
                <span class="pull-right-container">

                </span>
              </a>
            <?php
            }
            ?>

            <?php
            if ($_SESSION['S_ROL'] == 'MEDICO') {

            ?>
              <!-- /. CONTENIDO QUE VERA EL USUARIO SEGUN EL ROL -->
              <a onclick="cargar_contenido('contenido_principal','paciente/vista_paciente_listar.php')" style="cursor:pointer">
                <i class="fa fa-user"></i> <span>Paciente</span>
                <span class="pull-right-container">

                </span>
              </a>
              <a onclick="cargar_contenido('contenido_principal','historial/vista_historial_listar.php')" style="cursor:pointer">
                <i class="fa fa-file-text-o"></i> <span>Historial Médico</span>
                <span class="pull-right-container">

                </span>
              </a>
            <?php
            }
            ?>
          </li>
        </ul>
      </section>
      <!-- /.sidebar -->
    </aside>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
      <!-- Content Header (Page header) -->

      <!-- Main content -->
      <div class="content">
        <div class="row">
          <input type="text" id="txtidprincipal" value="<?php echo $_SESSION['S_IDUSUARIO'] ?>" hidden>
          <input type="text" id="usuarioprincipal" value="<?php echo $_SESSION['S_USER'] ?>" hidden>
          <div class="row" id="contenido_principal">
            <div class="col-md-12">
              <div class="box box-warning box-solid">
                <div class="box-header with-border">
                  <h3 class="box-title">BIENVENIDO AL CONTENIDO PRINCIPAL</h3>
                  <div class="box-tools pull-right">
                    <button type="button" class="btn btn-box-tool" data-widget="collapse">
                    </button>
                  </div>
                  <!-- /.box-tools -->
                </div>
                <!-- /.box-header -->
                <div class="box-body">
                  CONTENIDO PRINCIPAL
                </div>

                <!-- /.box-body -->
              </div>

              <div class="content">
                <div class="container-fluid">
                  <div class="row">
                    <div class="col-lg-3 col-2">
                      <div class="small-box bg-purple">
                        <div class="inner">
                          <h3 id="lbl_pacientes">0<sup style="font-size:20px"></sup>
                          </h3>
                          <p>Pacientes</p>
                        </div>
                        <div class="icon">
                          <i class="ion-android-people"></i>
                        </div>
                      </div>
                    </div>

                    <div class="col-lg-3 col-2">
                      <div class="small-box bg-primary">
                        <div class="inner">
                          <h3 id="lbl_medico">0<sup style="font-size: 20px"></sup>
                          </h3>
                          <p>Medico</p>
                        </div>
                        <div class="icon">
                          <i class="ion-ios-pulse-strong"></i>
                        </div>
                      </div>
                    </div>

                    <div class="col-lg-3 col-2">
                      <div class="small-box bg-yellow">
                        <div class="inner">
                          <h3 id="lbl_usuarios">0<sup style="vertical-align: inherit;"><sup style="vertical-align: inherit;"></sup></h3>
                          <p>Usuarios</p>
                        </div>
                        <div class="icon">
                          <i class="ion ion-person-add"></i>
                        </div>
                      </div>
                    </div>

                    <div class="col-lg-3 col-2">
                      <div class="small-box bg-red">
                        <div class="inner">
                          <h3 id="lbl_citas">0<sup style="vertical-align: inherit;"><sup style="vertical-align: inherit;"></sup></h3>
                          <p>Citas</p>
                        </div>
                        <div class="icon">
                          <i class="ion ion-pie-graph"></i>
                        </div>
                      </div>
                    </div>

                    <!-- AREA CHART -->

                    <section class="content">
                      <div class="row">
                        <div class="col-md-6">
                          <div class="box box-primary">
                            <div class="box-header with-border">
                              <div class="box-tools pull-right">
                                <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
                                </button>
                              </div>
                            </div>
                            <div class="box-body">
                              <div class="chart">
                                <canvas id="areaChart" style="height: 276px; width: 564px;" height="552" width="1128"></canvas>
                              </div>
                            </div>
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="box box-primary">
                            <div class="box-header with-border">
                              <div class="box-tools pull-right">
                                <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
                                </button>
                              </div>
                            </div>
                            <div class="box-body">
                              <div class="chart">
                                <canvas id="areaChart2" style="height: 276px; width: 564px;" height="552" width="1128"></canvas>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </section>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>


    <div class="modal fade" id="modal_editar_contra" role="dialog">
      <div class="modal-dialog modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title"><b>Modificar Contraseña</b></h4>
          </div>
          <div class="modal-body">
            <div class="col-lg-12">
              <input type="text" id="txtcontra_bd" hidden>
              <label for="">Contraseña Actual</label>
              <input type="password" class="form-control" id="txtcontraactual_editar" placeholder="Contraseña Actual"><br>
            </div>
            <div class="col-lg-12">
              <label for="">Nueva Contraseña</label>
              <input type="password" class="form-control" id="txtcontranul_editar" placeholder="Nueva Contraseña"><br>
            </div>
            <div class="col-lg-12">
              <label for="">Repetir Contraseña</label>
              <input type="password" class="form-control" id="txtcontrare_editar" placeholder="Repetir Contraseña"><br>
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-primary" onclick="Editar_Contra()"><i class="fa fa-check"><b>&nbsp;Modificar</b></i></button>
            <button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-close"><b>&nbsp;Cerrar</b></i></button>
          </div>
        </div>
      </div>
    </div>

    <script src="../Plantilla/bower_components/jquery/dist/jquery.min.js"></script>
    <!-- jQuery UI 1.11.4 -->
    <script src="../Plantilla/bower_components/jquery-ui/jquery-ui.min.js"></script>
    <!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
    <!-- Bootstrap 3.3.7 -->
    <script src="../Plantilla/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
    <!-- ChartJS -->
    <script src="chart.min.js"></script>
    <!-- Morris.js charts -->
    <script src="../Plantilla/bower_components/raphael/raphael.min.js"></script>
    <!-- Sparkline -->
    <script src="../Plantilla/bower_components/jquery-sparkline/dist/jquery.sparkline.min.js"></script>
    <!-- jvectormap -->
    <script src="../Plantilla/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="../Plantilla/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <!-- jQuery Knob Chart -->
    <script src="../Plantilla/bower_components/jquery-knob/dist/jquery.knob.min.js"></script>
    <!-- daterangepicker -->
    <script src="../Plantilla/bower_components/moment/min/moment.min.js"></script>
    <script src="../Plantilla/bower_components/bootstrap-daterangepicker/daterangepicker.js"></script>
    <!-- datepicker -->
    <script src="../Plantilla/bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
    <!-- Bootstrap WYSIHTML5 -->
    <script src="../Plantilla/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
    <!-- Slimscroll -->
    <script src="../Plantilla/bower_components/jquery-slimscroll/jquery.slimscroll.min.js"></script>
    <!-- FastClick -->
    <script src="../Plantilla/bower_components/fastclick/lib/fastclick.js"></script>
    <!-- AdminLTE App -->
    <script src="../Plantilla/dist/js/adminlte.min.js"></script>
    <!-- AdminLTE dashboard demo (This is only for demo purposes) -->
    <!-- AdminLTE for demo purposes -->
    <script src="../Plantilla/dist/js/demo.js"></script>
    <script src="../Plantilla/plugins/DataTable/datatables.min.js"></script>
    <script src="../Plantilla/plugins/select2/select2.min.js"></script>
    <script src="../Plantilla/plugins/sweetalert2/sweetalert2.js"></script>
    <script src="../js/usuario.js"></script>
    <script src="../js/grafica.js"></script>
    <script src="../js/dashboard.js"></script>
    <script>
      var idioma_espanol = {
        select: {
          rows: "%d fila seleccionada"
        },
        "sProcessing": "Procesando...",
        "sLengthMenu": "Mostrar_Menu_registros",
        "sZeroRecords": "No se encontraon resultados",
        "sEmptyTable": "Ningún dato disponible en esta tabla",
        "sInfo": "Registro del (_START_ al _END_) total de _TOTAL_ registros",
        "sInfoEmpty": "Registros del (0 al 0) total de 0 registros",
        "sInfoFiltered": "(Filtrado de un total de _MAX_ registros)",
        "sInfoPostFix": "",
        "sSearch": "Buscar:",
        "sUrl": "",
        "sInfoThousands": ",",
        "sLoadingRecords": "<br>No se encontraron datos</b>",
        "oPaginate": {
          "sFirst": "Primero",
          "sLast": "Último",
          "sNext": "Siguiente",
          "sPrevious": "Anterior"
        },
        "oAria": {
          "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
          "sSortDescending": ": Activar para ordenar la columna de manera descendete"
        }
      }

      function cargar_contenido(contenedor, contenido) {
        $("#" + contenedor).load(contenido);
      }
      $.widget.bridge('uibutton', $.ui.button);

      function soloNumeros(e) {
        tecla = (document.all) ? e.keyCode : e.which;
        if (tecla == 8) {
          return true;
        }
        patron = /[0-9]/;
        tecla_final = String.fromCharCode(tecla);
        return patron.test(tecla_final);
      }

      function soloLetras(e) {
        key = e.keyCode || e.which;
        tecla = String.fromCharCode(key).toLowerCase();
        letras = " áéíóúabcdefghijklmnñopqrstuvwxyz";
        especiales = "8-37-39-46";
        tecla_especial = false
        for (var i in especiales) {
          if (key == especiales[i]) {
            tecla_especial = true;
            break;
          }
        }
        if (letras.indexOf(tecla) == -1 && !tecla_especial) {
          return false;
        }
      }

    </script>
    <script>
      TraerDatosUsuario();
      dashboard();
      listar_citas_diarias();
      Cargardatosgraf();
      Cargardatosgraf2();
    </script>
</body>

</html>