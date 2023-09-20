var tabledonaciones;
function listar_donaciones(){
    tabledonaciones = $("#tabla_donaciones").DataTable({
		"ordering":false,
		"blengthChange":true,
		"paging":false,
		"searching": { "regex": true },
		"lengthMenu": [ [10, 25, 50, 100, -1], [10, 25, 50, 100, "All"] ],
		"pageLength": 10,
		"destroy":true,
		"async": false ,
		"processing": true,
		"ajax":{
			"url":"../contolador/donaciones/controlador_donaciones_listar.php",
			type:'POST'
		},
		"order":[[1,'asc']],
		"columns":[
			{"defaultContent":""},
			{"data":"fecha_donaciones"},
			{"data":"paciente_id"},
            {"data":"sag_id"},
			{"data":"volumen"},
            {"defaultContent":"<button style='font-size:13px;' type='button' class='editar btn btn-primary'><i class='fa fa-edit'></i></button>"}
	],

	"language":idioma_espanol,
	select: true

	});
	document.getElementById("tabla_donaciones_filter").style.display="none";

	$('input.global_filter').on( 'keyup click', function () {
		filterGlobal();
	});
	$('input.column_filter').on( 'keyup click', function () {
		filterColumn( $(this).parents('tr').attr('data-column') );
	});


	tabledonaciones.on('draw.dt', function (){
		var PageInfo = $('#tabla_donaciones').DataTable().page.info();
		tabledonaciones.column(0, { page: 'current' }).nodes().each( function (cell, i){
			cell.innerHTML = i + 1 + PageInfo.start;
		});
	});

}

function filterGlobal() {
	$('#tabla_donaciones').DataTable().search(
		$('#global_filter').val(),
	).draw();
}

$('#tabla_donaciones').on('click','.editar',function(){
    var data = tablecita.row($(this).parents('tr')).data();
    if(tablecita.row(this).child.isShown()){
        var data = tablecita.row(this).data();
    }
    $("#modal_editar").modal({backdrop: 'static',keyboard:false})
    $("#modal_editar").modal('show');
    $("#txt_cita_id").val(data.cita_id);
    $("#cbm_paciente_editar").val(data.paciente_id).trigger("change");
    $("#cbm_especialidad_editar").val(data.especialidad_id).trigger("change");
    listar_doctor_combo_editar(data.especialidad_id,data.medico_id);
    $("#cbm_estatus").val(data.cita_estatus).trigger("change");
    $("#txt_descripcion_editar").val(data.cita_descripcion);
    
})

function AbrirModalRegistro(){
	$("#modal_registro").modal({backdrop: 'static',keyboard:false})
	$("#modal_registro").modal('show');
}

function listar_combo_sangre(){
	$.ajax({
		"url":"../contolador/paciente/controlador_combo_sangre_listar.php",
		type:'POST'
	}).done(function(resp){
		var data = JSON.parse(resp);
		var cadena="<option value=''>Selecione</option>";
		if(data.length>0){
			for(var i=0; i < data.length; i++){
				cadena+="<option value='"+data[i][0]+"'>"+data[i][1]+"</option>";
			}
			$("#cbm_sangre").html(cadena);
			$("#cbm_sangre_editar").html(cadena);
		}else{
			cadena+="<option value=''>NO SE ENCONTRARON REGISTROS</option>";
			$("#cbm_sangre").html(cadena);
			$("#cbm_sangre_editar").html(cadena);
		}
	})
}

function listar_paciente_combo(){
    $.ajax({
        url:'../contolador/donaciones/controlador_combo_paciente_listar.php',
        type:'POST'
    }).done(function(resp){
        var data = JSON.parse(resp);
        var cadena="";
        if(data.length>0){
            for(var i=0; i < data.length; i++){
                    cadena+="<option value='"+data[i][0]+"'>"+data[i][1]+"</option>";
            
            }
            $("#cbm_paciente").html(cadena);
        }else{
            cadena+="<option value=''>NO SE ENCONTRARON REGISTROS</option>";
            $("#cbm_paciente").html(cadena);

        }
    })
}

