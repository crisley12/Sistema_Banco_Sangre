<?php

require('../fpdf/fpdf.php'); //A FPDF

require('../../conexion_reporte/r_conexion.php'); //A base de datos
$consulta = "SELECT medico.medico_id, medico.medico_nombre, medico.medico_apepart, medico.medico_apemart, medico.medico_direccion, medico.medico_movil, medico.medico_sexo, medico.medico_fenac, medico.medico_nrodocumento, medico.medico_colegiatura, medico.especialidad_id, medico.usu_id, medico.sag_id, especialidad.especialidad_nombre AS especialidad  
FROM medico INNER JOIN especialidad ON medico.especialidad_id = especialidad.especialidad_id ORDER BY especialidad ASC";
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
    $this->Cell(49, 10, 'Nombre', 1, 0, 'C', 1);
    $this->Cell(43, 10, utf8_decode('Apellido'), 1, 0, 'C', 1);
    $this->Cell(62, 10, utf8_decode('Especialidad'), 1, 0, 'C', 1);
    $this->Cell(37, 10, utf8_decode('Teléfono'), 1, 1, 'C', 1);
    $this->SetDrawColor(189, 13, 19);
    $this->SetLineWidth(0.6);
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
$pdf->SetXY(90,40);
$pdf->SetFont('Arial','B',14);
$pdf->Cell(10,15,utf8_decode("Médicos"),0,0,'L');
$pdf->ln(2);
$pdf->SetDrawColor(189, 13, 19);
$pdf->SetLineWidth(1);
$pdf->Line(10, $pdf->GetY(100) + 10, 200, $pdf->GetY(100) + 10);

$pdf->SetXY(10,71);
$pdf->SetFont('Arial', '',12);
$pdf->SetFillColor(245, 245, 245);
$pdf->SetTextColor(40, 40, 40);
$pdf->SetDrawColor(255, 255, 255);
$pdf->SetLineWidth(0.5);

while($row = $resultado->fetch_assoc()){
    
    $pdf->Cell(49, 10, utf8_decode($row['medico_nombre']), 1, 0, 'C', 1);
    $pdf->Cell(43, 10, utf8_decode($row['medico_apepart']), 1, 0, 'C', 1);
    $pdf->Cell(62, 10, utf8_decode($row['especialidad']), 1, 0, 'C', 1);
    $pdf->Cell(37, 10, $row['medico_movil'], 1, 1, 'C', 1);
 }





$pdf->Output();
?>



