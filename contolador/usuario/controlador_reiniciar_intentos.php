<?php 
	
	require '../../modelo/modelo_usuario.php';

	$MU = new Modelo_Usuario();
	$usuario = htmlspecialchars($_POST['usuario'],ENT_QUOTES,'UTF-8');
	$consulta = $MU->resetear_con($usuario);
	echo $consulta;
?>