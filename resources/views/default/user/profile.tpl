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
    </section>
    <!-- /.content -->
</div><!-- /.content-wrapper -->
{include file='user/footer.tpl'}
