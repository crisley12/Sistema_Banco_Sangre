<?php 
	
	require '../../modelo/modelo_donaciones.php';
	$MP = new Modelo_Donaciones();
	$consulta = $MP->listar_paciente_combo();
		echo json_encode($consulta); 

	?>