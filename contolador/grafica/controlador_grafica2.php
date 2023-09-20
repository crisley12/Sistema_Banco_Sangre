<?php 
	
	require '../../modelo/modelo_grafica.php';
	$MG = new Modelo_Grafica();
	$consulta = $MG->Grafica2();
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