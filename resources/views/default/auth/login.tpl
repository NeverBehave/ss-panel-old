{include file='auth/header.tpl'}
<body class="login-page">
<div class="login-box">
    <div class="login-logo">
        <a href="#"><b>{$config['appName']}</b></a>
    </div><!-- /.login-logo -->
    <div class="login-box-body no-padding">
        <ul class="nav nav-tabs nav-justified">
            <li role="presentation" class="active"><a href="#" data-login="telegram">使用TG登陆</a></li>
            <li role="presentation"><a href="#" data-login="account">使邮箱登陆</a></li>
        </ul>
        <div class="login-box-main">
            <div class="login-account" style="display: none">
                <p class="login-box-msg">使用邮箱登陆登录到用户中心</p>
                <form>
                    <div class="form-group has-feedback">
                        <input id="email" name="Email" type="text" class="form-control" placeholder="邮箱"/>
                        <span  class="glyphicon glyphicon-envelope form-control-feedback"></span>
                    </div>
                    <div class="form-group has-feedback">
                        <input id="passwd" name="Password" type="password" class="form-control" placeholder="密码"/>
                        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                    </div>
                </form>
            </div>
            <div class="login-telegram">
                <p class="login-box-msg">使用Telegram登录到用户中心</p>
                {if $safecode != null}
                    <form>
                        <p>您的安全码是:<code>{$safecode->safecode}</code></p>
                        <input id="code" type="hidden" name="code" value="{$safecode->safecode}">
                        <p>请不要刷新页面，在<a href="https://telegram.me/DogespeedBot" target="_blank">@DogeSpeedbot</a>处输入下面的的命令,完成认证后点击登陆。</p>
                        <div class="form-group has-feedback">
                            <input id="code-command" type="text" class="form-control" value="/login {$safecode->safecode}" readonly>
                            <span id="code-command-copy-button" class="form-control-feedback" data-clipboard-target="#code-command" data-balloon="复制到剪贴板" data-balloon-pos="up">
                                <img width="14" src="/assets/public/img/clippy.svg">
                            </span>
                        </div>
                    </form>
                {/if}
                {if $error != null}
                    <!--{$error}-->
                {/if}
            </div>
            <div class="row">
                <div class="col-xs-8">
                    <div class="checkbox icheck">
                        <label>
                            <input id="remember_me" value="week" type="checkbox"> 记住我
                        </label>
                    </div>
                </div><!-- /.col -->
                <div class="col-xs-4">
                    <button id="login" type="submit" class="btn btn-primary btn-block btn-flat">登录</button>
                </div><!-- /.col -->
            </div>
            <div id="msg-success" class="alert alert-info alert-dismissable" style="display: none;">
                <button type="button" class="close" id="ok-close" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-info"></i> 登录成功!</h4>
                <p id="msg-success-p"></p>
            </div>
            <div id="msg-error" class="alert alert-warning alert-dismissable" style="display: none;">
                <button type="button" class="close" id="error-close" aria-hidden="true">&times;</button>
                <h4><i class="icon fa fa-warning"></i> 出错了!</h4>
                <p id="msg-error-p"></p>
            </div>
            <a class="login-account" style="display: none" href="/password/reset">忘记密码</a>
        </div>
    </div><!-- /.login-box-body -->
</div><!-- /.login-box -->

<!-- jQuery 2.1.3 -->
<script src="/assets/public/js/jquery.min.js"></script>
<!-- Bootstrap 3.3.2 JS -->
<script src="/assets/public/js/bootstrap.min.js" type="text/javascript"></script>
<!-- iCheck -->
<script src="/assets/public/js/icheck.min.js" type="text/javascript"></script>
<!-- clipboard -->
<script src="/assets/public/js/clipboard.min.js" type="text/javascript"></script>
<script>
    $(function () {
        $('input').iCheck({
            checkboxClass: 'icheckbox_square-blue',
            radioClass: 'iradio_square-blue',
            increaseArea: '20%' // optional
        });
    });
    // $("#msg-error").hide(100);
    // $("#msg-success").hide(100);
</script>
<script>
    $(document).ready(function(){
        function login(){
            if($(".active a").data("login") === "telegram"){
                $url = "/auth/tglogin";
                $data = {
                    code: $("#code").val(),
                    remember_me: $("#remember_me").val()
                };
            }else{
                $url = "/auth/login";
                $data = {
                    email: $("#email").val(),
                    passwd: $("#passwd").val(),
                    remember_me: $("#remember_me").val()
                };
            }
            $.ajax({
                type:"POST",
                url:$url,
                dataType:"json",
                data:$data,
                success:function(data){
                    if(data.ret == 1){
                        $("#msg-error").hide(10);
                        $("#msg-success").show(100);
                        $("#msg-success-p").html(data.msg);
                        window.setTimeout("location.href='/user'", 2000);
                    }else{
                        $("#msg-success").hide(10);
                        $("#msg-error").show(100);
                        $("#msg-error-p").html(data.msg);
                    }
                },
                error:function(jqXHR){
                    $("#msg-error").hide(10)
                                   .show(100);
                    $("#msg-error-p").html("发生错误："+jqXHR.status);
                }
            });
        }
        $("html").keydown(function(event){
            if(event.keyCode==13){
                login();
            }
        });
        $("#login").click(function(){
            login();
        });
        $("#ok-close").click(function(){
            $("#msg-success").hide(100);
        });
        $("#error-close").click(function(){
            $("#msg-error").hide(100);
        });
        $(".nav a").click(function () {
            $(".nav li").removeClass("active");
            $(this).closest("li").addClass("active");
            $(".login-telegram, .login-account").hide();
            $(".login-"+this.dataset.login).show();
            return false;
        });
        var spans = document.querySelector('#code-command-copy-button');
        var clipboard = new Clipboard(spans);
        clipboard.on('success', function(e) {
            e.trigger.dataset.balloon = "复制成功";
        });
        clipboard.on('error', function(e) {
            e.trigger.dataset.balloon = "复制失败";
        });
    })
</script>
<div style="display:none;">
    {$analyticsCode}
</div>
</body>
</html>