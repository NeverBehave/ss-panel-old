<?php

namespace App\Controllers;

use App\Models\CheckInLog;
use App\Models\InviteCode;
use App\Models\Node;
use App\Models\GiftCode;
use App\Models\TrafficLog;
use App\Services\Auth;
use App\Services\Config;
use App\Services\DbConfig;
use App\Utils\Hash;
use App\Utils\Tools;


/**
 *  HomeController
 */
class UserController extends BaseController
{

    private $user;


    public function __construct()
    {
        $this->user = Auth::getUser();
    }

    public function view()
    {
        $userFooter = DbConfig::get('user-footer');
        return parent::view()->assign('userFooter', $userFooter);
    }

    public function index($request, $response, $args)
    {
        $msg = DbConfig::get('user-index');
        if ($msg == null) {
            $msg = "在后台修改用户中心公告...";
        }
        return $this->view()->assign('msg', $msg)->display('user/index.tpl');
    }

    public function node()
    {
        $msg = DbConfig::get('user-node');
        $user = Auth::getUser();
        $nodes = Node::where('type', '<=', 2)->orderBy('sort')->get();
        if ($user->ac_enable) {
            $acnodes = Node::where('type', '>', 1)->orderBy('sort')->get();
            return $this->view()->assign('nodes', $nodes)->assign('acnodes', $acnodes)->assign('user', $user)->assign('msg', $msg)->display('user/node.tpl');
        }
        return $this->view()->assign('nodes', $nodes)->assign('user', $user)->assign('msg', $msg)->display('user/node.tpl');
    }


    public function nodeInfo($request, $response, $args)
    {
        $id = $args['id'];
        $node = Node::find($id);

        if ($node == null) {

        }
        $ary['server'] = $node->server;
        $ary['server_port'] = $this->user->port;
        $ary['password'] = $this->user->passwd;
        $ary['method'] = $node->method;
        if ($node->custom_method) {
            $ary['method'] = $this->user->method;
        }
        $json = json_encode($ary);
        $json_show = json_encode($ary, JSON_PRETTY_PRINT);
        $ssurl = $ary['method'] . ":" . $ary['password'] . "@" . $ary['server'] . ":" . $ary['server_port'];
        $ssqr = "ss://" . base64_encode($ssurl);

        $surge_base = Config::get('baseUrl') . "/downloads/ProxyBase.conf";
        $surge_proxy = "#!PROXY-OVERRIDE:ProxyBase.conf\n";
        $surge_proxy .= "[Proxy]\n";
        $surge_proxy .= "Proxy = custom," . $ary['server'] . "," . $ary['server_port'] . "," . $ary['method'] . "," . $ary['password'] . "," . Config::get('baseUrl') . "/downloads/SSEncrypt.module";
        return $this->view()->assign('json', $json)->assign('json_show', $json_show)->assign('ssqr', $ssqr)->assign('surge_base', $surge_base)->assign('surge_proxy', $surge_proxy)->display('user/nodeinfo.tpl');
    }

    public function profile($request, $response, $args)
    {
        $donate_amount = $this->user->donate_amount;
        $userstatus = $this->user->enable ? "正常" : "被禁用";
        $acstatus = $this->user->ac_enable ? "已开通" : "未开通";
        $telestatus = $this->user->telegram_id;
        if ($telestatus) {
            $telestatus .= " 为当前用户绑定的ID\r\n";
            $telestatus .= "已绑定";
        } else {
            $telestatus = "未绑定";
        }
        if (!$this->user->telegram_id) {
            $teletoken = Tools::genRandomChar(32);
            $this->user->telegram_token = $teletoken;
            $this->user->save();
            $telelink = "https://telegram.me/" . Config::get("telegramBot") . "?start=$teletoken";
        } else {
            $telelink = "";
        }
        return $this->view()->assign('donate_amount', $donate_amount)->assign('userstatus', $userstatus)->assign('acstatus', $acstatus)->assign('telestatus', $telestatus)->assign('telelink', $telelink)->display('user/profile.tpl');
    }

    public function edit($request, $response, $args)
    {
        return $this->view()->display('user/edit.tpl');
    }


    public function invite($request, $response, $args)
    {
        $codes = $this->user->inviteCodes();
        return $this->view()->assign('codes', $codes)->display('user/invite.tpl');
    }

    public function doInvite($request, $response, $args)
    {
        $n = $this->user->invite_num;
        if ($n < 1) {
            $res['ret'] = 0;
            return $response->getBody()->write(json_encode($res));
        }
        for ($i = 0; $i < $n; $i++) {
            $char = Tools::genRandomChar(32);
            $code = new InviteCode();
            $code->code = $char;
            $code->user_id = $this->user->id;
            $code->save();
        }
        $this->user->invite_num = 0;
        $this->user->save();
        $res['ret'] = 1;
        return $this->echoJson($response, $res);
    }

    public function sys($request, $response, $args)
    {
        return $this->view()->assign('ana', "")->display('user/sys.tpl');
    }

