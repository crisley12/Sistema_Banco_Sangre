<script type="text/javascript" src="../js/donaciones.js?rev=<?php echo time(); ?>"></script>
<form autocomplete="false" onsubmit="return false">
    <div class="col-lg-12">
        <div class="box box-warning box-solid">
            <div class="box-header with-border">
                <h3 class="box-title">Mantenimiento Donaciones</h3>

                <div class="box-tools pull-right">
                    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
                    </button>
                </div>
                <!-- /.box-tools -->
            </div>
            <!-- /.box-header -->
            <div class="box-body">
                <div class="form-group">
                    <div class="col-lg-10">

                    </div>
                    <div class="col-lg-2">
                        <button class="btn btn-danger" style="width:100%" onclick="AbrilModalRegistro()"><i class="glyphicon glyphicon-plus"></i> Nuevo Registro </button>
                    </div>
                </div>
                <table id="tabla_donaciones" class="display responsive nowrap" style="width:100%">
                    <thead>
                    <tfoot>
                        <tr>
                            <th>#</th>
                            <th>Fecha</th>
                            <th>Donante</th>
                            <th>Tipo De Sangre</th>
                            <th>Volumen</th>
                            <th>Acción</th>
                        </tr>
                    </tfoot>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>#</th>
                            <th>Fecha</th>
                            <th>Donante</th>
                            <th>Tipo De Sangre</th>
                            <th>Volumen</th>
                            <th>Acción</th>
                        </tr>
                    </tfoot>
                </table>
            </div>
            <!-- /.box-body -->
        </div>
        <!-- /.box -->
    </div>
</form>

<div class="modal fade" id="modal_registro" role="dialog">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title"><b>Registro Donaciones</b></h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-4">
                        <label for="">Paciente</label>
                        <select class="js-example-basic-single" name="state" id="cbm_paciente" style="width: 100%;">
                        </select><br>
                    </div>
                    <div class="col-sm-4">
                        <label for="">Tipo de Sangre</label>
                        <select class="js-example-basic-single" name="state" id="cbm_sangre" style="width: 100%;">
                        </select><br>
                    </div>
                    <div class="col-lg-12">
                        <label for="">Volumen</label>
                        <input type="text" class="form-control" id="txt_vol" placeholder="Ingrese Cantidad de sangre" maxlength="5"><br>
                    </div>
                    <div class="col-sm-7">
                        <label for="">Fecha De Donacion</label>
                        <input type="date" id="txt_fenac" class="form-control">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" onclick="Registrar_Donacion()"><i class="fa fa-check"><b>&nbsp;Registrar</b></i></button>
                <button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-close"><b>&nbsp;Cerrar</b></i></button>
            </div>
        </div>
    </div>
</div>

<div class="modal lg" id="modal_editar" role="dialog">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title"><b>Editar Cita</b></h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-lg-12">
                        <input type="text" id="txt_donaciones_id" hidden>
                        <label for="">Paciente</label>
                        <select class="js-example-basic-single" name="state" id="cbm_paciente_editar" style="width:100%;">
                        </select><br><br>
                    </div>

                    <div class="col-lg-6">
                        <label for="">Tipo de Sangre</label>
                        <select class="js-example-basic-single" name="state" id="cbm_sangre_editar" style="width: 100%;">
                        </select>
                    </div>

                    <div class="col-lg-12"><br>
                    <label for="">Volumen</label>
                        <input type="text" class="form-control" id="txt_vol_editar" placeholder="Ingrese Cantidad de sangre" maxlength="5"><br>
                    </div>

                    <div class="col-sm-7">
                        <label for="">Fecha De Donacion</label>
                        <input type="date" id="txt_fenac_editar" class="form-control" disabled>
                    </div>
                    
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" onclick="Editar_Cita()"><i class="fa fa-check"><b>&nbsp;Editar</b></i></button>
                <button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-close"><b>&nbsp;Cerrar</b></i></button>
            </div>
        </div>
    </div>
</div>



<script>
    $(document).ready(function() {
        listar_donaciones();
        listar_combo_sangre();
        listar_paciente_combo();
        listar_paciente_combo_editar()
        $('.js-example-basic-single').select2();
        $("#modal_registro").on('shown.bs.modal', function() {
            $("").focus();
        })

    });




    $('.box').boxWidget({
        animationSpeed: 500,
        collapseTrigger: '[data-widget="collapse"]',
        removeTrigger: '[data-widget="remove"]',
        collapseIcon: 'fa-minus',
        espandIcon: 'fa-plus',
        removeIcon: 'fa-times'
    })
</script>