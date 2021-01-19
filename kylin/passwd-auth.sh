#!/bin/bash

#禁用手动选择用户*
sed -i s/greeter\-show\-manual\-login\=true/greeter\-show\-manual\-login\=false/g /usr/share/lightdm/lightdm.conf.d/60-kylin.conf

#不允许重复修改密码*
sed -i "s/service in crond quiet use_uid/service in crond quiet use_uid remember=1/g" /etc/pam.d/password-auth

#设置重试时间为10分钟*
grep -Ilr "unlock_time" /etc/pam.d/ | xargs -n1 sed -i s/unlock\_time\=60/unlock\_time\=600/g

#密码过期时间
sed  -i '/PASS_MAX_DAYS/s/99999/30/g' /etc/login.defs