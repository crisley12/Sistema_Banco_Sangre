<?php 
	
	require '../../modelo/modelo_donaciones.php';
	$ME = new Modelo_Donaciones();
	$consulta = $ME->listar_donaciones();
	if ($consulta) {
		echo json_encode($consulta);
	}else {
		echo '{
			"sEcho": 1,
			"iTotalRecords": "0",
			"iTotalDisplayRecords": "0",
			"aaData": []
		}';
	}
	
?>