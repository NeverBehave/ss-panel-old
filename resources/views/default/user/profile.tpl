{include file='user/main.tpl'}

<div class="content-wrapper">
    <section class="content-header">
        <h1>
            我的信息
            <small>User Profile</small>
        </h1>
    </section>
    <!-- Main content --><!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-xs-12">
                <div id="msg-error" class="alert alert-warning alert-dismissable" style="display:none">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4><i class="icon fa fa-warning"></i> 出错了!</h4>

                    <p id="msg-error-p"></p>
                </div>
                <div id="ss-msg-success" class="alert alert-success alert-dismissable" style="display:none">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <h4><i class="icon fa fa-info"></i> 修改成功!</h4>

                    <p id="ss-msg-success-p"></p>
                </div>
            </div>
        </div>
        <div class="row">
            <!-- left column -->
            <div class="col-md-6">
                <!-- general form elements -->
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="box-title">我的帐号</h3>
                    </div>
                    <div class="panel-body">
                        <dl class="dl-horizontal">
                            <dt>用户名</dt>
                            <dd>{$user->user_name}</dd>
                            <dt>邮箱</dt>
                            <dd>{$user->email}</dd>
                            <dt>账户状态</dt>
                            <dd>{$userstatus}</dd>
                            <dt>捐赠金额(折算为RMB)</dt>
                            <dd>{$donate_amount}</dd>
                            <dt>AnyConnect</dt>
                            <dd>{$acstatus}</dd>
                            <dt>Telegram</dt>
                            <dd>
                                {$telestatus}
                                {if $telelink}<a href="{$telelink}">现在绑定</a>{/if}
                            </dd>
                        </dl>

                    </div>
                    <div class="panel-footer">
                        <a class="btn btn-danger btn-sm" href="kill">删除我的账户</a>
                    </div>
                    <!-- /.box -->
                </div>
            </div>
        </div>
        <div class="col-md-6">

            <div class="panel panel-default">
                <div class="panel-heading">
                    礼品码
                </div>
                <!-- /.box-header -->
                <div class="panel-body">
                    <div class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">惊喜?!</label>

                            <div class="col-sm-9">
                                <div class="input-group">
                                    <input type="text" id="gift_code" placeholder="来吧" class="form-control">
                                    <div class="input-group-btn">
                                        <button type="submit" id="gift_code_update" class="btn btn-primary">提交</button>
                                    </div>
                                </div>
                            </div>
                        </div>
    </section>
    <!-- /.content -->
</div><!-- /.content-wrapper -->
<script>
    $(document).ready(function () {
        $("#gift_code_update").click(function () {
            $.ajax({
                type: "POST",
                url: "verifycode",
                dataType: "json",
                data: {
                    gift_code: $("#gift_code").val()
                },
                success: function (data) {
                    if (data.ret) {
                        $("#ss-msg-success").show();
                        $("#ss-msg-success-p").html(data.msg);
                    } else {
                        $("#ss-msg-error").show();
                        $("#ss-msg-error-p").html(data.msg);
                    }
                },
                error: function (jqXHR) {
                    alert("发生错误：" + jqXHR.status);
                }
            })
        })
    })
</script>
{include file='user/footer.tpl'}
