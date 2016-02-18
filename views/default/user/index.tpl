{include file='user/main.tpl'}

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            用户中心
            <small>User Center</small>
        </h1>
    </section>

    <!-- Main content -->
    <section class="content">
        <!-- START PROGRESS BARS -->
        <div class="row">
            <div class="col-md-6">
                <div class="box box-solid">
                    <div class="box-header">
                        <h3 class="box-title">公告</h3>
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <p>本站为更自由的互联网而设。</p>
                        <p>目前我们为 Android、Linux、Windows、iOS 平台提供 Shadowsocks 服务（iOS 提供 Surge 配置文件），未来会推出 AnyConnect 服务以及 APNP 代理。</p>
                        <p>本站试运营阶段，欢迎测试，流量可通过签到获取。</p>
                        <div class="container-fluid" style="padding: 0;">
                            <div class="row">
                                <div class="col-md-6">
                                    <h4>Telegram</h4>
                                    <ul class="contact-list">
                                        <li><a href="https://telegram.me/joinchat/BT1VETxgj8mgyak2bKQTzA"><img src="/assets/public/img/group-circle.png"/><span class="caption">群组</span></a></li>
                                        <li><a href="https://telegram.me/SSWorldOfficialChannel"><img src="/assets/public/img/channel-circle.png"/><span class="caption">广播频道</span></a></li>
                                    </ul>
                                </div>
                                <div class="col-md-6">
                                    <h4>Google+</h4>
                                    <ul class="contact-list">
                                        <li><a href="https://plus.google.com/communities/114240734505889909332"><img src="/assets/public/img/gplus-circle.png"/><span class="caption">社区</span></a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div><!-- /.box-body -->
                </div><!-- /.box -->
            </div><!-- /.col (right) -->

            <div class="col-md-6">
                <div class="box box-solid">
                    <div class="box-header">
                        <h3 class="box-title">流量使用情况</h3>
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <div class="progress progress-striped">
                            <div class="progress-bar progress-bar-primary" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: {$user->trafficUsagePercent()}%">
                                <span class="sr-only">Transfer</span>
                            </div>
                        </div>
                        <p> 总流量：{$user->enableTraffic()}</p>
                        <p> 已用流量：{$user->usedTraffic()}  </p>
                        <p> 剩余流量：{$user->unusedTraffic()} </p>
                        <p> 下月流量：{$user->nextMonthTraffic()} </p>
                    </div><!-- /.box-body -->
                </div><!-- /.box -->
            </div><!-- /.col (left) -->



            <div class="col-md-6">
                <div class="box box-solid">
                    <div class="box-header">
                        <h3 class="box-title">签到获取流量</h3>
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <p> {$config["checkinTime"]}小时内可以签到一次。</p>
                        {if $user->isAbleToCheckin() }
                        <p id="checkin-btn"> <button id="checkin" class="btn btn-success  btn-flat">汪！</button></p>
                        {else}
                        <p><a class="btn btn-success btn-flat disabled" href="#">不能汪</a> </p>
                        {/if}
                        <p id="checkin-msg" ></p>
                        <p>上次签到时间：<code>{$user->lastCheckInTime()}</code></p>
                    </div><!-- /.box-body -->
                </div><!-- /.box -->
            </div><!-- /.col (right) -->

            <div class="col-md-6">
                <div class="box box-solid">
                    <div class="box-header">
                        <h3 class="box-title">连接信息</h3>
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        {if $user->ac_enable}
                        <h4>Shadowsocks</h4>
                        {/if}
                        <p> 端口：<code>{$user->port}</code> </p>
                        <p> 密码：{$user->passwd} </p>
                        <!--<p> 自定义加密：<code>{$user->method}</code> </p>-->
                        <p> 最后使用时间：<code>{$user->lastSsTime()}</code> </p>
                        {if $user->ac_enable}
                        <h4>AnyConnect</h4>
                        <p>  用户名：<code>{$user->ac_user_name}</code> </p>
                        <p>  密码：<code>{$user->ac_passwd}</code> </p>
                        {/if}
                    </div><!-- /.box-body -->
                </div><!-- /.box -->
            </div><!-- /.col (right) -->
        </div><!-- /.row -->
        <!-- END PROGRESS BARS -->
    </section><!-- /.content -->
</div><!-- /.content-wrapper -->

<script>
    $(document).ready(function(){
        $("#checkin").click(function(){
            $.ajax({
                type:"POST",
                url:"/user/checkin",
                dataType:"json",
                success:function(data){
                    $("#checkin-msg").html(data.msg);
                    $("#checkin-btn").hide();
                },
                error:function(jqXHR){
                    alert("发生错误："+jqXHR.status);
                }
            })
        })
    })
</script>


{include file='user/footer.tpl'}
