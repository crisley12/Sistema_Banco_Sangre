<?php 
	session_start();
	if(isset($_SESSION['S_IDUSUARIO'])){
		header('Location: ../vista/index.php');
	}
	
?>

<!DOCTYPE html>
<html lang="en">
<head>
	<link rel="stylesheet" href="">
	<title>BASANTRANFS/LOGIN</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
<!--===============================================================================================-->	
    <link rel="shortcut icon" type="image/x-icon" href="../sangre.png">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="fonts/font-awesome-4.7.0/css/font-awesome.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="fonts/iconic/css/material-design-iconic-font.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/animate/animate.css">
<!--===============================================================================================-->	
	<link rel="stylesheet" type="text/css" href="vendor/css-hamburgers/hamburgers.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/animsition/css/animsition.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/select2/select2.min.css">
<!--===============================================================================================-->	
	<link rel="stylesheet" type="text/css" href="vendor/daterangepicker/daterangepicker.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="stylesheet" type="text/css" href="css/main.css">
<!--===============================================================================================-->
</head>
<body>
	
	<div class="limiter">
		<div class="container-login100">
		<div>
			<img  class="avatar" src="../Login/images/logo.png" alt="Avatar">
			<div class="wrap-login100 p-l-30 p-r-30 p-t-30 p-b-10">
						<span class="login100-form-title p-b-20">
							Basantranfs
						</span>
						<h1 class="sub">Iniciar Sesión</h1>
					<div class="wrap-input100 validate-input m-b-20" data-validate = "Username is reauired">
							<span class="label-input100"></span>
							<input class="input100" type="text" name="username" placeholder="Usuario" id="txt_usu" autocomplete="new-password">
							<span class="focus-input100" data-symbol="&#xf206;"></span>
						</div>

						<div class="wrap-input100 validate-input" data-validate="Password is required">
							<span class="label-input100"></span>
							<input class="input100" type="password" name="pass" placeholder="Contraseña" id="txt_con">
							<span class="focus-input100" data-symbol="&#xf190;"></span>
						</div>
					
						<div class="text-right p-t-15 p-b-20">
							<a href="#" onclick="AbrirModalRestablecer()">
								Olvidaste la contraseña?
							</a>
						</div>
					
						<div class="container-login100-form-btn">
							<div class="wrap-login100-form-btn">
								<div class="login100-form-bgbtn"></div>
								<button class="login100-form-btn" onclick="VerificarUsuario()">
									Entrar
								</button>
							</div>
						</div><br>

						<div class="flex-c-m">
							<a href="https://www.facebook.com/basantranfsb"    class="login100-social-item bg1">
								<i class="fa fa-facebook"></i>
							</a>

							<a href="https://instagram.com/basantranfs?igshid=YmMyMTA2M2Y=" class="login100-social-item bg1">
								<i class="fa fa-instagram"></i>
							</a>
                            
							<a href="../Principal/index.php"  class="login100-social-item bg1">
								<i class="fa fa-home"></i>
							</a>
				   </div>
				</div>		
			</div>
		</div>
	</div>
	
	<div id="dropDownSelect1"></div>

	<div class="modal fade" id="modal_restablecer_contra" role="dialog">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header" style="text-align: left;">
            
           <h4 class="modal-title"><b>Restablecer Contraseña</b></h4>
            <button type="button" class="close" data-dismiss="modal">&times;</button>
          </div>
          <div class="modal-body">
            <div class="col-lg-12">
              <label for=""><b>Ingrese el email registrado, para establecer una nueva contraseña</b></label>
              <input type="text" class="form-control" id="txt_email" placeholder="Ingrese email"><br>
            </div>

          </div>
          <div class="modal-footer">
            <button class="btn btn-primary" onclick="Restablecer_Contra()"><i class="fa"><b>&nbsp;Enviar</b></i></button>
            <button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa"><b>&nbsp;Cerrar</b></i></button>
          </div>
        </div>
      </div>
    </div>

<!--===============================================================================================-->
	<script src="vendor/sweetalert2/sweetalert2.js"></script>
<!--===============================================================================================-->
<!--===============================================================================================-->
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
<!--===============================================================================================-->
	<script src="vendor/animsition/js/animsition.min.js"></script>
<!--===============================================================================================-->
	<script src="vendor/bootstrap/js/popper.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.min.js"></script>
<!--===============================================================================================-->
	<script src="vendor/select2/select2.min.js"></script>
<!--===============================================================================================-->
	<script src="vendor/daterangepicker/moment.min.js"></script>
	<script src="vendor/daterangepicker/daterangepicker.js"></script>
<!--===============================================================================================-->
	<script src="vendor/countdowntime/countdowntime.js"></script>
<!--===============================================================================================-->
	<script src="js/main.js"></script>
	<script src="../js/usuario.js"></script>

</body>
<script>
txt_usu.focus();
</script>
</html>