<?php 
	require '../../modelo/modelo_dashboard.php';
	$MU = new Modelo_Dashboard();
	$consulta = $MU->listar_listar_cita_diaria();
	echo json_encode($consulta);

?>