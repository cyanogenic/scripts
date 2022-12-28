#!/bin/bash

# 用户名
USERNAME=
# 密码
USERPWD=

usage()
{
    echo -e "\nUsage\n  $0 [options]\n\nOptions:\n  -i\tLogin\n  -o\tLogout" 1>&2
    exit 1
}

while getopts "ioh" OPTION;
do
    case $OPTION in
        i)
            RET=`curl -k -s -d "username=$USERNAME&userpwd=$USERPWD" -X POST https://192.168.5.5/cgi-bin/ace_web_auth.cgi | grep "login_online_detail.php"`
	    if [[ -n $RET ]];
	    then
		    exit 0
	    else
		    echo "Login failed!" 1>&2
		    exit 1
	    fi
            ;;
        o)
	    curl -k -s -o /dev/null https://192.168.5.5/cgi-bin/ace_web_auth.cgi?logout=1
	    ;;
        h)
            usage
            ;;	    
        *)
            usage
	    ;;
    esac
done
