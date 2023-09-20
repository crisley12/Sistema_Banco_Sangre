<?php

require('../fpdf/fpdf.php'); //A FPDF

require('../../conexion_reporte/r_conexion.php'); //A base de datos
$consulta = "SELECT * FROM procedimiento";
$resultado=$mysqli->query($consulta);
//$row=$resultado->fetch_assoc();
date_default_timezone_set('America/Caracas');

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


   $this->SetXY(10,60);
   $this->SetFont('Arial', 'B',12);
   $this->SetFillColor(250, 250, 250);
   $this->SetTextColor(40, 40, 40);
   $this->SetDrawColor(255, 255, 255);
   $this->SetLineWidth(0.5);
   $this->Cell(8, 10, 'ID', 1, 0, 'C', 0);
   $this->Cell(65, 10, utf8_decode('Nombres'), 1, 0, 'C', 1);
   $this->Cell(52, 10, 'Fecha de registro', 1, 0, 'C', 1);
   $this->Cell(65, 10, 'Status', 1, 0, 'C', 1);
   $this->SetDrawColor(189, 13, 19);
   $this->SetLineWidth(0.6);
   $this->SetXY(10,70);
   $this->Line(10.5, $this->GetY(), 200, $this->GetY());
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
$pdf->SetFont('Arial','',10);
$pdf->SetXY(9,30);
$pdf->Cell(10,10,('Fecha: ').date('d/m/Y'),0,0,'L');
$pdf->SetXY(120,30);
$pdf->Cell(10,10,('Hora: ').date('g:i A'),0,0,'L');
$pdf->SetXY(90,30);
$pdf->SetFont('Arial','B',14);
$pdf->Cell(10,30,utf8_decode("Procedimiento"),0,0,'L');
$pdf->ln(2);
$pdf->SetDrawColor(189, 13, 19);
$pdf->SetLineWidth(1);
$pdf->Line(10, $pdf->GetY(100) + 20, 200, $pdf->GetY(100) + 20);

//Tabla
$pdf->SetXY(10,71);
$pdf->SetFont('Arial', '',12);
$pdf->SetLineWidth(0.5);
$pdf->SetFillColor(245, 245, 245);
$pdf->SetTextColor(40, 40, 40);
$pdf->SetDrawColor(255, 255, 255);


while($row = $resultado->fetch_assoc()){
    $pdf->Cell(8, 10, utf8_decode($row['procedimiento_id']), 1, 0, 'C', 0);
    $pdf->Cell(65, 10, utf8_decode($row['procedimiento_nombre']), 1, 0, 'C', 1);
    $pdf->Cell(52, 10, $row['procedimiento_fecregistro'], 1, 0, 'C', 1);
    $pdf->Cell(65, 10, $row['procedimiento_estatus'], 1, 0, 'C', 1);
    $pdf->Ln();
  }


$pdf->Output();
?>




