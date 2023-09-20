<?php 
    class Modelo_Grafica{
		private $conexion;
		function __construct(){
			require_once 'modelo_conexion.php';
			$this->conexion = new conexion();
			$this->conexion->conectar();
		}

        function Grafica(){
			$sql = "call SP_LISTAR_INSUMO";
			$arreglo = array();
			if ($consulta = $this->conexion->conexion->query($sql)) {
				while ($consulta_VU = mysqli_fetch_assoc($consulta)) {
					$arreglo["data"][]=$consulta_VU;
				
				}
				return $arreglo;
				$this->conexion->cerrar();
			}
		}

		function Grafica2(){
			$sql = "call SP_LISTAR_MEDICAMENTO";
			$arreglo = array();
			if ($consulta = $this->conexion->conexion->query($sql)) {
				while ($consulta_VU = mysqli_fetch_assoc($consulta)) {
					$arreglo["data"][]=$consulta_VU;
				
				}
				return $arreglo;
				$this->conexion->cerrar();
			}
		}


    }

?>