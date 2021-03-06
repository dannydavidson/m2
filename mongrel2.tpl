# handler for auth
auth_handler = Handler(send_spec='tcp://127.0.0.1:7010', 
                send_ident='34f9ceee-cd52-4b7f-b197-88bf2f0ec378', 
                recv_spec='tcp://127.0.0.1:7011', 
                recv_ident='')

# handler for service
service_handler = Handler(send_spec='tcp://127.0.0.1:7002', 
                          send_ident='34f9ceee-cd52-4b7f-b197-88bf2f0ec378', 
                          recv_spec='tcp://127.0.0.1:7003', 
                          recv_ident='')

# proxy for ecomm
ecomm_proxy = Proxy(addr='127.0.0.1', port=3000) 

# auth host
auth = Host(name="{login_host}", routes={{
    '/': auth_handler
}})

# ecomm host
ecomm = Host(name="{ecomm_host}", routes={{
    '/': ecomm_proxy
}})

# root host
root = Host(name="{root_host}", routes={{
    '/': service_handler
}})

# server
main = Server( 
    uuid="2f62bd5-9e59-49cd-993c-3b6013c28f05", 
    access_log="/logs/access.log", 
    error_log="/logs/error.log", 
    chroot=".", 
    pid_file="/run/mongrel2.pid", 
    default_host="{root_host}", 
    name="main", 
    port={PORT}, 
    filters = [], 
    hosts=[root, auth, ecomm]
) 

settings = {{"zeromq.threads": 1,
            "control_port": "ipc:///run/m2.port"}}

servers = [main]
