vpn() {
    case $1 in
   c-on)   	  sudo systemctl start   wg-quick@wgcf;;
   c-status)  sudo systemctl status  wg-quick@wgcf;;
   c-restart) sudo systemctl restart wg-quick@wgcf;;
   c-off)     sudo systemctl stop    wg-quick@wgcf;;
   p-on) 	  sudo systemctl start   wg-quick@usProton;;
   p-off) 	  sudo systemctl stop    wg-quick@usProton;;
   p-restart) sudo systemctl restart wg-quick@usProton;;
   p-status)  sudo systemctl status  wg-quick@usProton;;
   *)		  printf "p-on | c-on | p-off | c-off\n"
    esac
}