    public function updatePassword($request, $response, $args)
    {
        $oldpwd = $request->getParam('oldpwd');
        $pwd = $request->getParam('pwd');
        $repwd = $request->getParam('repwd');
        $user = $this->user;
        if (!Hash::checkPassword($user->pass, $oldpwd)) {
            $res['ret'] = 0;
            $res['msg'] = "旧密码错误";
            return $response->getBody()->write(json_encode($res));
        }
        if ($pwd != $repwd) {
            $res['ret'] = 0;
            $res['msg'] = "两次输入不符合";
            return $response->getBody()->write(json_encode($res));
        }

        if (strlen($pwd) < 8) {
            $res['ret'] = 0;
            $res['msg'] = "密码太短啦";
            return $response->getBody()->write(json_encode($res));
        }
        $hashPwd = Hash::passwordHash($pwd);
        $user->pass = $hashPwd;
        $user->save();

        $res['ret'] = 1;
        $res['msg'] = "ok";
        return $this->echoJson($response, $res);
    }

    public function updateSsPwd($request, $response, $args)
    {
        $user = Auth::getUser();
        $pwd = $request->getParam('sspwd');
        $user->updateSsPwd($pwd);
        $res['ret'] = 1;
        return $this->echoJson($response, $res);
    }

    public function updateAcPwd($request, $response, $args)
    {
        $user = Auth::getUser();
        if ($user->ac_enable) {
            $pwd = $request->getParam('acpwd');
            if (strlen($pwd) < 8) {
                $res['ret'] = 0;
                $res['msg'] = "密码太短啦";
            } else {
                $user->updateAcPwd($pwd);
                $res['ret'] = 1;
            }
        } else {
            $res['ret'] = 0;
        }
        return $response->getBody()->write(json_encode($res));
    }


    public function updateMethod($request, $response, $args)
    {
        $user = Auth::getUser();
        $method = $request->getParam('method');
        $method = strtolower($method);
        $user->updateMethod($method);
        $res['ret'] = 1;
        return $this->echoJson($response, $res);
    }

    public function logout($request, $response, $args)
    {
        Auth::logout();
        $newResponse = $response->withStatus(302)->withHeader('Location', '/auth/login');
        return $newResponse;
    }

    public function doCheckIn($request, $response, $args)
    {
        if (!$this->user->isAbleToCheckin()) {
            $res['msg'] = "您似乎已经签到过了...";
            $res['ret'] = 1;
            return $response->getBody()->write(json_encode($res));
        }
        // $traffic = rand(Config::get('checkinMin'),Config::get('checkinMax'));
        $traffic = rand($this->user->getCheckinMin(), $this->user->getCheckinMax());
        $trafficnext = rand($this->user->getCheckinMin(), $this->user->getCheckinMax()) / 2;
        $this->user->transfer_enable = $this->user->transfer_enable + Tools::toMB($traffic);
        $this->user->transfer_enable_next = $this->user->transfer_enable_next + Tools::toMB($trafficnext);
        $this->user->last_check_in_time = time();
        $this->user->save();
        // checkin log
        try {
            $log = new CheckInLog();
            $log->user_id = Auth::getUser()->id;
            $log->traffic = $traffic;
            $log->checkin_at = time();
            $log->save();
        } catch (\Exception $e) {
        }
        $res['msg'] = sprintf("获得了本月 %u MB流量，下月 %u MB流量。", $traffic, $trafficnext);
        $res['ret'] = 1;
        return $this->echoJson($response, $res);
    }

    public function kill($request, $response, $args)
    {
        return $this->view()->display('user/kill.tpl');
    }

    public function handleKill($request, $response, $args)
    {
        $user = Auth::getUser();
        $passwd = $request->getParam('passwd');
        // check passwd
        $res = array();
        if (!Hash::checkPassword($user->pass, $passwd)) {
            $res['ret'] = 0;
            $res['msg'] = " 密码错误";
            return $this->echoJson($response, $res);
        }
        Auth::logout();
        $user->delete();
        $res['ret'] = 1;
        $res['msg'] = "GG!您的帐号已经从我们的系统中删除.";
        return $this->echoJson($response, $res);
    }

    public function trafficLog($request, $response, $args)
    {
        $pageNum = 1;
        if (isset($request->getQueryParams()["page"])) {
            $pageNum = $request->getQueryParams()["page"];
        }
        $traffic = TrafficLog::where('user_id', $this->user->id)->orderBy('id', 'desc')->paginate(15, ['*'], 'page', $pageNum);
        $traffic->setPath('/user/trafficlog');
        return $this->view()->assign('logs', $traffic)->display('user/trafficlog.tpl');
    }

