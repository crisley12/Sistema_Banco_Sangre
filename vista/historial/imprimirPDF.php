<?php

require('../fpdf/fpdf.php'); //A FPDF
require('../../conexion_reporte/r_conexion.php');
$consulta = " SELECT
  consulta.consulta_descripcion, 
  consulta.consulta_diagnostico, 
  cita.cita_descripcion, 
  paciente.paciente_nombre, 
  paciente.paciente_apepat, 
  paciente.paciente_apemat, 
  paciente.paciente_direccion, 
  paciente.paciente_movil, 
  paciente.paciente_sexo, 
  paciente.paciente_nrodocumento, 
  especialidad.especialidad_nombre, 
  fua.fua_id, 
  cita.cita_id, 
  medico.medico_nombre, 
  medico.medico_apepart, 
  medico.medico_apemart, 
  consulta.consulta_id
FROM
  fua
  INNER JOIN
  consulta
  ON 
    fua.consulta_id = consulta.consulta_id
  INNER JOIN
  cita
  ON 
    consulta.cita_id = cita.cita_id
  INNER JOIN
  paciente
  ON 
    cita.paciente_id = paciente.paciente_id
  INNER JOIN
  especialidad
  ON 
    cita.especialidad_id = especialidad.especialidad_id
  INNER JOIN
  medico
  ON 
    cita.medico_id = medico.medico_id where fua.fua_id ='".$_GET['id']."'";

$resultado=$mysqli->query($consulta);
$row=$resultado->fetch_assoc();