function listar_paciente_combo_editar(){
    $.ajax({
        url:'../contolador/donaciones/controlador_combo_paciente_listar.php',
        type:'POST'
    }).done(function(resp){
        var data = JSON.parse(resp);
        var cadena="";
        if(data.length>0){
            for(var i=0; i < data.length; i++){
                    cadena+="<option value='"+data[i][0]+"'>"+data[i][1]+"</option>";
            
            }
            $("#cbm_paciente_editar").html(cadena);
        }else{
            cadena+="<option value=''>NO SE ENCONTRARON REGISTROS</option>";
            $("#cbm_paciente_editar").html(cadena);

        }
    })
}

function Registrar_Donacion(){
	var nombre= $("#cbm_paciente").val();
	var sangre= $("#cbm_sangre").val();
	var volumen= $("#txt_vol").val();
	var fcha= $("#txt_fenac").val();
	
	if(nombre.length==0 || sangre.length==0 || volumen.length==0 || fcha.length==0){
		return Swal.fire("Mensaje De Advertencia","Llene todos los campos","warning");
	}
	$.ajax({
		"url":"../contolador/donaciones/controlador_donaciones_registro.php",
		type:'POST',
		data:{
			nombre:      nombre,    
			sangre:      sangre,
			volumen:     volumen,
			fcha:    	 fcha
	
		}
	}).done(function(resp){
		if(resp>0){
				if(resp==1){
					$("#modal_registro").modal('hide');
					listar_donaciones();
					Swal.fire("Mensaje De Confirmación","Datos guardado correctamente","success");
				}else{
					Swal.fire("Mensaje De Error","Error no se puede completar el registro","error");
				}
			}
	})
}

function Modificar_Paciente(){
	var id= $("#txt_idpaciente").val();
	var nombres= $("#txt_nombres_editar").val();
	var apepat= $("#txt_apepat_editar").val();
	var apemat= $("#txt_apemat_editar").val();
	var direccion= $("#txt_direccion_editar").val();
	var movil= $("#txt_movil_editar").val();
	var fecha= $("#txt_fenac_editar").val();
	var sangre= $("#cbm_sangre_editar").val();
	var sexo= $("#cbm_sexo_editar").val();
	var nrodocumentoactual= $("#txt_ndoc_actual_editar").val();
	var nrodocumentonuevo= $("#txt_ndoc_nuevo_editar").val();
	var estatus= $("#cbm_estatus").val();
	
	if(id.length==0 || nombres.length==0 || apepat.length==0 || apemat.length==0 || direccion.length==0 || movil.length==0 || fecha.length==0 || sangre.length==0 || sexo.length==0 || nrodocumentonuevo.length==0){
		return Swal.fire("Mensaje De Advertencia","Llene todos los campos","warning");
	}
	$.ajax({
		"url":"../contolador/paciente/controlador_paciente_modificar.php",
		type:'POST',
		data:{
			id:           id,
			nombres:      nombres,    
			apepat:       apepat,
			apemat:       apemat,
			direccion:    direccion,
			movil:        movil,
			fecha:        fecha,
			sangre:       sangre,
			sexo:         sexo,
			nrodocumentoactual: nrodocumentoactual,
			nrodocumentonuevo: nrodocumentonuevo,
			estatus: estatus
	
		}
	}).done(function(resp){
		if(resp>0){
			if(resp==1){
				$("#modal_editar").modal('hide');
				listar_paciente();
				LimpiarCampos();
			return	Swal.fire("Mensaje De Confirmacion","Datos Actualizado correctamente","success");
			}else{
				LimpiarCampos();
			return	Swal.fire("Mensaje De Advertencia","Los datos que esta registrando ya existe","warning");

			}
		}else{
			return Swal.fire("Mensaje De Error","Lo sentimos el registro no se pudo completar","error");
		}
	})
}


function LimpiarCampos(){
	$("#txt_nombres").val("");
	$("#txt_apepat").val("");
	$("#txt_apemat").val("");
	$("#txt_direccion").val("");
	$("#txt_movil").val("");
	$("#txt_ndoc").val("");
	$("#txt_nombres_editar").val("");
	$("#txt_apepat_editar").val("");
	$("#txt_apemat_editar").val("");
	$("#txt_direccion_editar").val("");
	$("#txt_movil_editar").val("");
	$("#txt_ndoc_nuevo_editar").val("");
}