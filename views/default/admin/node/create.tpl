{include file='admin/main.tpl'}

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            节点添加
            <small>Add Node</small>
        </h1>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
            <!-- left column -->
            <div class="col-md-6">
                <!-- general form elements -->
                <div class="box box-primary">

                        <div class="box-body">
                            <div class="form-group">
                                <label for="title">节点名字</label>
                                <input  class="form-control" id="name" value="" >
                            </div>

                            <div class="form-group">
                                <label for="server">节点地址</label>
                                <input  class="form-control" id="server" value="" >
                            </div>

                            <div class="form-group">
                                <label for="method">加密方式</label>
                                <input  class="form-control" id="method" value="" >
                            </div>

                            <div class="form-group">
                                <label for="method">是否支持用户自定义加密</label>
                                <p><a href="https://github.com/orvice/ss-panel/wiki/v3-custom-method">如何使用自定义加密?</a></p>
                                <input  class="form-control" id="custom_method" value=""  placeholder="1 支持 0不支持 ">
                            </div>


                            <div class="form-group">
                                <label for="info">节点描述</label>
                                <input  class="form-control" id="info" value="" >
                            </div>

                            <div class="form-group">
                                <label for="type">是否显示</label>
                                <input   class="form-control" id="type"  value="" placeholder="0隐藏/1SS/2AC/3SS+AC" >
                            </div>

                            <div class="form-group">
                                <label for="status">状态</label>
                                <input   class="form-control" id="status"  value="" >
                            </div>

                            <div class="form-group">
                                <label for="sort">排序</label>
                                <input   class="form-control" id="sort"  value="" >
                            </div>

                        </div><!-- /.box-body -->

                        <div id="msg-success" class="alert alert-info alert-dismissable" style="display: none;">
                            <button type="button" class="close" id="ok-close" aria-hidden="true">&times;</button>
                            <h4><i class="icon fa fa-info"></i> 成功!</h4>
                            <p id="msg-success-p"></p>
                        </div>
                        <div id="msg-error" class="alert alert-warning alert-dismissable" style="display: none;">
                            <button type="button" class="close" id="error-close" aria-hidden="true">&times;</button>
                            <h4><i class="icon fa fa-warning"></i> 出错了!</h4>
                            <p id="msg-error-p"></p>
                        </div>

                        <div class="box-footer">
                            <button type="submit" id="submit" name="action" value="add" class="btn btn-primary">添加</button>
                        </div>

                </div>
            </div><!-- /.box -->
        </div>   <!-- /.row -->
    </section><!-- /.content -->
</div><!-- /.content-wrapper -->

<script>
    $(document).ready(function(){
        function submit(){
            $.ajax({
                type:"POST",
                url:"/admin/node",
                dataType:"json",
                data:{
                    name: $("#name").val(),
                    server: $("#server").val(),
                    method: $("#method").val(),
                    custom_method: $("#custom_method").val(),
                    info: $("#info").val(),
                    type: $("#type").val(),
                    status: $("#status").val(),
                    sort: $("#sort").val()
                },
                success:function(data){
                    if(data.ret){
                        $("#msg-error").hide(100);
                        $("#msg-success").show(100);
                        $("#msg-success-p").html(data.msg);
                        window.setTimeout("location.href='/admin/node'", 2000);
                    }else{
                        $("#msg-error").hide(10);
                        $("#msg-error").show(100);
                        $("#msg-error-p").html(data.msg);
                    }
                },
                error:function(jqXHR){
                    $("#msg-error").hide(10);
                    $("#msg-error").show(100);
                    $("#msg-error-p").html("发生错误："+jqXHR.status);
                }
            });
        }
        $("html").keydown(function(event){
            if(event.keyCode==13){
                login();
            }
        });
        $("#submit").click(function(){
            submit();
        });
        $("#ok-close").click(function(){
            $("#msg-success").hide(100);
        });
        $("#error-close").click(function(){
            $("#msg-error").hide(100);
        });
    })
</script>


{include file='admin/footer.tpl'}
