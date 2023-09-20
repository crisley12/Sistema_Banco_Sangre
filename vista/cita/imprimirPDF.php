<?php 
//Conexiones
require('../fpdf/fpdf.php'); //A FPDF

require('../../conexion_reporte/r_conexion.php');
$consulta = "SELECT cita.cita_id, cita.cita_nroatencion, cita.cita_feregistro, CONCAT_WS(' ', medico.medico_nombre, medico.medico_apepart, medico.medico_apemart) as medico, CONCAT_WS(' ', paciente.paciente_nombre, paciente.paciente_apepat, paciente.paciente_apemat) as paciente, cita.cita_descripcion, especialidad.especialidad_nombre
FROM cita INNER JOIN medico ON cita.medico_id = medico.medico_id INNER JOIN paciente ON cita.paciente_id = paciente.paciente_id INNER JOIN especialidad ON medico.especialidad_id =  especialidad.especialidad_id WHERE cita_id='".$_GET['id']."'";
$resultado=$mysqli->query($consulta);
$row=$resultado->fetch_assoc();


class PDF extends FPDF
{

// Cabecera de página
function Header()
{
    $this->Image('../fpdf/img/Logo.jpg',5,5,48);
    // Arial bold 15
    $this->SetXY(45,6);
    $this->SetFont('Arial','',8);
    $this->settextcolor(40, 40, 40);
    $this->MultiCell(50,3,utf8_decode('Tlf: 0416-5029813
   basantranfs@gmail.com'),0,'R',0);
   
}

// Pie de página
function Footer()
{
    // Posición: a 1,5 cm del final
    $this->SetY(-17);
    // Arial italic 8
    $this->SetFont('Arial','',8);
    $this->settextcolor(40, 40, 40);
    $this->MultiCell(0,3,utf8_decode('AV. LOS AGUSTINOS ESQUINA CALLE 1 N°1-245 BARRIO SANTA CECILIA, QUINTA LA MILAGROSA, SAN CRISTÓBAL - EDO. TACHIRA'),0,'C',0);
    // Número de página
    $this->SetXY(90,-10);
    $this->Cell(0,10,utf8_decode('').$this->PageNo().'/{nb}',0,0,'');
}
}


$pdf = new PDF();
$pdf->AliasNbPages();
$pdf->AddPage('P',array(100,150));
$pdf->SetXY(34,20);
$pdf->SetFont('Arial','B',13);
$pdf->Cell(10,15,"Datos de la cita",0,0,'L');
$pdf->ln(1);
$pdf->SetDrawColor(189, 13, 19);
$pdf->SetLineWidth(1);
$pdf->Line(10, $pdf->GetY(100) + 10, 90, $pdf->GetY(100) + 10);


$pdf->SetXY(10,40);
$pdf->SetFont('Arial','',10);
$pdf->SetDrawColor(255, 255, 255);
$pdf->SetLineWidth(0.5);
$pdf->SetFillColor(250,250,250);
$pdf->MultiCell(82,7,utf8_decode("Número de atención: ").$row['cita_nroatencion'], 1, 'L', 0);
$pdf->Ln(2);
$pdf->MultiCell(82,7,utf8_decode("Paciente: ").$row['paciente'], 1, 'L', 0);
$pdf->Ln(2);
$pdf->MultiCell(82,7,utf8_decode("Médico: ".$row['medico']), 1,'L', 0);
$pdf->Ln(2);
$pdf->MultiCell(82,7,utf8_decode("Especialidad: ".$row['especialidad_nombre']), 1,'L', 0);
$pdf->Ln(2);
$pdf->MultiCell(82,7,utf8_decode("Descripción: ".$row['cita_descripcion']), 1,'L', 0);



$pdf->Output();
?>


