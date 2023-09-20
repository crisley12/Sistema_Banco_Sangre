<?php 
	require '../../modelo/modelo_dashboard.php';
	$MU = new Modelo_Dashboard();
	$consulta = $MU->listar_dashboard();
	echo json_encode($consulta);

?>