<script type="text/javascript" src="../js/usuario.js?rev=<?php echo time();?>"></script>
<form autocomplete="false" onsubmit="return false">
  <div class="col-md-12">
    <div class="box box-warning box-solid">
      <div class="box-header with-border">
        <h3 class="box-title">BIENVENIDO AL CONTENIDO DEL USUARIO</h3> 
          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
            </button>
          </div>
                <!-- /.box-tools -->
      </div>
            <!-- /.box-header -->
      <div class="box-body">
        <table id="tabla_restaurar" class="display responsive nowrap" style="width:100%">
          <thead>
            <tfoot>
              <tr>
                <th>#</th>
                <th>Usuario</th>
                <th>Email</th>
                <th>Rol</th>
                <th>Sexo</th>
                <th>Estatus</th>
                <th>Acción</th>
              </tr>
            </tfoot>
          </thead>
          <tfoot>
            <tr>
              <th>#</th>
              <th>Usuario</th>
              <th>Email</th>
              <th>Rol</th>
              <th>Sexo</th>
              <th>Estatus</th>
              <th>Acción</th>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  </div>
</form>
<script>
  $(document).ready(function(){
    listar_usuario_inactivo();
    $('.js-example-basic-single').select2();
    listar_combo_rol();
    $("#modal_registro").on('shown.bs.modal',function(){
      $("#txt_usu").focus();
    })
  } );
  $('.box').boxWidget({
    animationSpeed : 500,
    collapseTrigger: '[data-widget="collapse"]',
    removeTrigger  : '[data-widget="remove"]',
    collapseIcon   : 'fa-minus',
    espandIcon     : 'fa-plus',
    removeIcon     : 'fa-times'
  })

</script>