    public function getAllNodes($request)
    {
        //init
        $part = "";
        $nodes = Node::whereRaw('type = 1 or type = 3')->orderBy('sort')->get();
        $part_style = <<<EOF
<p>
 {
"server" : "%s",
"server_port" :%s,
"password" : "%s",
"method" : "%s",
"remarks" : "%s"  }
</p>
EOF;
        //json 完整文件配置
        $file_style = <<<EOF
{
"configs" : [
            %s
            ],
"strategy" : null,
"index" : 10,
"global" : false,
"enabled" : false,
"shareOverLan" : false,
"isDefault" : false,
"localPort" : 1080,
"pacUrl" : null,
"useOnlinePac" : false,
"availabilityStatistics" : false
}
EOF;
        //start dash!
        foreach ($nodes as $node) {
            $id = $node->id;
            $name = $node->name;
            $address = $node->server;
            if ($node->custom_method == 1) {                        //judgement for method
                $method = $this->user->method;
            } Else {
                $method = $node->method;
            }
            $rate = $node->traffic_rate;
            $port = $this->user->port;
            $note = "节点ID:" . $id . ";节点名称" . $name . " 流量比例" . $rate;
            $note .= $node->info;
            $password = $this->user->passwd;
            $part .= "\r\n";
            $part .= sprintf(
                $part_style,
                $address,
                $port,
                $password,
                $method,
                $note
            );
            $part .= ",";
        }
        $file = sprintf(
            $file_style,
            $part
        );
        return $this->view()->assign('file', $file)->display('user/json.tpl');
    }

    /**
     * @param $request
     * @param $response
     * @param $args
     * @return mixed
     */
    public function verifyCode($request, $response, $args)
    {
        $get_code = $request->getParam('gift_code');

        if ( GiftCode::where('code', $get_code)->value('code') == null) {
            $res['ret'] = 0;
            $res['msg'] = " 礼品码不存在!";
            return $this->echoJson($response, $res);               //不存在
        }
        
        $code = GiftCode::where('code', $get_code)->first();

        $get_date = $code->expire_at;

        if ($get_date !== null) {
            $get_date = strtotime($get_date);
            $now = strtotime("now");
            if ($get_date - $now < 0) {
                $res['ret'] = 0;
                $res['msg'] = "礼品码已经过期!";
                return $this->echoJson($response, $res); //过期
            }
        }
        $user_id = $this->user->id;
        $user_type = $this->user->user_type;
        $level = $code->level;
        if ( $level > $user_type ) {
            $res['ret'] = 0;
            $res['msg'] = "Doge等级不足以使用邀请码";
            return $this->echoJson($response, $res);       //权限不够
        }

        $users = $code->used_users;
        $ids = explode("|", $users);
        if ( in_array($user_id, $ids) ) {
            $res['ret'] = 0;
            $res['msg'] = "这只Doge使用过这个礼品码了呢!";
            return $this->echoJson($response, $res);      //使用过了
        }

        //Start Dash!
        $code_type = $code->code_type;
        switch ($code_type) {
            case 0:  //流量
                $traffic = $code->traffic;
                $this->user->transfer_enable = $this->user->transfer_enable + Tools::toGB($traffic);
            break;

            case 1:  //等级
                $level = $code->gift_level;
                $this->user->user_type = $level;
            break;

            case 2:  //Anyconnect
                if( $this->user->ac_enable) continue;
                $acname = Tools::genRandomChar(16);
                while(User::where("ac_user_name","=",$acname)->count())
                        $acname = Tools::genRandomChar(16);
                    $acpasswd = Tools::genRandomChar(16);
                    $this->user->ac_enable = 1;
                    $this->user->ac_user_name = $acname;
                    $this->user->ac_passwd = $acpasswd;
                break;

            case 3:  //Telegram 用户验证需要
                $telegram_id = $this->user->telegram_id;
                if ($telegram_id <= 0) {
                    $res['ret'] = 0;
                    $res['msg'] = "这个礼品码要Doge绑定telegram才能用!";
                    return $this->echoJson($response, $res);             //没有绑定telegram
                }
                $traffic = $code->traffic;
                $this->user->transfer_enable = $this->user->transfer_enable + Tools::toGB($traffic);
        }
        $this->user->gift_count += 1;
        $code->counts += 1;
        $code->used_users .= "|" . $this->user->id;

        if (!$code->save()){
            $res['ret'] = 0;
            $res['msg'] = "应用信息到礼品码时发生错误,请重试";
            return $this->echoJson($response, $res);
        }
        if (!$this->user->save()) {
            $res['ret'] = 0;
            $res['msg'] = "添加失败!请联系管理员";
            return $this->echoJson($response, $res);
        }
        $res['ret'] = 1;
        $res['msg'] = "邀请码应用成功!";
        switch ($code_type){
            case 0:
               $res['msg'].="\r\n_{$traffic}_GB流量已经生效。" ;
                break;
            case 1;
                $res['msg'].="\r\nDoge等级目前是_{$level}_";
                break;
            case 2:
                $res['msg'].="\r\nAnyConnect 已开通";
                break;
        }
        return $this->echoJson($response, $res);
    }

}
