<?php 
	
	require '../../modelo/modelo_donaciones.php';
	$ME = new Modelo_Donaciones();
	$nombre = htmlspecialchars($_POST['nombre'],ENT_QUOTES,'UTF-8');
	$sangre = htmlspecialchars($_POST['sangre'],ENT_QUOTES,'UTF-8');
    $volumen = htmlspecialchars($_POST['volumen'],ENT_QUOTES,'UTF-8');
	$fcha = htmlspecialchars($_POST['fcha'],ENT_QUOTES,'UTF-8');
	$consulta = $ME->Registrar_Donaciones($nombre,$sangre,$volumen,$fcha);
		echo ($consulta);
?>