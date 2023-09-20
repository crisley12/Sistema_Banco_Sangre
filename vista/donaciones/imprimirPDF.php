<?php

require('../fpdf/fpdf.php'); //A FPDF

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
$pdf->AddPage('P','A4');
$pdf->SetXY(40,20);
$pdf->SetFont('Arial','B',12);
$pdf->Cell(10,15,utf8_decode("Donación"),0,0,'L');
$pdf->ln(1);
$pdf->SetDrawColor(189, 13, 19);
$pdf->SetLineWidth(1);
$pdf->Line(10, $pdf->GetY(100) + 10, 90, $pdf->GetY(100) + 10);

$pdf->Output();
?>