class PDF extends FPDF
{

// Cabecera de página
function Header()
{
    $this->Image('../fpdf/img/Logo.jpg',10,10,70);
    // Arial bold 15
    $this->SetXY(150,10);
    $this->SetFont('Arial','',10);
    $this->settextcolor(40, 40, 40);
    $this->MultiCell(50,3,utf8_decode('Tlf: 0416-5029813
   basantranfs@gmail.com'),0,'R',0);
    $this->Ln(15);
}

// Pie de página
function Footer()
{
    // Posición: a 1,5 cm del final
    $this->SetY(-27);
    // Arial italic 8
    $this->SetFont('Arial','',10);
    $this->settextcolor(40, 40, 40);
    $this->MultiCell(0,4,utf8_decode('AV. LOS AGUSTINOS ESQUINA CALLE 1 N°1-245 BARRIO SANTA CECILIA, QUINTA LA MILAGROSA, SAN CRISTÓBAL - EDO. TACHIRA'),0,'C',0);
    // Número de página
    $this->SetXY(190,-20);
    $this->Cell(0,10,utf8_decode('').$this->PageNo().'/{nb}',0,0,'');
}
}

$pdf = new PDF();
$pdf->AliasNbPages();
$pdf->AddPage('P','A4');
$pdf->SetXY(10,30);
$pdf->SetFont('Arial','B',16);
$pdf->Cell(191,10,utf8_decode("Historial Médico"),0,0,'C');
$pdf->ln(2);
$pdf->SetDrawColor(189, 13, 19);
$pdf->SetLineWidth(1);
$pdf->Line(10, $pdf->GetY(100) + 10, 200, $pdf->GetY(100) + 10);
$pdf->Ln(15);


//Datos del paciente
$pdf->SetLineWidth(0.5);
$pdf->SetX(15);
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(10,10,utf8_decode("DNI: "), 0,0,'L');
$pdf->SetFont('Arial', '', 12);
$pdf->Cell(29,10, "V-".$row['paciente_nrodocumento'], 0,0,'L');
$pdf->SetX(65);
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(20,10,utf8_decode("Paciente: "), 0,0,'L');
$pdf->SetFont('Arial', '', 12);
$pdf->Cell(80,10,utf8_decode($row['paciente_nombre'].(' ').$row['paciente_apepat'].(' ').$row['paciente_apemat']), 0,0,'L');
$pdf->SetX(178);
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(13,10,utf8_decode("Sexo: "), 0,0,'L');
$pdf->SetFont('Arial', '', 12);
$pdf->Cell(5,10,utf8_decode($row['paciente_sexo']), 0,0,'L');
$pdf->Ln(7);
$pdf->SetX(15);
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(22,10,utf8_decode("Dirección: "), 0,0,'L');
$pdf->SetFont('Arial', '', 12);
$pdf->MultiCell(160,10,utf8_decode($row['paciente_direccion']), 0,0,0,'L',0);
$pdf->Ln(5);

//Datos de la cita
$pdf->SetX(10);
$pdf->SetFont('Arial','B',14);
$pdf->Cell(191,10,utf8_decode("Datos de la Cita"),0,0,'C');
$pdf->Ln();
$pdf->SetX(15);
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(19,10,utf8_decode("Nro. cita: "), 0,0,'L');
$pdf->SetFont('Arial', '', 12);
$pdf->Cell(20,10,$row['cita_id'], 0,0,'L');
$pdf->SetX(55);
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(17,10,utf8_decode("Médico: "), 0,0,'L');
$pdf->SetFont('Arial', '', 12);
$pdf->Cell(70,10,utf8_decode($row['medico_nombre'].(' ').$row['medico_apepart'].(' ').$row['medico_apemart']), 0,0,'L');
$pdf->Ln();
$pdf->SetX(15);
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(29,10,utf8_decode("Especialidad: "), 0,0,'L');
$pdf->SetFont('Arial', '', 12);
$pdf->Cell(153,10,utf8_decode($row['especialidad_nombre']), 0,0,'L');
$pdf->Ln();
$pdf->SetX(15);
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(46,10,utf8_decode("Descripción de la cita: "), 0,0,'L');
$pdf->SetFont('Arial', '', 12);
$pdf->MultiCell(136,10,utf8_decode($row['cita_descripcion']), 0,0,0,'L',0);
$pdf->Ln(5);

//Datos de la consulta medica
$pdf->SetX(10);
$pdf->SetFont('Arial','B',14);
$pdf->Cell(191,10,utf8_decode("Datos de la Consulta Médica"),0,0,'C');
$pdf->Ln();
$pdf->SetX(15);
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(56,10,utf8_decode("Descripción de la consulta: "), 0,0,'L');
$pdf->SetFont('Arial', '', 12);
$pdf->MultiCell(126,10,utf8_decode($row['consulta_descripcion']), 0,0,0,'L',0);
$pdf->Ln(2);
$pdf->SetX(15);
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(56,10,utf8_decode("Diagnóstico de la consulta: "), 0,0,'L');
$pdf->SetFont('Arial', '', 12);
$pdf->MultiCell(126,10,utf8_decode($row['consulta_diagnostico']), 0, 0,0,'L',0);
$pdf->Ln(5);

//Medicamentos
$pdf->SetX(10);
$pdf->SetFont('Arial','B',14);
$pdf->Cell(191,10,utf8_decode("Medicamentos"),0,0,'C');
$pdf->Ln();
$pdf->SetLineWidth(0.2);
$pdf->SetDrawColor(0, 0, 0); //Color de bordes
$pdf->SetFillColor(228, 228, 228); //Color de relleno
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(20, 10, '#', 1, 0, 'C', 1);
$pdf->Cell(141, 10, utf8_decode('Medicamento'), 1, 0, 'C', 1);
$pdf->Cell(30, 10, 'Cantidad', 1, 0, 'C', 1);
$pdf->Ln();

$consultamedicamento = "SELECT
        medicamento.medicamento_nombre, 
        detalle_medicamento.detame_cantidad
        FROM
        detalle_medicamento
        INNER JOIN
        medicamento
        ON 
        detalle_medicamento.medicamento_id = medicamento.medicamento_id where detalle_medicamento.fua_id ='".$_GET['id']."'";
        $resultadomedicamento = $mysqli->query($consultamedicamento);
        $contadormedicamento=0;

$pdf->SetFillColor(255,255,255); //Color de relleno
$pdf->SetFont('Arial', '', 12);
while($rowmedicamento = $resultadomedicamento->fetch_assoc()){
  $contadormedicamento++;
    
    $pdf->Cell(20, 10, $contadormedicamento, 1, 0, 'C', 0);
    $pdf->Cell(141, 10, utf8_decode($rowmedicamento['medicamento_nombre']), 1, 0, 'C', 1, 0);
    $pdf->Cell(30, 10, $rowmedicamento['detame_cantidad'], 1, 1, 'C', 0);
}

//Insumos
$pdf->SetX(10);
$pdf->SetFont('Arial','B',14);
$pdf->Cell(191,10,utf8_decode("Insumos"),0,0,'C');
$pdf->Ln();
$pdf->SetLineWidth(0.2);
$pdf->SetDrawColor(0, 0, 0); //Color de bordes
$pdf->SetFillColor(228, 228, 228); //Color de relleno
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(20, 10, '#', 1, 0, 'C', 1);
$pdf->Cell(141, 10, utf8_decode('Insumos'), 1, 0, 'C', 1);
$pdf->Cell(30, 10, 'Cantidad', 1, 0, 'C', 1);
$pdf->Ln();

$consultainsumo = "SELECT
        insumo.insumo_nombre, 
        detalle_insumo.detain_cantidad
        FROM
        detalle_insumo
        INNER JOIN
        insumo
        ON 
        detalle_insumo.insumo_id = insumo.insumo_id where detalle_insumo.fua_id  = '".$_GET['id']."'";
        $resultadoinsumo = $mysqli->query($consultainsumo);
        $contadorinsumo=0;


while ($rowinsumo = $resultadoinsumo->fetch_assoc()){ 
  $contadorinsumo++;
    $pdf->Cell(20, 10, $contadorinsumo, 1, 0, 'C', 0);
    $pdf->Cell(141, 10, utf8_decode($rowinsumo['insumo_nombre']), 1, 0, 'C', 0, 0);
    $pdf->Cell(30, 10, $rowinsumo['detain_cantidad'], 1, 1, 'C', 0);
}



//Procedimientos
$pdf->SetX(10);
$pdf->SetFont('Arial','B',14);
$pdf->Cell(191,10,utf8_decode("Procedimiento"),0,0,'C');
$pdf->Ln();
$pdf->SetLineWidth(0.2);
$pdf->SetDrawColor(0, 0, 0); //Color de bordes
$pdf->SetFillColor(228, 228, 228); //Color de relleno
$pdf->SetFont('Arial', 'B', 12);
$pdf->Cell(20, 10, '#', 1, 0, 'C', 1);
$pdf->Cell(171, 10, utf8_decode('Procedimietos'), 1, 0, 'C', 1);
$pdf->Ln();


$consultaprocedimiento = "SELECT
      procedimiento.procedimiento_nombre
      FROM
      detalle_procedimiento
      INNER JOIN
      procedimiento
      ON 
      detalle_procedimiento.procedimiento_id = procedimiento.procedimiento_id where detalle_procedimiento.fua_id  = '".$_GET['id']."'";
        $resultadoprocedimiento = $mysqli->query($consultaprocedimiento);
        $contadorprocedimiento=0;


while ($rowprocedimiento = $resultadoprocedimiento->fetch_assoc()){
  $contadorprocedimiento++;
    $pdf->Cell(20, 10, $contadorprocedimiento, 1, 0, 'C', 0);
    $pdf->Cell(171, 10, utf8_decode($rowprocedimiento['procedimiento_nombre']), 1, 0, 'C', 0, 0);
    $pdf->ln();

}

$pdf->Output();
?>