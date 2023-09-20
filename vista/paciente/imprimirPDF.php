<?php

require('../fpdf/fpdf.php'); //A FPDF

require('../../conexion_reporte/r_conexion.php');
$consulta = "SELECT paciente.paciente_id, paciente.paciente_nombre, paciente.paciente_apepat, paciente.paciente_apemat, paciente.paciente_direccion, paciente.paciente_movil, paciente.paciente_sexo, paciente.paciente_fenac, paciente.paciente_nrodocumento, paciente.paciente_estatus, sangre.tp_sangre AS tipo 
FROM paciente INNER JOIN sangre ON paciente.sag_id = sangre.sag_id WHERE paciente_id='".$_GET['id']."'";
//$consulta = "SELECT * FROM sangre WHERE paciente_id='".$_GET['id']."'";
$resultado=$mysqli->query($consulta);
$row=$resultado->fetch_assoc();
date_default_timezone_set('America/Caracas');
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
   $this->SetXY(45, 15);
   
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
$pdf->SetXY(9,20);
$pdf->Cell(10,10,('Fecha: ').date('d/m/Y'),0,0,'L');
$pdf->SetXY(50,20);
$pdf->Cell(10,10,('Hora: ').date('g:i A'),0,0,'L');
$pdf->SetXY(40,25);
$pdf->SetFont('Arial','B',12);
$pdf->Cell(10,15,"Paciente",0,0,'L');
$pdf->ln(1);
$pdf->SetDrawColor(189, 13, 19);
$pdf->SetLineWidth(1);
$pdf->Line(10, $pdf->GetY(100) + 10, 90, $pdf->GetY(100) + 10);

$pdf->SetXY(10,40);
$pdf->SetFont('Arial','',10);
$pdf->SetDrawColor(255, 255, 255);
$pdf->SetLineWidth(0.5);
$pdf->SetFillColor(250,250,250);
$pdf->MultiCell(82,7,utf8_decode("Nombre: ".$row['paciente_nombre']), 1, 'L', 0);
$pdf->Ln(2);
$pdf->MultiCell(82,7,utf8_decode("Apellido: ".$row['paciente_apepat'].(' ').$row['paciente_apemat']), 1, 'L', 0);
$pdf->Ln(2);
$pdf->MultiCell(82,7,utf8_decode("Cédula de identidad: V-").$row['paciente_nrodocumento'], 1,'L', 0);
$pdf->Ln(2);
$pdf->MultiCell(82,7,utf8_decode("Dirección: ".$row['paciente_direccion']), 1,'L', 0);
$pdf->Ln(2);
$pdf->MultiCell(82,7,utf8_decode("Télefono: ").$row['paciente_movil'], 1,'L', 0);
$pdf->Ln(2);
$pdf->MultiCell(82,7,utf8_decode("Sexo: ").$row['paciente_sexo'], 1,'L', 0);
$pdf->Ln(2);
$pdf->MultiCell(82,7,utf8_decode("Fecha de nacimiento: ").$row['paciente_fenac'], 1,'L', 0);
$pdf->Ln(2);
$pdf->MultiCell(82,7,utf8_decode("Tipo de sangre: ").$row['tipo'], 1,'L', 0);



$pdf->Output();
?>